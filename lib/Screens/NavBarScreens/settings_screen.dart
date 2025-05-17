import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presence_absence/DB/Controllers/school_db_controller.dart';
import 'package:presence_absence/Get/school_getx_controller.dart';
import 'package:presence_absence/Helpers/Snack_bar_helper.dart';
import 'package:presence_absence/Helpers/navigator_helper.dart';
import 'package:presence_absence/Models/DB/school_model.dart';
import 'package:presence_absence/Screens/NavBarScreens/average_or_timeLine.dart';
import 'package:presence_absence/Screens/NavBarScreens/main_form_screen.dart';

import 'package:presence_absence/Widgets/my_text_field.dart';

class SettingsScreen extends StatefulWidget {
  SchoolModel? schoolModel ;
  SettingsScreen({super.key,required this.schoolModel});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SnackBarHelper, NavigatorHelper {
  late TextEditingController schoolEditingController;
  late TextEditingController stageEditingController;
  late TextEditingController countOfStudentEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    schoolEditingController = TextEditingController(text: widget.schoolModel?.schoolName);
    stageEditingController = TextEditingController(text: widget.schoolModel?.educationalStage);
    countOfStudentEditingController = TextEditingController(text: widget.schoolModel?.totalStudents.toString() );
    init();
  }

  List<SchoolModel> school = [];

  Future<void> _fetchData() async {
     await SchoolGetxController.to.read();
     setState(() {
      school = SchoolGetxController.to.schools.value;
    });
  }

  void init() async {
    await _fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    schoolEditingController.dispose();
    stageEditingController.dispose();
    countOfStudentEditingController.dispose();
    super.dispose();
  }

  String? selectedStage;

  final List<String> stages = ['ابتدائي', 'متوسط', 'ثانوي'];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return MainFormScreen(
      appBarTittle: "الإعدادات",
      myListView: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 20.w),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(height: 20.h),
        itemBuilder:
            (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 5.w),
                  child: Text(
                    index == 0
                        ? "اسم المدرسة"
                        : index == 1
                        ? "المرحلة الدراسية"
                        : 'عدد الكلي لطلاب المدرسة',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: Colors.deepPurple.shade900
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                !(index == 1) ? MyTextField(
                  suffix: Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    child:
                        index == 0
                            ? SvgPicture.asset(
                              "assets/images/school.svg",
                              height: 18.h,
                              width: 18.w,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).canvasColor,
                                BlendMode.srcIn,
                              ),
                            )
                            : index == 1
                            ? SizedBox(height: 18.h, width: 18.w)
                            : Icon(
                              Icons.groups,
                              size: 24.sp,
                              color: theme.canvasColor,
                            ),
                  ),
                  nameEditingController:
                      index == 0
                          ? schoolEditingController
                          : index == 1
                          ? stageEditingController
                          : countOfStudentEditingController,
                  tittle:
                      index == 0
                          ? "المدرسة"
                          : index == 1
                          ? "المرحلة الدراسية"
                          : 'العدد الكلي',
                  withAboveLabel: true,
                  filled: false,
                  inputType:
                      index == 2
                          ? TextInputType.number
                          : TextInputType.text,
                ) : _myDropdownButtonFormField(),
              ],
            ),
      ),
      tittle: "حفظ",
      onTap: () async {
        await performAddData();
        setState(() {});
      },
    );
  }
  late String? selectedValue = widget.schoolModel?.educationalStage ;
  Widget _myDropdownButtonFormField () {
    return DropdownButtonFormField<String>(
      itemHeight: 48.h,
      iconSize: 24.sp,
      dropdownColor: Colors.white,
      alignment: AlignmentDirectional.bottomCenter,
      padding: EdgeInsetsDirectional.only(start: 10.w),
      style: TextStyle(
        height: 1,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
        color: Colors.black87,
        fontFamily: 'Cairo'
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 5.w),
        hintText: widget.schoolModel == null ?"اختر مرحلة" : widget.schoolModel!.educationalStage,
        hintStyle: TextStyle(fontSize: 15.5.sp,fontFamily: 'Cairo',color: Colors.black,fontWeight: FontWeight.w500),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400,width: 3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 3),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),

      // value: selectedValue ,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
      },
      items: stages.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    ) ;
  }

  String get countOfStudentText => countOfStudentEditingController.text.trim();
  int? totalStudent;

  SchoolModel schoolModel({int? id}) {
    return SchoolModel(
      id: id,
      schoolName: schoolEditingController.text.trim(),
      educationalStage: selectedValue!,
      totalStudents: totalStudent!,
    );
  }

  Future<void> performAddData() async {
    if (checkData()) {
      await addData();
    }
  }


  Future<void> addData() async {
    if (school.isEmpty) {
      var resultCreate = await SchoolGetxController.to.create(schoolModel(id: 1));
      setState(() {
        print("resultCreate : $resultCreate");
        if (resultCreate != null) {
        }
      });
    } else {
      bool updateResult = await SchoolGetxController.to.updateSchool(
        schoolModel(id: school.last.id),
      );
      if (updateResult) {
        print("update");
      }
    }
    jump(context: context,replace: true, to: AverageOrTimeline(schoolModel: schoolModel(id: school.last.id ?? 1))) ;

  }

  bool isDuplicate = false;

  bool checkData() {
    if (schoolEditingController.text.trim().isNotEmpty &&
        selectedValue != null &&
        countOfStudentText.isNotEmpty) {
      if (!totalStudentTest()) {
        return false;
      }

      return true;
    } else {
      mySnackBar(context: context, text: "ادخل البيانات كاملة", error: true);
      return false;
    }
  }

  bool totalStudentTest() {
    if (countOfStudentText.isEmpty ||
        countOfStudentText.contains('.') ||
        countOfStudentText.contains(',') ||
        int.parse(countOfStudentText) == 0) {
      mySnackBar(
        context: context,
        text: "عدد الطلاب يجب أن يكون عددًا صحيحًا موجبًا",
        error: true,
      );
      return false;
    }
    totalStudent = int.parse(countOfStudentText);
    return true;
  }
}
