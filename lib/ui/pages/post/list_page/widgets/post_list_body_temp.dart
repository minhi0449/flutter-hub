// 로컬 상태 관리 (해당 페이지에서만 변경되는 데이터가 있다)
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*
  날짜 : 2025.02.06 (목)
  이름 : 김민희
  내용 : 당기기(새로고침) 및 무한 스크롤(페이징) 기능을 포함한 게시글 목록 UI 구현
 */

class PostListBodyTemp extends StatefulWidget {
  const PostListBodyTemp({super.key});

  @override
  State<PostListBodyTemp> createState() => _PostListBodyTempState();
}

class _PostListBodyTempState extends State<PostListBodyTemp> {
  // 사용자가 당기기, 사용자가 밑에서 올리기 기능이 있다.
  // 여기 이벤트에 따라서 우리는 거기에 맞는 콜백 이벤트를 메서드를 호출하는 게 목적이다.
  // 거기에 맞는 콜백 이벤트 메서드를 호출해야 사용이 가능하다.

  // _refreshController.refreshCompleted() <-- 새로 고침 완료 후 호출
  // _refreshController.loadCompleted () <-- 추가 데이터 로드 완료 후 호출
  RefreshController _refreshController =
      RefreshController(); // 이 녀석이 당기기, 밑에서 올리기 감지 해줌

  // 샘플 데이터
  List<Map<String, dynamic>> _posts = [
    // 하나의 Map이 들어가야 함 {};
    {'id': 1, 'title': '1번째 게시글', 'content': '내용 내용1'},
    {'id': 2, 'title': '2번째 게시글', 'content': '내용 내용2'},
    {'id': 3, 'title': '3번째 게시글', 'content': '내용 내용3'},
    {'id': 4, 'title': '4번째 게시글', 'content': '내용 내용4'},
    {'id': 5, 'title': '5번째 게시글', 'content': '내용 내용5'},
    {'id': 6, 'title': '6번째 게시글', 'content': '내용 내용6'},
    {'id': 7, 'title': '7번째 게시글', 'content': '내용 내용7'},
    {'id': 8, 'title': '8번째 게시글', 'content': '내용 내용8'},
    {'id': 9, 'title': '9번째 게시글', 'content': '내용 내용9'},
    {'id': 10, 'title': '10번째 게시글', 'content': '내용 내용10'},
    {'id': 11, 'title': '11번째 게시글', 'content': '내용 내용11'},
    {'id': 12, 'title': '12번째 게시글', 'content': '내용 내용12'},
    {'id': 13, 'title': '13번째 게시글', 'content': '내용 내용13'},
    {'id': 14, 'title': '14번째 게시글', 'content': '내용 내용14'},
  ];

  @override
  Widget build(BuildContext context) {
    // 외부 사용자가 만든 위젯
    return SmartRefresher(
      controller: _refreshController,
      // enablePullDown : 사용자가 당기는 거 활성화 시키는 거
      enablePullDown: true, // 활성화 : true
      // onRefresh: () {
      //   // 우리 새로고침 해쏘 히히 -> 이 녀석 새로고침 하면
      //   _refreshController.refreshCompleted();
      // },
      onRefresh: _onRefresh,
      enablePullUp: true,
      // onLoading: () {
      //   // 통신 요청 --> 가공 끝나면 완료 처리 해야 함
      //   // 완료
      //   _refreshController.loadComplete();
      // },
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _posts.length,
        // 리스트 구조를 받아서 여러 가지 글을 뿌려줌
        itemBuilder: (context, index) => ListTile(
          title: Text('${_posts[index]['title']}'),
          subtitle: Text('${_posts[index]['content']}'),
        ),
      ),
    );
  }

  // 새로고침 동작의 기본적인 형태
  Future<void> _onRefresh() async {
    // 통신 가정
    await Future.delayed(Duration(seconds: 1)); // 1초 대기 탔다가
    // 데이터가 새로 들어옴
    setState(() {
      _posts = [
        ..._posts,
        // 새로 당기기 하면 새로운 게시글 15,16 여기까지 들어옴
        {'id': 15, 'title': '15번째 게시글', 'content': '내용 내용15'},
        {'id': 16, 'title': '16번째 게시글', 'content': '내용 내용16'},
      ];
    });
  }

  // 페이징 동작 처리 (무한 스크롤)
  // 사용자가 리스트를 맨 아래로 스크롤 할 때, 이벤트 리스너 동작
  // 새로운 데이터를 API 호출해서 상태 갱신을 해주어야 한다.
  Future<void> _onLoading() async {
    // 통신 가정
    await Future.delayed(Duration(seconds: 1)); // 1초 대기 탔다가

    setState(() {
      // 기존에 있던 데이터에 추가로 값을 넣어서 화면 갱신을 하는 겁니다.
      // 여기서는 하드 코딩으로 작성했지만
      // 기존의 데이터 타입 --> 통으로 List 이다.
      // 새로운 API 호출 시 --> 데이터 타입은 10개 --> List 이다.
      // 기존에 리스트에서 + 리스트 하는 방법
      // _posts = _posts + []; 약간 이런 느낌
      _posts.addAll([
        // 자료구조는 최적의 속도로 다 짜여져 있다 -> 우리는 이런 걸 활용해서
        {'id': 21, 'title': '21번째 게시글', 'content': '내용 내용21'},
        {'id': 22, 'title': '22번째 게시글', 'content': '내용 내용22'},
        {'id': 23, 'title': '23번째 게시글', 'content': '내용 내용23'},
        {'id': 24, 'title': '24번째 게시글', 'content': '내용 내용24'},
        {'id': 25, 'title': '25번째 게시글', 'content': '내용 내용25'},
      ]);
    });
    _refreshController.loadComplete();
  }

  // 화면이 종료 될 때, 호출되는 생명주기를 가지고 있다.
  // 스트림이 내부적으로 동작을 한다. -> 발행과 구독 패턴
  // refreshController -> 위젯이 제거 될 때, 메모리에서 해제를 해야 한다.
  // 왜? 메모리 릭이 발생할 수 있다. (메모리 누수)
  @override
  void dispose() {
    _refreshController.dispose(); // 메모리 해제 -> java 에서 scanner 에서 close 해주는 거
    super.dispose();
    // 해제를 안 하면
    // 화면을 이동해서 스트림 리스너가 계속 실행된다.
    // 중첩이 되면 메모리가 점점 증가하면서 엡이 느려진다.
  }
}
