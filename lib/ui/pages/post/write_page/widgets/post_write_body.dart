import 'package:flutter/material.dart';
import 'post_write_form.dart';

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
