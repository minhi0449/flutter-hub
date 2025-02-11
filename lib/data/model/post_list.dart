// 게시글 목록 모델링 해보기

/*
    날짜 : 2025.02.07 (금)
    이름 : 김민희
    내용 : 게시글 목록 모델링 해보기, 팩토리 생성자
 */

import 'post.dart';

class PostList {
  bool isFirst;
  bool isLast;
  int pageNumber;
  int size;
  int totalPage;
  List<Post> posts;

  // 기본 생성자
  PostList({
    required this.isFirst,
    required this.isLast,
    required this.pageNumber,
    required this.size,
    required this.totalPage,
    required this.posts,
  });

// 네임드 생성자
//   PostList.fromMap(Map<String, dynamic> map)
//       : isFirst = map["isFirst"] ?? false,
//         isLast = map["isLast"] ?? false,
//         pageNumber = map["pageNumber"] ?? 0,
//         size = map["size"] ?? 10,
//         totalPage = map["totalPage"] ?? 1,
//         posts = (map["posts"] as List<dynamic>? ?? [])
//             .map((e) => Post.fromMap(e))
//             .toList();
// }

// 팩토리 생성자를 사용해보자.
  factory PostList.fromMap(Map<String, dynamic> map) {
    // 바디가 있다는 말은 우리가 제어 할 수 있다는 말과 같음
    // if(map['posts']==null){
    //    return PostList. 서브타입
    // }
    // try{} catch(e){
    //
    // }
    // 중간에 if문 사용하고 싶다면 팩토리 생성자 사용하면 됨
    // 다른 리턴 객체를 때릴 수 있음
    return PostList(
      isFirst: map['isFirst'] ?? false,
      isLast: map['isLast'] ?? false,
      pageNumber: map['pageNumber'] ?? 0,
      size: map['size'] ?? 10,
      totalPage: map['totalPage'] ?? 1,
      posts: (map['posts'] as List<dynamic?> ?? [])
          .map((e) => Post.fromMap(e))
          .toList(),
    );
  }


  PostList? copyWith({required List<Post> post}) {}

}
// 중괄호가 없다는 뜻은?
// try-catch를 못한다는 뜻이고
