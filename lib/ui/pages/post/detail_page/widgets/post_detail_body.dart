import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../_core/constants/size.dart';
import '../../../../../data/_vm/post_detail_view_model.dart';
import '../../../../../data/model/post_detail.dart';

class PostDetailBody extends ConsumerWidget {
  final int postId;
  const PostDetailBody({required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Future, Stream, State, Notifier
    PostDetail? model = ref.watch(postDetailProvider(postId));
    // 위에서 if 문도 확인해줌
    if (model == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            // '게시글 1 (temp)',
            '${model.post.title}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          const SizedBox(height: largeGap),
          ListTile(
            // title: Text("사용자 이름"),
            title: Text("${model.post.id}"),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/images/1.png', fit: BoxFit.cover),
            ),
          ),
          // 권한 처리 (sessionUser.id == post.user.id ) 같다면 보여 주기
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  // 권한이 있다면 삭제 기능
                },
                icon: Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  // 수정하기 화면으로 이동 처리
                },
                icon: Icon(CupertinoIcons.pen),
              )
            ],
          ),
          // 권한 처리 (sessionUser.id)
          const Divider(),
          const SizedBox(height: largeGap),
          SingleChildScrollView(
            // child: Text('게시글 내용 표시하기'),
            child: Text('${model.post.content}'),
          )
        ],
      ),
    );
  }
}
