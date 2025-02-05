import 'package:class_f_story/_core/constants/size.dart';
import 'package:flutter/material.dart';

class CustomAuthTextFormField extends StatelessWidget {
  final String text;
  final bool obscureText;
  final TextEditingController controller;

  const CustomAuthTextFormField({
    required this.text,
    this.obscureText = false,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        const SizedBox(height: smallGap),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: 'Enter $text',
            enabledBorder: OutlineInputBorder(
              // 기본 TextFormField 설정한다.
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              // 손가락 터치시 활성화 된 디자인 설정
              borderRadius: BorderRadius.circular(20.0),
            ),
            errorBorder: OutlineInputBorder(
              // 유효설 검사 실패시 사용되는 디자인 설정
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // 에러가 발생 후 손가락을 터치 했을 때 디자인 설정
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }
}
