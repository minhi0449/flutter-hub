import 'package:class_f_story/_core/utils/exception_handler.dart';
import 'package:class_f_story/_core/utils/my_http.dart';
import 'package:class_f_story/data/model/session_user.dart';
import 'package:class_f_story/data/repositoy/user_repository.dart';
import 'package:class_f_story/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 뷰 모델에 날걔를 달아주기로 한 것 -> 어떤 상태를 관리로 했는지
// object 통으로 세션 유저라고 적기

// 뷰 모델 --> 화면에 있는 데이터를 가지고 와서 사용한다.
// 로그인 요청을 할 때, 어떤 변수를 필요할까?
// userRepository.find 를 여기로 들고 온다고

// 뷰 모델에 속성 --> 세션 유저가 된다.
// 뷰 모델의 해위 --> 로그인 행위, 로그아웃 행위, 자동 로그인 행위

class SessionGVM extends Notifier<SessionUser> {
  // 뷰 모델에서 컨텍스트를 사용하는 방안
  final mContext = navigatorkey.currentContext!;
  // 여기서 객체 생성
  UserRepository userRepository = UserRepository();

  // 상태를 초기화 해주어야 한다. (선언형 UI 이기 때문에)
  @override
  SessionUser build() {
    // 추상화 변수 state (외부에서 접근하는 변수명)
    // state ==> SessionUser() 객체가 된다.
    return SessionUser(
      id: null,
      username: null,
      accessToken: null,
      isLogin: false,
    );
  }

  // 로그인 행위
  // 화면에서 뷰 모델에게 로그인 요청 위임
  Future<void> login(String username, String password) async {
    // 로그인 기능을 만들기 위해서는 서버 측으로 던질 데이터를 구축해야 한다.
    try {
      // 요청 HTTP 메세지 body -> 라는 의미로
      final body = {
        'username': username,
        'password': password,
      };
      // api 요청 해야 함 -> userRepository 호출
      final (responseBody, accessToken) =
          await userRepository.findByUsernameAndPassword(body);
      // 서버 측에서 약속 -> 어떻게 던져 주는 지 잘 분석해야 함.
      // 성공 시 true , 실패 시 false
      // 서버 측에서 통신은 성공했으나 , 내부 오류 판단
      if (responseBody['success'] == false) {
        // => if(!responseBody['success']){ 같은 말
        // 사용자에게 로그인 실패 (비번x, 사용명x)
        ExceptionHander.handerException(
          responseBody['errorMessage'],
          StackTrace.current,
        );
        return; // 실행의 제어건 반납
        // 리턴을 적지 않으면 코드가 계속 실행됨
      }
      // 1. JWT 토큰을 안전한 금고에 보관 처리 ->  I/O : 입출력(Input/Output)
      // I/O 는 시간이 많이 걸리기 떄문에 비동기 처리
      await secureStorge.write(key: 'accessToken', value: accessToken);

      // 2. 뷰 모델 상태 갱신
      // 깊은 복사 처리
      // 로그인 성공하면 값을 다시 넣는다고
      Map<String, dynamic> resData = responseBody['response'];
      state = SessionUser(
        id: resData['id'], // key 값으로 접근
        username: resData['username'],
        accessToken: accessToken,
        isLogin: true,
      );

      // 3. 로그인 이후 인증권한 필요한 API 접근 시에
      // 매번 금고에 접근해서 dio 속성 값 변경해서 호출 하는 것은 불편하다.
      // dio 객체를 전역 변수로 설계를 했음

      // 3. Dio 헤더에 JWT 토큰 설정 (객체 상태 값 추가)
      dio.options.headers['Authorization'] = accessToken;

      // 비즈니스 로직마다 다르긴한데
      // 화면 이동 처리 pushNamed -> pushNamed -> pushNamed
      // Navigator stack 메모리에 계속 쌓인다.
      // Navigator.pushNamed(mContext, '/post/list');
      // 이전에 쌓여있던 stack(화면) 다 파괴하면서 이동 처리
      Navigator.popAndPushNamed(mContext, '/post/list');
      // 모든 예외처리를 잡는 곳 -> catch (e)
      // 모든 예외처리가 설정된다.
      // } on DioException catch (e) {}
    } catch (e, stackTrace) {
      // IP 주소가 잘못, 서버가 종료 되어 있을 때, 서버 연결 시간 초과
      ExceptionHander.handerException('서버 연결 실패', stackTrace);
      // 우리가 파악해야 하는 거 -> DTO 도 만들지 않고, 예외처리는
    }
  }

