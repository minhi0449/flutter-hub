// view model
// 글쓰기 화면 뷰 모델
// 화면 클래스에서 관리해야 하는 데이터 , 기능을 여기로 옮기자
/// 그리고  상태 관리까지

import 'package:class_f_story/_core/utils/exception_handler.dart';
import 'package:class_f_story/data/gvm/post_event_notifier.dart';
import 'package:class_f_story/data/repository/user_repository.dart';
import 'package:class_f_story/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../_core/utils/my_http.dart';
import '../repository/post_repository.dart';

/*
  날짜 : 2025.02.06 (목)
  이름 : 김민희
  내용 : 게시글 작성 뷰 모델 구현 (상태 관리 및 게시글 저장 기능 포함)
 */

// dto 만들기 싫어서 배웠던 문법 -> 레코드
// 모델 post 사용해도 되지만 --> 레코드 --> (post 모델 활용)
class PostWriteViewModel
    extends Notifier<(String? title, String? content, bool isWriteCompleted)> {
  // 뷰 모델에서 컨텍스트를 사용하는 방안
  final mContext = navigatorkey.currentContext!;
  // userRepository 를 * 컴포지션 관계로 선언을 하는데 -> 2개 부를 필요 없고 하나만 선언해준다는 의미로 const 적어줌
  PostRepository postRepository = const PostRepository();

  // 상태값을 초기화 해야 된다.
  // @override
  // State build(){
  //
  // }

  // 상태값을 초기화 해야 된다.
  @override
  (String? title, String? content, bool isWriteCompleted) build() {
    // state ==(String? title, String? content, bool isWriteCompleted)
    return (null, null, false);
  }

  // 행위 - 게시글 작성
  // 뷰 모델에서는 기본 데이터 타입 형태로 설계 (자바에서 맞는 말)
  // 0. 뷰 모델에서는 예외처리를 하자.
  // 1. 데이터 Map 구조로 변환 처리
  // 2. 응답 --> success --> false
  // 3. 응답 --> success --> true
  Future<void> createPost(
      {required String title, required String content}) async {
    try {
      // 게시글 API 요청하는 클래스 (post_)
      // 데이터 가공 처리
      final body = {"title": title, "content": content};
      Map<String, dynamic> resBody = await postRepository.save(body);
      // Response response = await dio.post('/api/post', data: body);
      // Map<String, dynamic> responseBody = response.data;

      // 2.
      if (!resBody['success']) {
        ExceptionHander.handerException(
            resBody['errorMassage'], StackTrace.current);
        return; // 실행의 제어권 반납
      }

      // 시스템 키보드가 있다면 자동 닫기
      FocusScope.of(mContext as BuildContext).unfocus();
      // 게시글 완성 메세지
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text('게시글 등록 완료')));
      // 상태 갱신 처리
      state = (null, null, true);

      // 리버팟 장점 ->
      // postEventProvider (none.. 상태를 postCreate 상태를 변경 처리)
      ref.read(postEventProvider.notifier).postCreate();
    } catch (e, stackTrace) {
      ExceptionHander.handerException('게시글 등록 시 오류 발생', stackTrace);
    } // end of catch
  } // end of createPost (= 게시글 작성 행위)
}

// 창고 관리 만들기
final postWriteViewModelProvider = NotifierProvider<
    PostWriteViewModel,
    (
      String? title,
      String? content,
      bool isWriteCompleted
    )>(() => PostWriteViewModel());
