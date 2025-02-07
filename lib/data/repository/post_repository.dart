import 'package:dio/dio.dart';

import '../../_core/utils/my_http.dart';

class PostRepository {
  const PostRepository();
  // 1. 게시글 목록 조회
  /// - [page] : 조회할 페이지 번호 (기본 값 0)
  /// - return : 서버로 부터 받은 게시글 목록 (Map 형태)

  // findAll
  // API 문서를 보면 파싱하는 게 Object 라서
  Future<Map<String, dynamic>> findAll({int page = 0}) async {
    // List []; 대괄호
    // MAP {}; 중괄호
    // dio 헤더에 토큰 저장되어 있는 상태이다.
    Response response =
        await dio.get('/api/post', queryParameters: {'page': page});

    // HTTP 전체 응답 메시지에서 바디 부분만 추출해서 뷰 모델로 리턴 시키자.
    // response.headers; // header
    // Map 구조로 다운캐스팅 하고 뷰 모델로 던져 줄 예정
    Map<String, dynamic> responseBody = response.data; // body
    return responseBody;
  }
  ////////////////////////////////////////////////////////////////////////////

  // 게시글 상세 조회
  // findById
  Future<Map<String, dynamic>> findById({required int id}) async {
    // id 값만 던지고, 헤더에 있는 값만 던지면 되니까 응답 코드는 여기까지 작성
    // Response response = await dio.get('api/post/${id}');
    Response response = await dio.get('api/post/$id');

    Map<String, dynamic> responseBody = response.data; // body
    return responseBody;
  }
  ////////////////////////////////////////////////////////////////////////////

  // 게시글 삭제
  // delete
  Future<Map<String, dynamic>> delete(int id) async {
    Response response = await dio.delete('/api/post/${id}');
    Map<String, dynamic> responseBody = response.data;
    return responseBody;
  }
  ////////////////////////////////////////////////////////////////////////////

  // 게시글 생성
  // save
  // Future<Map<String, dynamic>> save(String title, String content) async {
  //   Response response = await dio.post('/api/post', data: );
  //   Map<String, dynamic> responseBody = response.data;
  //   return responseBody;
  // }

  Future<Map<String, dynamic>> save(Map<String, dynamic> reqData) async {
    Response response = await dio.post('/api/post', data: reqData);
    Map<String, dynamic> responseBody = response.data;
    return responseBody;
  }

  ////////////////////////////////////////////////////////////////////////////

  // 게시글 수정
  // update
  Future<Map<String, dynamic>> update(
      int id, Map<String, dynamic> reqData) async {
    Response response = await dio.put('/api/post/$id', data: reqData);
    Map<String, dynamic> responseBody = response.data;
    return responseBody;
  }
}
