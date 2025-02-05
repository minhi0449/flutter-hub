import 'package:dio/dio.dart';

import '../../_core/utils/logger.dart';
import '../../_core/utils/my_http.dart';
// dio 객체 때문에 get, post, put, fetch, delete 사용할 수 있다.

// 외부 api 에 접근해서 데이터를 가져오는 역할을 하는 객체로 설계

class UserRepository {
  const UserRepository();

  // 사용자 등록 요청
  Future<Map<String, dynamic>> save(Map<String, dynamic> reqData) async {
    Response response = await dio.post('/join', data: reqData);
    // 바디 추출
    Map<String, dynamic> responseBody =
        response.data; // header, body 중에 body 만 추출
    logger.i(responseBody);
    return responseBody;
  }

  // 1. 로그인 요청 (레코드 문법)
  // 레코드 문법을 사용해 보자. DTO 설계 없이 바로 리턴() 괄호로 시작
  // dart 3.0 이상 부터 사용가능
  // 그리고 보통 통신하는 코드에서 기본적으로 예외처리는 무조건 해야 한다.
  // 뷰 모델이 Repository 를 사용하는 구조
  // dto 메서드 이름 json 던질 데이터
  Future<(Map<String, dynamic>, String)> findByUsernameAndPassword(
      Map<String, dynamic> reqData) async {
    // HTTP 응답 메세지 (이미지 화)
    Response response = await dio.post('/login', data: reqData);
    // 헤더 JWT 토큰 추출
    String accessToken = response.headers['Authorization']?[0] ?? '';
    logger.i(accessToken);
    Map<String, dynamic> responseBody = response.data; // HTTP 응답 메세지 바디
    return (responseBody, accessToken);
  }

  // 회원 등록 요청

  // 자동 로그인 (유튜브 2시간 정도 보고 올 수 있음 -> 다녀 왔는데 귀찮을 수도 있자나)
  // 매법 앱을 실행 시 로그인 요청하는 것은 귀찮아!.

  // ---> 서버 ---> 인증 사용자 판별 ---> 인증 ---> JWT 토큰
  // 로그인 --> 로컬 ---> JWT 토큰 (- 기기에서 토큰 꺼내서 다시 서버로 던져봐야 한다.)
  // 이 녀석 던질 때, 뭐만 던지면 되냐면 토큰만 던지면 됨
  Future<Map<String, dynamic>> loginWithToken(String accessToken) async {
    // (HTTP 메시지) dio 헤더 설정하는 방법!!
    Response response = await dio.post(
      '/auto/login',
      options: Options(
        headers: {'Authorization': accessToken},
      ),
    );
    Map<String, dynamic> responseBody = response.data;
    return responseBody;
  }
}
