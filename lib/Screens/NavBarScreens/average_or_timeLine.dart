import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presence_absence/Cache/cache_controller.dart';
import 'package:presence_absence/Get/absent_getx_controller.dart';
import 'package:presence_absence/Helpers/navigator_helper.dart';
import 'package:presence_absence/Models/DB/school_model.dart';
import 'package:presence_absence/Screens/NavBarScreens/absence_average.dart';
import 'package:presence_absence/Screens/NavBarScreens/settings_screen.dart';
import 'package:presence_absence/Screens/NavBarScreens/time_line_screen.dart';
import 'package:presence_absence/Screens/app_main_screen.dart';
import 'package:presence_absence/Widgets/my_app_bar.dart';
import 'package:get/get.dart';

class AverageOrTimeline extends StatefulWidget {
  AbsentGetxController absentGetxController = Get.put(AbsentGetxController());
  SchoolModel schoolModel;

  AverageOrTimeline({super.key, required this.schoolModel});

  @override
  State<AverageOrTimeline> createState() => _AverageOrTimelineState();
}

class _AverageOrTimelineState extends State<AverageOrTimeline>
    with NavigatorHelper {
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  List<double> per = [];

  fetchData() async {
    await AbsentGetxController.to.read();
    setState(() {
      if (AbsentGetxController.to.absents.isNotEmpty) {
        AbsentGetxController.to.absents.forEach(
          (element) => per.add(element.percentageOfAbsenc ?? 0.0),
        );
      }
    });
  }

  Widget build(BuildContext context) {
    return AppMainScreen(
      withScroll: false,
      appBar: MyAppBar(tittle: "إحصائيات الغياب"),
      body: Center(
        child: Column(
          children: [
            // وصف أعلى الصفحة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'تابع تطور الغياب للطلاب خلال الأسبوع.',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 20),
            _buildSection(),
            SizedBox(height: 40.h),
            ElevatedButton.icon(
              icon: Icon(Icons.settings,size: 22.sp,),
              label: Text(
                'الإعدادات',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.sp,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                jump(context: context, replace: true,to: SettingsScreen(schoolModel:  widget.schoolModel)) ;
              },
              style: ElevatedButton.styleFrom(
                elevation: 3,
                alignment: Alignment.center,
                fixedSize: Size(200.w, 55.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),

            SizedBox(height: 100.h),

            // البطاقات
          ],
        ),
      ),
    );
  }

  double average = 0;

  double sum = 0;

  String sumAsText = "";
  String averageAsText = "";
  List<double> last = [];

  void list(int value) {
    last =
        per.length > 5 || per.length > value
            ? per.sublist(per.length - value)
            : List.generate(value - per.length, (index) => -1.0) + per;
  }

  Future<double> calcluteAverage() async {

    if (per.isNotEmpty) {
      if (DateTime.now().weekday == 7) {
        list(1);
      } else if (DateTime.now().weekday == 1) {
        list(2);
      } else if (DateTime.now().weekday == 2) {
        list(3);
      } else if (DateTime.now().weekday == 3) {
        list(4);
      } else {
        list(5);
      }
      List<String> lastAsText = last.map((e) => e.toString()).toList();
      var finallyLastItemAsText =
          lastAsText.map((e) => e.replaceAll("-1.0", " - ")).toList();
      last.removeWhere((element) => element == -1);
      sum = last.fold(0.0, (a, b) => a + (b ?? 0));
      sumAsText = sum.toStringAsFixed(2);
      average = sum / 5;
      averageAsText = average.toStringAsFixed(2);

      await CacheController().setter("lastItem", finallyLastItemAsText);
      await CacheController().setter("sum", sumAsText);
      await CacheController().setter("average", averageAsText);
      return average;
    }
    return 0;
  }

  int tabbedIndex = -1;

  Padding _buildSection() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          2,
          (index) => InkWell(
            onTapDown:
                (_) => setState(() {
                  tabbedIndex = index;
                }),
            onTapCancel:
                () => setState(() {
                  tabbedIndex = -1;
                }),
            onTapUp: (details) async {
              setState(() {});
              tabbedIndex = -1;
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            TimeLineScreen(schoolModel: widget.schoolModel ),
                  ),
                ).then((_) {
                  per.clear();
                  fetchData();
                });
              } else {
                var x = await calcluteAverage();
                jump(
                  context: context,
                  to: AbsenceAverage(
                    schoolModel: widget.schoolModel ,
                    average: x,
                    sumOfPer: sum,
                  ),
                );
              }
            },
            child: AnimatedScale(
              scale: tabbedIndex == index ? 0.96 : 1,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Container(
                alignment: AlignmentDirectional.center,
                width: MediaQuery.sizeOf(context).width / 2 - 20.w,
                margin: EdgeInsetsDirectional.only(
                  start: 10.w,
                  end: 10.w,
                ),
                padding: EdgeInsetsDirectional.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  color:
                      index == 0 ? Colors.blue.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color:
                        index == 0
                            ? Colors.blue.shade200
                            : Colors.green.shade200,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      index == 0
                          ? "assets/images/timeLine.png"
                          : "assets/images/average.jpg",
                      height: 130.h,
                    ),
                    Text(
                      index == 0
                          ? "السلسلة الزمنية للغياب"
                          : "متوسط الغياب اليومي ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
