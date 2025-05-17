import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presence_absence/Get/school_getx_controller.dart';
import 'package:presence_absence/Screens/app_main_screen.dart';
import 'package:presence_absence/Widgets/my_app_bar.dart';
import 'package:presence_absence/Widgets/my_button.dart';

class MainFormScreen extends StatefulWidget {
  Widget? myListView;
  Widget? leading;
  Widget? suffix;
  bool forPdf ;

  String tittle;
  String appBarTittle;

  Function()? onTap;

  MainFormScreen({super.key, this.myListView,this.forPdf = false, this.leading,this.suffix,this.appBarTittle = "", this.tittle = "", this.onTap});

  @override
  State<MainFormScreen> createState() => _MainFormScreenState();
}

class _MainFormScreenState extends State<MainFormScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Material(
      color: themeData.primaryColor,
      child: AppMainScreen(
        withScroll: true,
        appBar: MyAppBar(
          leading: widget.leading,
          tittle: widget.appBarTittle,
          suffix: widget.suffix,
        ),
        body: Column(
          children: [
            widget.myListView ?? SizedBox.shrink(),
            SizedBox(height: 0.h,),
            MyButton(tittle: widget.tittle, onTap: widget.onTap,forPdf: widget.forPdf,),
          ],
        ),
      ),
    );
  }
}
