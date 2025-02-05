import 'package:class_f_story/main.dart';
import 'package:flutter/material.dart';

import 'logger.dart';

class ExceptionHander {
  static void handerException(dynamic exception, StackTrace stackTrace) {
    logger.e('Exception : $exception');
    logger.e('StackTrace : $stackTrace');

    // 간혹 비동기 작업 시 -> currentContext 사라질 수 있다.
    final mContext = navigatorkey.currentContext;
    // app 크래시드? 앱 뻑나지 않게?
    if (mContext == null) return null;

    // 시스템 키보드가 있다면 내려 주자 -!
    FocusScope.of(mContext).unfocus();

    ScaffoldMessenger.of(mContext).showSnackBar(
      SnackBar(
        content: Text(
          exception.toString(),
        ),
      ),
    );
  }
}
