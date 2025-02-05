// 구분 할 거라서
// User Info 랑 구분할 거
// 누가 작성한 글인지
// 로그인 할 때, SessionUser 로 구분 할 것
class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({
    required this.id,
    required this.username,
    required this.accessToken,
    required this.isLogin,
  });
}
