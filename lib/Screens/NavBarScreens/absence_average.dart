import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presence_absence/Cache/cache_controller.dart';
import 'package:presence_absence/Get/absent_getx_controller.dart';
import 'package:presence_absence/Models/DB/absence_model.dart';
import 'package:presence_absence/Models/DB/school_model.dart';
import 'package:presence_absence/Pdf/pdf_settings.dart';
import 'package:presence_absence/Screens/NavBarScreens/main_form_screen.dart';
import 'package:presence_absence/Widgets/my_text_field.dart';

class AbsenceAverage extends StatefulWidget {
  SchoolModel schoolModel;
  double average;
  double sumOfPer;

  AbsenceAverage({
    super.key,
    required this.schoolModel,
    required this.average,
    required this.sumOfPer,
  });

  @override
  State<AbsenceAverage> createState() => _AbsenceAverageState();
}

class _AbsenceAverageState extends State<AbsenceAverage> with PdfHelper{
  late TextEditingController averageEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    averageEditingController = TextEditingController();

    _fetchData();
  }

  Future<void> _fetchData() async {
    await AbsentGetxController.to.read();
  }

  @override
  void dispose() {
    averageEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainFormScreen(
      appBarTittle: "متوسط الغياب اليومي",
      myListView: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(bottom: 30.h,top: 20.h),
        itemCount: 4,
        shrinkWrap: true,
        separatorBuilder: (context, index) => SizedBox(),
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
                        ? "مجموع النسب المئوية"
                        : "متوسط الغياب",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 25.w,
                    vertical: 12.h,
                  ),
                  height: 45.5.h,
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
                        ? widget.sumOfPer.toStringAsFixed(2)
                        : widget.average.toStringAsFixed(2),

                    style: TextStyle(
                      height: 1,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.5.sp,
                    ),
                  ),
                ),
              ],
            ),
      ),
      tittle: "اطبع ",
      forPdf: true,
      onTap: () async{
        if(widget.sumOfPer != 0 || widget.average != 0) {
          await generateArabicPdfReport() ;
        }
      },
    );
  }
}
