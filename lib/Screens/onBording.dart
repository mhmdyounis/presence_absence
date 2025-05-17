import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:presence_absence/DB/Controllers/school_db_controller.dart';
import 'package:presence_absence/Helpers/navigator_helper.dart';
import 'package:presence_absence/Models/DB/school_model.dart';
import 'package:presence_absence/Screens/NavBarScreens/average_or_timeLine.dart';
import 'package:presence_absence/Screens/NavBarScreens/settings_screen.dart';
import 'package:presence_absence/Widgets/my_button.dart';

class Onbording extends StatefulWidget {
  const Onbording({super.key});

  @override
  State<Onbording> createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> with NavigatorHelper {
  List<SchoolModel> school = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();

    });
  }

  Future<void> _fetchData() async {
    List<SchoolModel> x = await SchoolDbController().read();
    setState(() {
      school = x;
    });

  }
  bool get isEmpty => school.isEmpty ;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context) ;
    return Scaffold(
      body: Stack(
        children: [
          _gradiantBackground(themeData),
          _firstCircle(),
          _secondCircle(),
          _yellowCircle(),
          _backPackItem(),
          _myText(),
          _myButton(),
        ],
      ),
    );
  }

  PositionedDirectional _myButton() {
    return PositionedDirectional(
          start: 75.w,
          end: 75.w,
          bottom: 30.h,
          child: MyButton(
            tittle: "ابدا",
            onTap:
                () => jump(
                  context: context,
                  to: isEmpty ? SettingsScreen(schoolModel: null,) : AverageOrTimeline(schoolModel: school[0]),
                ),
          ),
        );
  }

  PositionedDirectional _myText() {
    return PositionedDirectional(
          start: 20.w,
          end: 20.w,
          height: 225.h,
          bottom: 0.h,
          child: SizedBox(
            child: Text(
              "تابع دوامك المدرسي بكل سهولة",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
  }

  PositionedDirectional _backPackItem() {
    return PositionedDirectional(
          height: 520.h,
          start: 0.w,
          end: 0.w,
          child: Image.asset(
            "assets/images/school_pag.png",
            height: 250,
            width: 250,
          ),
        );
  }

  PositionedDirectional _yellowCircle() {
    return PositionedDirectional(
          height: 520.h,
          start: 5.w,
          end: 5.w,

          // bottom: 100,
          child: Container(
            alignment: AlignmentDirectional.center,
            height: 300.h,
            width: 300.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.bottomEnd,
                end: AlignmentDirectional.topStart,
                colors: [
                  Color(0xffFFB246),
                  Color(0xffFFB246),
                  Color(0xffFED66F),
                  Color(0xffFED66F).withOpacity(0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
          ),
        );
  }
  Widget _secondCircle(){
    return PositionedDirectional(
      height: 520.h,
      start: -25.w,
      end: -25.w,

      // bottom: 100,
      child: Container(
        alignment: AlignmentDirectional.center,
        height: 300.h,
        width: 300.w,
        decoration: BoxDecoration(
          color: Color(0xffA8C0FD).withOpacity(0.2),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  PositionedDirectional _firstCircle() {
    return PositionedDirectional(
          height: 520.h,
          start: -55.w,
          end: -55.w,

          // bottom: 100,

          child: Container(
            alignment: AlignmentDirectional.center,
            height: 300.h,
            width: 300.w,
            decoration: BoxDecoration(
              color: Color(0xffA3BCFF).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
        );
  }

  Container _gradiantBackground(ThemeData themeData) {
    return Container(
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.bottomCenter,
              end: AlignmentDirectional.topCenter,
              colors: [
                themeData.primaryColor,
                themeData.primaryColor,
                Color(0xff9CB6FF),
              ],
            ),
          ),
          // child: SizedBox(
          //   width: 250.h,
          //   height: 250.h,
          //   child: Image.asset("assets/images/school_pag.png",height: 250,width: 250,),
          // ),
        );
  }
}
