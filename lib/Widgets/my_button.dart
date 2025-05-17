import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatefulWidget {
  MyButton({
    super.key,
    this.tittle = "",
    this.onTap,
    this.width,
    this.isRedTextColor = false,
    this.loading = false,
    this.height = 58,
    this.forPdf = false,
  });

  String tittle;

  Function()? onTap;

  double? width;
  double height;

  bool isRedTextColor;

  bool loading;

  bool forPdf;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !widget.loading ? widget.onTap : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        alignment: Alignment.center,
        height: widget.height.h,
        width: widget.loading ? 48.w : (widget.width ?? 200.w),
        decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            end: AlignmentDirectional.bottomCenter,
            begin: AlignmentDirectional.topCenter,
            colors: [
              Colors.red,
              Color(0xffFD5B37) , 
              Color(0xffFB846C) ,

            ],
          ),
          borderRadius: BorderRadius.circular(45.r),
          // boxShadow:  [
          //   BoxShadow(
          //     offset: Offset(0, 4),
          //     color: Colors.grey.shade400,
          //     spreadRadius: 0,
          //     blurRadius: 4,
          //   ),
          // ],
        ),
        child:
            !widget.loading
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(flex: 1),
                    SizedBox(
                      child: Text(
                        widget.tittle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              widget.isRedTextColor
                                  ? FontWeight.w600
                                  : FontWeight.w600,
                          fontSize: widget.isRedTextColor ? 18.sp : 20.sp,
                        ),
                      ),
                    ),
                    widget.forPdf
                        ? Icon(Icons.picture_as_pdf,size: 22.sp,color: Colors.white,)
                        : SizedBox.shrink(),
                    Spacer(flex: 1),
                  ],
                )
                : CircularProgressIndicator(),
      ),
    );
  }
}
