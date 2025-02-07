import 'package:flutter/material.dart';
import 'post_write_form.dart';

/*
  날짜 : 2025.02.06 (목)
  이름 : 김민희
  내용 : 게시글 작성 화면 본문 레이아웃 구현 (입력 폼)
 */

class PostWriteBody extends StatelessWidget {
  const PostWriteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 기본적으로 사용하자
        Flexible(
          child: PostWriteForm(),
        ),
      ],
    );
  }
}
