// 게시글 상세보기 담기 위한 모델
import 'post.dart';

class PostDetail {
  Post post;

  PostDetail({required this.post}); // 포함 관계 설계
  PostDetail copyWith({Post? post}) {
    return PostDetail(post: post ?? this.post);
  }

  PostDetail.fromMap(Map<String, dynamic> map) : post = Post.fromMap(map);
}
