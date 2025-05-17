import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBar extends StatelessWidget {
  String tittle;

  Widget? suffix;

  Widget? leading;

  MyAppBar({super.key, this.tittle = "", this.suffix, this.leading});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      alignment: AlignmentDirectional.center,
      height: 60.h,
      width: MediaQuery.sizeOf(context).width,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            leading ??
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 24.sp,
                    color: themeData.primaryColor,
                  ),
                ),
            SizedBox(width: 10.w),
            Text(
              tittle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize:
                    tittle == "السلسلة الزمنية للغياب" ||
                            tittle == "متوسط الغياب اليومي"
                        ? 20.sp
                        : 24.sp,
                color: themeData.primaryColor,
              ),
            ),
            Spacer(),
            suffix ?? SizedBox(height: 24.h, width: 24.w),
          ],
        ),
      ),
    );
  }
}
