import 'package:flutter/material.dart';

mixin NavigatorHelper {
  Future<void> jump(
      {required BuildContext context,
      required Widget to,
      bool replace = false}) async {
    replace
        ? await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => to,
            ),)
        : await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => to,
            ),);
    ;
  }
}