  // 회원 등록 행위
  // 1 단계 - UserRepository 에 회원등록 API 요청 확인
  // 판별의 기준 -> REST api 확인해보렴 미니
  // 위치 기반으로 (String username, String email, String password)
  Future<void> join(String username, String email, String password) async {
    try {
      // MAP 구조로 만들어서 던져 주자
      final body = {
        'username': username,
        'email': email,
        'password': password,
      };
      Map<String, dynamic> resBody = await userRepository.save(body);
      // 통신은 성공이지만 내부 판별 오류 시 방어적 코드 작성
      if (!resBody['success']) {
        ExceptionHander.handerException(
          resBody['errorMessage'],
          StackTrace.current,
        );
        return; // 회원가입 실패 했는데 -> 계속 코드 실행하면 안 되니까
        // 실행의 제어권 반납
      }
      // 성공하면 회원가입 완료 -> 화면 이동 코드
      //ExceptionHander.handerException(resBody['회원가입 성공'], StackTrace.current);

      // 바로 화면 이동 처리
      Navigator.pushNamed(mContext, '/login');
    } catch (e, stackTrace) {
      ExceptionHander.handerException('서버 연결 실패', stackTrace);
    }
  }

  // 로그아웃 행위
  // 1. 디바이스 기기에 토큰 삭제
  // 2. 상태 갱신을 해줘야 하는데 -> SessionGVM이 들고 있는 SessionUser()의 상태를 갱신 해준다
  // 2. 나의 상태 갱신 -> SessionUser()
  // 3. dio 전역 객체 헤더 토큰 제거 ==> '' 빈 문자열 처리
  // 4. 화면 다 파괴하고 LoginPage 페이지 이동 처리
  Future<void> logout() async {
    try {
      // 1.
      await secureStorge.delete(key: "accessToken");
      // 2.
      state = SessionUser(
        id: null,
        username: null,
        accessToken: null,
        isLogin: false,
      );
      // 3.
      dio.options.headers["Authorization"] = '';
      // 4.
      Navigator.pushNamedAndRemoveUntil(
        mContext,
        '/login',
        (route) => false,
      );
    } catch (e, stackTrace) {
      ExceptionHander.handerException('로그아웃 중 오류 발생', stackTrace);
    }
  }

  // 자동 로그인 행위
  // 로직 정리 (단계를 정리하는 습관 기르기)
  // 0. 예외 처리
  // 1. 디바이스 기기에 토큰 확인
  // 2. 디바이스 토큰 유무 확인
  // 3. 토큰 유효성 검사
  // 4. SessionUser 상태 갱신
  // 5. dio 헤더에 토큰 다시 설정
  // 6. 게시글 목록 페이지 이동 처리
  Future<void> autoLogin() async {
    try {
      // 비동기 처리 ---> 코드가 내려가지 않고 완료될 때까지 대기
      // 1. 토큰을 디바이스에서 가져오기
      // 2. JWT 토큰 유무 확인 -> 없으면 로그인 페이지로 이동
      String? accessToken = await secureStorge.read(key: 'accessToken');

      if (accessToken == null) {
        Navigator.popAndPushNamed(mContext, '/login');
        return; // 실행의 제어권 반납한다.
      }

      // 토큰이 있다면 user repository
      // 내부적으로  false
      // "success" --> true, false 로직 설계
      Map<String, dynamic> resBody =
          await userRepository.loginWithToken(accessToken);

      // 서버 내부적으로 오류로 판결 처리
      // "success" --> false
      if (!resBody['success']) {
        // 요즘은 바로 로그인 페이지로 사용자에게 다시 로그인 시킴
        Navigator.popAndPushNamed(mContext, '/login');
        return;
      }

      // "success" --> true
      // 세션 뷰모델은 화면이 파괴되더라도, 가지고 다녀야 됨,
      // 회원정보 수정을 하더라도, 상태 갱신해야 함.
      // 선생님 설명 : 상태 값을 변경할 때, 불변 객체를 사용하자. (= 깊은 복사 처리) 새로운 객체를 만들어서 통으로 바꾸라는 이야기
      // 새로운 객체를 생성해서 넣자

      // 다운 캐스팅
      // 원래 이렇게 적어야 하는데 너무 복잡해서 실수할 경우가 많아서 다운캐스팅 해주기
      resBody['response']['username'];
      // 진짜 다운캐스팅
      Map<String, dynamic> data = resBody['response'];

      state = SessionUser(
        id: data['id'],
        username: data['username'],
        accessToken: accessToken,
        isLogin: true,
      );
      // 상태 변경 완료
      // 혹시 ... dio 헤더에 accessToken 을 다시 설정하자.
      dio.options.headers['Authorization'] = accessToken;
    } catch (e, stackTrace) {
      ExceptionHander.handerException('자동 로그인 중 오류 발생', stackTrace);
      // 화면 파괴하면서 이동 처리
      Navigator.popAndPushNamed(mContext, '/login');
    }
  }
}

// 창고 관리자 선언 (창고 - 뷰모델), 창고 어떤 관리해라 지정!!
final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(
  () => SessionGVM(),
);
