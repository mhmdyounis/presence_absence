import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCodeField extends StatelessWidget {
  final TextEditingController controller;

  final FocusNode focusNode;

  final Function(String value) onChange;

  final Function(String value) onSubmit;

  const MyCodeField({super.key,
    required this.controller,
    required this.focusNode,
    required this.onChange,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 20.h),
          child: TextField(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: "Cairo"
            ),
            focusNode: focusNode,
            controller: controller,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onChanged: onChange,
            onSubmitted: onSubmit,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 15.h, horizontal: 0.w),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54,width: 2),
                borderRadius: BorderRadius.circular(15.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue,width: 2),
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          ),
        ));
  }
}
