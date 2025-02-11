import 'package:flutter/material.dart';
import 'widgets/post_detail_body.dart';

/*
  날짜 : 2025.02.11 (화)
  이름 : 김민희
  내용 :
 */

class PostDetailPage extends StatelessWidget {
  int postId;
  PostDetailPage({required this.postId, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: PostDetailBody(
          postId: postId,
        ),
      ),
    );
  }
}
