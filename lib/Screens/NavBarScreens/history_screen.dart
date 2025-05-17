import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_absence/Cache/cache_controller.dart';
import 'package:presence_absence/Get/absent_getx_controller.dart';
import 'package:presence_absence/Helpers/navigator_helper.dart';
import 'package:presence_absence/Models/DB/absence_model.dart';
import 'package:presence_absence/Models/DB/school_model.dart';
import 'package:presence_absence/Screens/app_main_screen.dart';
import 'package:presence_absence/Widgets/my_app_bar.dart';

class AbsencePlusResult {
  String countOfAbsence;
  bool result;
  int totalStudent;
  double per;

  bool isOnChange;

  AbsencePlusResult({
    required this.result,
    required this.countOfAbsence,
    required this.totalStudent,
    required this.per,
    this.isOnChange = false,
  });
}

class HistoryScreen extends StatefulWidget {
  SchoolModel schoolModel;

  HistoryScreen({super.key, required this.schoolModel});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with NavigatorHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await AbsentGetxController.to.read();
  }

  @override
  Widget build(BuildContext context) {
    return AppMainScreen(
      appBar: MyAppBar(tittle: "سجل الغياب"),
      body: GetX<AbsentGetxController>(
        builder: (controller) {
          if (controller.loading.isTrue) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.absents.isNotEmpty) {
            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.symmetric(vertical: 20.h),
              shrinkWrap: true,
              itemCount: controller.absents.length,
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
              itemBuilder:
                  (context, index) =>
                  _absencesCard(
                    index: index,
                    absent:
                    controller.absents[(controller.absents.length - 1) -
                        index],
                  ),
            );
          } else {
            return Center(child: Text("لا يوجد بيانات"));
          }
        },
      ),
    );
  }

  int tabbedIndex = -1;

  Widget _absencesCard({required AbsentModel absent, int index = -1}) {
    return InkWell(
      onTapCancel:
          () =>
          setState(() {
            tabbedIndex = -1;
          }),
      onTapDown:
          (details) =>
          setState(() {
            tabbedIndex = index;
          }),
      onTapUp:
          (details) async {
        await CacheController().setter("idForUpdate", absent.id) ;
        setState(() {
        tabbedIndex = -1;
        Navigator.pop(
        context,
        AbsencePlusResult(
        per: absent.percentageOfAbsenc!,
        totalStudent: absent.totalStudent,
        result: true,
        countOfAbsence: absent.absenceCount.toString(),
        ),
        );
        // jump(
        //   context: context,
        //   to: TimeLineScreen(schoolModel: widget.schoolModel,fromHistory: true,),
        // );
        });
      },

      child: AnimatedScale(
    scale: tabbedIndex == index ? 0.96 : 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        color: Theme
            .of(context)
            .primaryColor
            .withOpacity(.1),
        elevation: 0,
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  labelRow(label: " التاريخ :",
                      value: DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(absent.createdAt!))),

                  labelRow(
                    label: "العدد الكلي :",
                    value: absent.totalStudent.toString(),
                  ),
                  labelRow(
                    label: "عدد الغياب :",
                    value: absent.absenceCount.toString(),
                  ),
                  labelRow(
                    label: "نسبة الغياب :",
                    value:
                    "${absent.percentageOfAbsenc?.toString() ?? ""} % ",
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(Icons.edit, size: 18.sp),
              ),
            ],
          ),
        ),
      ),
    ),);
  }

  Row labelRow({String label = "", required var value }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            height: 2,
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
