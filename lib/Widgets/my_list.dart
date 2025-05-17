// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:presence_absence/Widgets/my_text_field.dart';
//
// class MyList extends StatefulWidget {
//   const MyList({super.key});
//
//   @override
//   State<MyList> createState() => _MyListState();
// }
//
// class _MyListState extends State<MyList> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.symmetric(vertical: 20.h),
//       itemCount: 4,
//       separatorBuilder: (context, index) => SizedBox(height: 0.h),
//       itemBuilder:
//           (context, index) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsetsDirectional.only(start: 40.w, top: 20),
//             child: Text(
//               index == 0
//                   ? "المدرسة"
//                   : index == 1
//                   ? "عدد الطالبات"
//                   : index == 2
//                   ? "عدد الغائبات الكلي"
//                   : "النسبة المئوية",
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           index == 2
//               ? Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: MyTextField(
//               inputType: TextInputType.number,
//               nameEditingController: nameEditingController,
//               filled: false,
//               onChange: (value) {
//                 setState(() {});
//               },
//             ),
//           )
//               : Container(
//             padding: EdgeInsetsDirectional.symmetric(
//               horizontal: 25.w,
//               vertical: 12.h,
//             ),
//             height: 45.h,
//             width: MediaQuery.sizeOf(context).width,
//             margin: EdgeInsetsDirectional.symmetric(horizontal: 20.h),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25.h),
//               border: Border.all(color: Colors.grey, width: 1.5),
//             ),
//             child: Text(
//               index == 0
//                   ? school?.schoolName ?? ""
//                   : index == 1
//                   ? school?.totalStudents.toString() ?? ""
//                   : index == 3
//                   ? "${percentageOfAbsenc.toString()} %"
//                   : "",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
