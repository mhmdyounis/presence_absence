import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin SnackBarHelper {
  void mySnackBar({
    required BuildContext context,
    bool error = false,
    String text = "",
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: error ? Colors.red : Colors.green.shade400,
      ),
    );
  }
}
