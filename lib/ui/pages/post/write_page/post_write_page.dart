import 'package:flutter/material.dart';
import 'widgets/post_write_body.dart';

/*
  날짜 : 2025.02.06 (목)
  이름 : 김민희
  내용 : 게시글 작성 페이지 화면 구성 (앱바 및 본문 포함)
 */

class PostWritePage extends StatelessWidget {
  const PostWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: PostWriteBody(),
      ),
    );
  }
}
