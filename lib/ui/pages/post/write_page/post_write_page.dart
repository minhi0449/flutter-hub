import 'package:flutter/material.dart';

import 'widgets/post_write_body.dart';

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
