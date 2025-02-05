import 'package:class_f_story/_core/constants/size.dart';
import 'package:class_f_story/data/gvm/session_gvm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/**
 * 날짜 : 2025.02.05 (수)
 * 이름 : 김민희
 * 내용 : 사이드 메뉴(Drawer) - 글쓰기/로그아웃 기능 위젯 구현
 */

class CustomDrawer extends ConsumerWidget {
  // ScaffoldState 스캐아폴드 상태관리 해주는 녀석
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer(this.scaffoldKey, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 뷰모델 들고 있기
    SessionGVM vm = ref.read(sessionProvider.notifier);
    return Container(
      width: getDrawerWidth(context), // 해상도에 맞춰서 width 값 60% 출력
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                // 기능1 -> Drawer 를 닫고
                // 기능2 -> 글쓰기 페이지로 이동
                // scaffoldKey.currentState 이녀석은 null 이 될 수 있기 때문에 null 이 될 수 없다고 설정해줘야 함
                scaffoldKey.currentState!.openEndDrawer();
                // 글쓰기 페이지 이동 처리
                Navigator.pushNamed(context, '/post/write');
              },
              child: const Text(
                // 글쓰기 라는 버튼 클릭 시 -> 자동으로 닫히게 하고 싶음
                '글쓰기',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () async {
                // 로그아웃 호출
                await vm.logout();
                // 코드가 없음
                // 만약에 있다면 vm.logout(); 코드가 어떻게 변해야 함?
                // vm.logout(); 호출하고 아래 코드가 수행되어야 한다면?
                // await 를 걸어줄 수 있음
                //
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
