import 'package:class_f_story/ui/pages/post/list_page/widgets/post_list_body.dart';
import 'package:class_f_story/ui/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

/**
 *  날짜 : 2025.02.05 (수)
 *  이름 : 김민희
 *  내용 : post list page 기본 코드 작성 및 custom_drawer 로그아웃 처리
 */

class PostListPage extends StatelessWidget {
  // scaffoldKey 는 Scaffold 의 상태를 전역적으로 제어하기 위한 키 입니다.
  // 코드로 열였다 닫혔다 하고 싶은 거임
  // 로그아웃 클릭 시 -> 햄버거 버튼 메뉴 닫고 싶은 거임
  // 이 키를 사용하여 Scaffod의 상태 (열기/닫기)를 제어할 수 있음
  // 즉, Drawer를 사용자 이벤트 대신 코드를 통해서 열고 닫기 할 수 있음
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // 키 선정 (= 키 설정) -> 키 설정 안 해주면 -> 자동으로 안 닫힘
        key: scaffoldKey, // 이 녀석으로 키를 구분해라
        // 하위 위젯에 키 전달
        drawer: CustomDrawer(scaffoldKey),
        appBar: AppBar(
          title: Text('f-story'),
        ),
      ),
    );
  }
}
