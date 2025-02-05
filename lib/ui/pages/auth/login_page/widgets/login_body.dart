import 'package:class_f_story/_core/constants/size.dart';
import 'package:class_f_story/data/gvm/session_gvm.dart';
import 'package:class_f_story/ui/widgets/custom_auth_text_form_field.dart';
import 'package:class_f_story/ui/widgets/custom_elevated_button.dart';
import 'package:class_f_story/ui/widgets/custom_logo.dart';
import 'package:class_f_story/ui/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginBody extends ConsumerWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 창고 자체에 접근 하는 코드 --> 뷰 모델 가지고 옴
    SessionGVM gvm = ref.read(sessionProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          CustomLogo('f-story'),
          CustomAuthTextFormField(
            text: 'Username',
            controller: _usernameController,
          ),
          const SizedBox(height: largeGap),
          CustomAuthTextFormField(
            text: 'Password',
            controller: _passwordController,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: '로그인',
            click: () {
              // String temp1 = _usernameController.text.trim();
              // String temp2 = _passwordController.text.trim();
              // 로그인 이벤트 리스너 여기에 있음
              // _usernameController 얘는 객체를 말하는 거고, text 를 추출해야 함

              gvm.login(
                _usernameController.text.trim(),
                _passwordController.text.trim(),
              );

              // TODO - 로그인 처리
              // 뷰 모델에 있는 기능인 로그인 행위를 만들어 줄 예정
            },
          ),
          CustomTextButton(
            text: '회원가입 페이지로 이동',
            click: () {
              Navigator.pushNamed(context, '/join');
            },
          ),
        ],
      ),
    );
  }
}
