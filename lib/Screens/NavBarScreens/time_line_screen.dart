import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:presence_absence/Cache/cache_controller.dart';
import 'package:presence_absence/Get/absent_getx_controller.dart';
import 'package:presence_absence/Helpers/Snack_bar_helper.dart';
import 'package:presence_absence/Helpers/navigator_helper.dart';
import 'package:presence_absence/Models/DB/absence_model.dart';
import 'package:presence_absence/Models/DB/school_model.dart';
import 'package:presence_absence/Pdf/pdf_settings.dart';
import 'package:presence_absence/Screens/NavBarScreens/history_screen.dart';
import 'package:presence_absence/Screens/NavBarScreens/main_form_screen.dart';
import 'package:presence_absence/Widgets/my_text_field.dart';
import 'package:get/get.dart';

class TimeLineScreen extends StatefulWidget {
  SchoolModel schoolModel;

  TimeLineScreen({super.key, required this.schoolModel});

  @override
  State<TimeLineScreen> createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen>
    with SnackBarHelper, NavigatorHelper, PdfHelper, SnackBarHelper {
  late TextEditingController nameEditingController;

  @override
  void initState() {
    print(widget.schoolModel.totalStudents);
    super.initState();
    isOnChange = false;
    nameEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() async {
    await setRead();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameEditingController.dispose();
    super.dispose();
  }

  AbsencePlusResult? absencePlusResult;

  bool fromHistory = false;
  bool isOnChange = false;

  @override
  Widget build(BuildContext context) {
    return MainFormScreen(
      suffix: InkWell(
        onTap: () async {
          AbsencePlusResult? model = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => HistoryScreen(schoolModel: widget.schoolModel),
            ),
          );

          setState(() {
            absencePlusResult = model;
            fromHistory = absencePlusResult?.result ?? false;
            isOnChange = absencePlusResult?.isOnChange ?? false;
            if (fromHistory) {
              nameEditingController.text =
                  absencePlusResult?.countOfAbsence ?? "";
            }
          });
        },
        child: Icon(
          Icons.history,
          color: Theme.of(context).primaryColor,
          size: 24.sp,
        ),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).primaryColor,
          size: 24.sp,
        ),
      ),
      appBarTittle: "السلسلة الزمنية للغياب",
      myListView: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        itemCount: 5,
        separatorBuilder: (context, index) {
          return SizedBox(height: 0.h);
        },
        itemBuilder:
            (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 25.w, top: 20),
                  child: Text(
                    index == 0
                        ? "المدرسة"
                        : index == 1
                        ? "المرحلة الدراسية"
                        : index == 2
                        ? "عدد الطلاب الكلي"
                        : index == 3
                        ? "عدد الغياب"
                        : "النسبة المئوية",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                index == 3
                    ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: MyTextField(
                        inputType: TextInputType.number,
                        nameEditingController: nameEditingController,
                        filled: false,
                        onChange: (value) {
                          print(value);
                          calclutePercentage(value);
                          setState(() {
                            isOnChange = true;
                          });
                        },
                      ),
                    )
                    : Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 25.w,
                        vertical: 12.h,
                      ),
                      height: 45.h,
                      alignment: AlignmentDirectional.centerStart,
                      width: MediaQuery.sizeOf(context).width,
                      margin: EdgeInsetsDirectional.symmetric(horizontal: 20.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.h),
                        border: Border.all(color: Colors.grey, width: 1.5),
                      ),
                      child: Text(
                        index == 0
                            ? widget.schoolModel.schoolName
                            : index == 1
                            ? widget.schoolModel.educationalStage
                            : index == 2
                            ? fromHistory
                                ? absencePlusResult?.totalStudent.toString() ??
                                    ""
                                : widget.schoolModel.totalStudents.toString()
                            : index == 4
                            ? "${fromHistory
                                ? isOnChange
                                    ? percentageOfAbsenc
                                    : absencePlusResult!.per
                                : percentageOfAbsenc} %"
                            : "",
                        style: TextStyle(
                          height: 1,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.3.sp,
                        ),
                      ),
                    ),
              ],
            ),
      ),
      tittle: absencePlusResult?.result ?? false ? "تحديث" : "حفظ",
      onTap: () async {
        await _performData(); // ← داخله يتم الحفظ في الكاش
        // generateArabicPdfReport() ;
        setState(() {}); // e؟
      },
    );
  }

  String inputValue = "";
  double percentageOfAbsenc = 0;

  int countOfAbsent = 0;

  void calclutePercentage(String value) {
    if (value.isEmpty) {
      value = 0.toString();
    }
    countOfAbsent = int.parse(value);
    double fullPercentageOfAbsenc =
        fromHistory
            ? (countOfAbsent * 100) / absencePlusResult!.totalStudent
            : (countOfAbsent * 100) / widget.schoolModel.totalStudents;
    String perAsText = fullPercentageOfAbsenc.toStringAsFixed(2);
    percentageOfAbsenc = double.parse(perAsText);
  }

  AbsentModel absentModel({int? id}) {
    return AbsentModel(
      id: id,
      schoolId: widget.schoolModel.id!,
      totalStudent: widget.schoolModel.totalStudents,
      absenceCount: countOfAbsent,
      percentageOfAbsenc: percentageOfAbsenc,
      attendanceCount: widget.schoolModel.totalStudents - (countOfAbsent),
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  /// *******************************************
  Future<void> setRead() async {
    await AbsentGetxController.to.read();
  }

  DateTime dateTimeLast =DateTime.now().subtract(Duration(days: 2));

  int get totalStudentFromHistoryOrSetting => fromHistory ? absencePlusResult!.totalStudent : widget.schoolModel.totalStudents ;

  bool totalStudentTest() {

    if (nameEditingController.text.trim().isEmpty ||
        nameEditingController.text.trim().contains('.') ||
        nameEditingController.text.trim().contains(',') ||
        int.parse(nameEditingController.text) >
            totalStudentFromHistoryOrSetting ||
        countOfAbsent == 0) {
      mySnackBar(context: context, text: "هناك خطا في عدد الغياب", error: true);
      return false;
    }
    if (AbsentGetxController.to.absents.isNotEmpty) {
      dateTimeLast = DateTime.parse(
        AbsentGetxController.to.absents.last.createdAt! ,
      );

    }
    if(!fromHistory ){
      DateTime nowDate = DateTime.now();
      print(nowDate.year);
      print(nowDate.month);
      print(nowDate.month);
      DateTime today = DateTime(nowDate.year,nowDate.month,nowDate.day);
      print("today${today}");
      DateTime lastDate = DateTime(dateTimeLast.year, dateTimeLast.month, dateTimeLast.day);
      print(lastDate) ;
      print("diffrence : ${today.difference(lastDate).inDays}");
      if (today.difference(lastDate).inDays <  1   ) {
        mySnackBar(
          context: context,
          error: true,
          text: "تم الإدخال مسبقًا، حاول مرة أخرى بعد مرور يوم",
        );
        return false;
      }
    }

    return true;
  }

  Future<void> _countOfAbsenceData() async {
    var x = absencePlusResult?.result ?? false;
    if (!x) {
      int? createResult = await AbsentGetxController.to.create(absentModel());
      if (createResult != null) {
        print(AbsentGetxController.to.absents.length);
        CacheController().setter("id", createResult);
        CacheController().setter(
          "last_entry_time_school",
          DateFormat('dd-MM-yyyy').format(DateTime.now()),
        );
        mySnackBar(context: context, text: "تمت عملية الحفظ ", error: false);
        setState(() {});
        print("create done");
        Navigator.pop(context);
      }
    } else {
      bool updateResult = await AbsentGetxController.to.updateAbsent(
        absentModel(id: CacheController().getter("idForUpdate")),
      );
      if (updateResult) {
        mySnackBar(context: context, error: false, text: "تم التعديل بنجاح");
      }
    }
  }

  bool checkData() {
    if (nameEditingController.text.isNotEmpty) {
      if (!totalStudentTest()) {
        return false;
      }
      return true;
    }
    mySnackBar(context: context, error: true, text: "ادخل البيانات");
    return false;
  }

  Future<void> _performData() async {
    if (checkData()) {
      await _countOfAbsenceData();
    }
  }
}
