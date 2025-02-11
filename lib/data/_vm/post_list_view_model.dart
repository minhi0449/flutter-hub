// 게시글 목록 화면에서 사용하는 뷰 모델 클래스 이다. + 상태 관리

import 'package:class_f_story/_core/utils/exception_handler.dart';
import 'package:class_f_story/data/model/post_list.dart';
import 'package:class_f_story/data/repository/post_repository.dart';
import 'package:class_f_story/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../_core/utils/logger.dart';

/*
  날짜 : 2025.02.11 (화)
  이름 : 김민희
  내욜 : 게시글 목록 뷰모델 구현 및 상태 관리 (AutoDisposeNotifier, 페이징 처리, 새로고침 기능 포함)
 */

// 게시글 목록은 회원 가입 이동시, 로그인 페이지 이동시
// 뷰 모델 객체를 계속 가지고 있을 필요가 없다.
// AutoDisposeNotifier 를 사용해야 하는 이유를 알자 !!!!
class PostListViewModel extends AutoDisposeNotifier<PostList?> {
  // RefreshController 사용하기로 함
  final refreshController = RefreshController();
  final mContext = navigatorkey.currentContext!;
  final PostRepository postRepository = const PostRepository();

  // 리버팟 2  - (Notifier)
  @override
  PostList? build() {
    // 상태 초기화 코드
    // 해야될 일 1. -> 콜백 메서드 등록 (메모리 해제 등록)
    // onDispose 콜백 등록
    ref.onDispose(
      () {
        logger.d("PostListViewModel 파괴시 실행됨");
        refreshController.dispose(); // 가비지컬렉션이 바로 일어나지 않으니까!!
      },
    );
    // 초기 init 메서드 호출
    // API 통신 요청 처리
    init();
    return null;
  }

  Future<void> init() async {
    try {
      // findAll -  {int page = 0}
      Map<String, dynamic> resBody = await postRepository.findAll();
      if (!resBody['success']) {
        ExceptionHander.handerException(
            resBody['errorMessage'], StackTrace.current);
        return;
      }
      // 상태 변경 (깊은 복사)
      state = PostList.fromMap(resBody['response']);

      // RefreshController 콜백 메서드 호출
      refreshController.refreshCompleted();
    } catch (e, stackTrace) {
      ExceptionHander.handerException('게시글 목록 로딩 중 오류', stackTrace);
    }
  }

  // 페이징 처리 하는 로직 10개 받은 상태이다. -->
  // 1. 현재 상태 값 가져오기 state 에 있음 내 멤버변수
  // 2. 마지막 페이지 여부 확인 (더 이상 들고올 페이지가 없는데 요청할 필요가 없으니끼)
  // 3. 서버에 다음 페이지 요청 (0 --> 현재페이지 + 1)
  // 4. 서버 응답 실패, 성공 여부 처리
  // 5. 성공했다면, 기존에 데이터에 + API를 추가 해주면 된다.
  // 6. 프로그래스바 종료 처리
  Future<void> nextList() async {
    PostList model = state!; // null 일 수도 있기 때문에 null 이 아니야 라고 명시 하기
    // 마지막 페이지가 true 라면?
    if (model.isLast) {
      // 너무 빨리 마지막 페이지라면
      // 마지막 페이지라면 너무 빠른 동작을 한다.
      // UX 개선을 위해 딜레이 추가
      await Future.delayed(Duration(milliseconds: 500)); // 0.5초
      refreshController.loadComplete(); // UI 갱신
      return;
    }
    // API 통신 요청
    // state = postListViewModel
    Map<String, dynamic> responseBody =
        await postRepository.findAll(page: state!.pageNumber + 1);

    if (!responseBody['success']) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text('게시글을 못 불러왔어요 ㅠㅠ')),
      );
      return;
    }
    // 통신이 성공이라면
    PostList preModel = state!;
    PostList nextModel = PostList.fromMap(responseBody['response']);

    state = nextModel.copyWith(post: [...preModel.posts, ...nextModel.posts]);
    refreshController.loadComplete();
  }
}

// 창고 관리자 (창고 규격 )
final postListProvider =
    NotifierProvider.autoDispose<PostListViewModel, PostList?>(
  () => PostListViewModel(),
);
