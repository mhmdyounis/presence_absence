import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:presence_absence/Cache/cache_controller.dart';
import 'package:presence_absence/DB/Controllers/absence_db_controller.dart';
import 'package:presence_absence/DB/Controllers/school_db_controller.dart';
import 'package:presence_absence/Pdf/pdf_data.dart';

mixin PdfHelper {
  Future<void> generateArabicPdfReport() async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load(
      "assets/fonts/Cairo/Cairo-Regular.ttf",
    );
    final ttf = pw.Font.ttf(fontData);
    var school = await SchoolDbController().read();
    await tableData();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                // الترويسة
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    // يمكنك وضع صورة الشعار هنا
                    pw.Container(
                      width: 50,
                      height: 50,
                      // child: pw.Image(...), // هنا تضيف صورة الشعار إذا كانت متاحة
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey),
                      ),
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          "مدرسة ${school[0].schoolName}",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                            'تقرير الغياب الأسبوعي للطلاب',
                          style: pw.TextStyle(font: ttf, fontSize: 14),
                        ),
                      ],
                    ),
                    /// ************************
                    pw.Column(
                      children: [
                        pw.Text(
                          ' التاريخ : ${DateTime.now().day.toString()}-${DateTime.now().month}-${DateTime.now().year}',
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                        ),
                        pw.Text(
                          'اليوم : ${DateFormat('EEEE', 'ar').format(DateTime.now())}',
                          style: pw.TextStyle(font: ttf, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Divider(thickness: 1, color: PdfColors.grey),

                pw.SizedBox(height: 20),

                // العنوان الرئيسي
                pw.SizedBox(height: 20),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      // العنوان
                      pw.Text(
                        'تقرير الغياب الأسبوعي للطلاب',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 20),

                      // الجدول
                      pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey600),
                        defaultVerticalAlignment:
                            pw.TableCellVerticalAlignment.middle,
                        children: [
                          // رؤوس الأعمدة
                          pw.TableRow(
                            decoration: pw.BoxDecoration(
                              color: PdfColors.blue50,
                            ),
                            children: [
                              ...days.map(
                                (day) => pw.Padding(
                                  padding: const pw.EdgeInsets.all(6),
                                  child: pw.Text(
                                    day,
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      font: ttf,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(6),
                                child: pw.Text(
                                  'اليوم',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // صف النسب
                          pw.TableRow(
                            children: [
                              ...List.generate(
                                5 - lastOfList.length,
                                (index) =>
                                    pw.Text('  -  ', style: pw.TextStyle(font: ttf),textAlign: pw.TextAlign.center),
                              ),
                              ...lastOfList.map(
                                (p) => pw.Padding(
                                  padding: const pw.EdgeInsets.all(6),
                                  child: pw.Text(
                                    "$p",
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(font: ttf),
                                  ),
                                ),
                              ),
                              /// ********************************
                              // if(x.length <= 5)...lastOfListForLessThanFiveItem.map(
                              //       (p) => pw.Padding(
                              //     padding: const pw.EdgeInsets.all(6),
                              //     child: pw.Text(
                              //       "$p",
                              //       textAlign: pw.TextAlign.center,
                              //       style: pw.TextStyle(font: ttf),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),

                      pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey600),
                        defaultVerticalAlignment:
                            pw.TableCellVerticalAlignment.middle,
                        children: [
                          // صف المجموع
                          pw.TableRow(
                            decoration: pw.BoxDecoration(
                              color: PdfColors.grey200,
                            ),
                            children: [
                              pw.Align(
                                alignment: pw.AlignmentDirectional.centerStart,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 20,
                                  ),
                                  child: pw.Text(
                                    "مجموع النسب المئوية : ${CacheController().getter("sum")} %",
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      font: ttf,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // صف المتوسط
                          pw.TableRow(
                            decoration: pw.BoxDecoration(
                              color: PdfColors.grey300,
                            ),
                            children: [
                              pw.Align(
                                alignment: pw.AlignmentDirectional.centerStart,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 20,
                                  ),
                                  child: pw.Text(
                                    " المتوسط :  ${CacheController().getter("average")}",
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      font: ttf,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 🟦 الجدول (كما حسّنّاه سابقًا)
                // انسخ الجدول من الرد السابق وضعه هنا
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/تقرير الغياب الأسبوعي${DateFormat().format(DateTime.now())}.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  List<String> lastOfList = [];
  List<String> beforeReversed = [] ;
  Future<void> tableData() async {
     beforeReversed = CacheController().getter("lastItem");
      lastOfList = beforeReversed.reversed.toList() ;
      print("reversed");
      print(beforeReversed) ;
      print("normal") ;
      print(lastOfList) ;
    table.add(days);
    // table.add(lastFive) ;
  }

  List<List> table = [];
  final days = [" الخميس ", " الأربعاء ", " الثلاثاء ", " الاثنين ", " الأحد "];

  List percentage = [];
}
