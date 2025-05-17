import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyTextField extends StatefulWidget {
  String? hint;

  bool? obscureText;

  bool filled;

  TextInputType inputType;
  bool isSearch;
  String? tittle;

  TextStyle? tittleStyle;

  double verticalPadding;

  double height;

  bool enable;
  bool withAboveLabel;

  String? subTittle;

  bool readOnly;

  bool withSuffix;

  bool toComments;
  Widget? suffix ;

  Function(String value)? onChange;

  Function(String value)? onSubmitted;

  Function()? onOutLineTap;

  Function()? onTap;
  Function()? sendOnTap;

  String? flagPath;

  final TextEditingController? nameEditingController;
  bool isEmpty;

  MyTextField({
    super.key,
    required this.nameEditingController,
    this.tittleStyle,
    this.subTittle,
    this.suffix,
    this.flagPath,
    this.withSuffix = false,
    this.verticalPadding = 0,
    this.height = 45,
    this.hint,
    this.withAboveLabel = true,
    this.obscureText,
    this.filled = true,
    this.inputType = TextInputType.text,
    this.isSearch = false,
    this.enable = true,
    this.tittle,
    this.readOnly = false,
    this.onChange,
    this.onSubmitted,
    this.onOutLineTap,
    this.onTap,
    this.toComments = false,
    this.isEmpty = false,
    this.sendOnTap,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isFocused = false;

  bool isActive = false;

  String? value = "";

  late FocusNode focusNode;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextField(
      style: TextStyle(
        fontSize: 15.5.sp,
        fontWeight: FontWeight.w500
      ),
      obscureText: widget.obscureText ?? false,
      onTap: widget.onTap,
      onChanged: widget.onChange,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.inputType,
      textAlignVertical: TextAlignVertical.center,
      readOnly: widget.readOnly,
      textInputAction: TextInputAction.done,
      controller: widget.nameEditingController,
      expands: true,
      maxLines: null,
      minLines: null,

      decoration: InputDecoration(
        /// افضل طريقة للتحكم بالطول و العرض
        /// يشتؤط قي ال  constraints
        ///ان يكون ال minlenght , maxlenght = null
        constraints: BoxConstraints(
          minHeight: widget.height.h,
          maxHeight: widget.height.h,
        ),
        labelText: widget.tittle,
        labelStyle:  widget.tittleStyle ?? TextStyle(fontFamily: "Cairo" ,color: Colors.black54,fontSize: 14.sp),

        suffixIcon: widget.suffix ,
        enabled: widget.enable,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        focusedBorder: buildOutlineInputBorder(context, color: theme.primaryColor),

        enabledBorder: buildOutlineInputBorder(
          context,
          color: Colors.grey.shade400,
        ),
        disabledBorder: buildOutlineInputBorder(
          context,
          color: Colors.grey.shade400,
        ),
        hintText: widget.hint ?? " ",
        alignLabelWithHint: true,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).canvasColor.withOpacity(0.7),
        ),
        filled: widget.filled,
      ),
    );
  }

  Padding _seffixIcon({IconData? icon}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.h),
      child: InkWell(
        onTap: widget.sendOnTap,
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder(
    BuildContext context, {
    Color? color,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: color ?? Colors.transparent, width: 2.w),
    );
  }
}

/// myRow --> BotoomSheet --> Scaffold
