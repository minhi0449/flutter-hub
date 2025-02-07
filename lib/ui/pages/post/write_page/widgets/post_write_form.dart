import 'package:class_f_story/_core/constants/size.dart';
import 'package:class_f_story/data/_vm/post_write_view_model.dart';
import 'package:class_f_story/ui/widgets/custom_elevated_button.dart';
import 'package:class_f_story/ui/widgets/custom_text_area.dart';
import 'package:class_f_story/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
  날짜 : 2025.02.06 (목)
  이름 : 김민희
  내용 : 게시글 작성 폼 구현 - 제목, 내용 입력 필드와 글쓰기 버튼으로 구성된 화면
 */

// 게시글 작성하는 페이지
class PostWriteForm extends ConsumerWidget {
  // 폼의 상태, 유효성 검사 ...save() 호출
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  PostWriteForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // post_write_view_model 만드는 게 핵심
    // 뷰 모델 상태를 구독
    // 데이터 타입은 레코드 타입이 되는 거고, (title, content, isWriteCompleted)
    final data = ref.watch(postWriteViewModelProvider);
    // 뷰 모델 행위 사용해야 한다
    final vm = ref.read(postWriteViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextFormField(
              hint: 'title',
              controller: _titleController,
            ),
            const SizedBox(height: smallGap),
            CustomTextArea(
              hint: 'content',
              controller: _contentController,
            ),
            const SizedBox(height: largeGap),
            CustomElevatedButton(
              text: '글쓰기',
              click: () {
                vm.createPost(
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                );

                // 레코드 문법 연습 시키려고 이렇게 짠건뎅
                // 레코드 문법 활용 가능
                if (data.$3 == true) {
                  // 페이지 이동 처리
                  _titleController.clear();
                  _contentController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
