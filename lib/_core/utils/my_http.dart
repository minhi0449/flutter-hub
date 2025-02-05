// API 서버의 기본 URL 설정
// 전역 변수 사용
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final baseUrl = 'http://192.168.0.24:8080';

// 전역 변수 dio <--
final dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    contentType: 'application/json;charset=utf-8',
    // 주의 ! 200 번 이외에는 모두 에러로 간주하게 기본 값 설정되어 있음
    // 다른 상태 코드 다 허용

    // 이걸 적어 주지 않으면 status : 404 라고 상태를 잡기도 전에
    // 에러를 터뜨려 버림 ,,, ㅠㅠ

    validateStatus: (status) => true,
    // 2025.02.03 (월)
    // 모든 응답 코드(400, 500 등)도 성공으로 되는 건지?
  ),
);

// 중요 데이터 보관소 (금고 생성)
// 로컬에 민감한 데이터를 보관하는 안전한 금고 역할을 한다.
const secureStorge = FlutterSecureStorage(); // 전역 변수로
