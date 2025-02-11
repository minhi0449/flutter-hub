import 'package:class_f_story/data/_vm/post_list_view_model.dart';
import 'package:class_f_story/ui/pages/post/list_page/widgets/post_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../data/model/post_list.dart';

/*
  날짜 : 2025.02.11 (화)
  이름 : 김민희
  내용 :

 */

class PostListBody extends ConsumerWidget {
  const PostListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 (데이터) 구독 (데이터가 변경되면 화면 자동 갱신)
    PostList? model = ref.watch(postListProvider);
    PostListViewModel vm = ref.read(postListProvider.notifier);

    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SmartRefresher(
        controller: vm.refreshController,
        enablePullUp: true, // 아래로 스크롤 하면 동작 이벤트
        onRefresh: () async => vm.init(),
        child: ListView.separated(
          itemBuilder: (context, index) => PostListItem(model.posts[index]),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: model.posts.length,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('f-story'),
      ),
    );
  }
}
