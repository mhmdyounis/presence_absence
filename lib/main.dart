import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presence_absence/Cache/cache_controller.dart';
import 'package:presence_absence/DB/db_settings.dart';
import 'package:presence_absence/Get/school_getx_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:presence_absence/Screens/onBording.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await CacheController().initCache();
  Get.lazyPut<SchoolGetxController>(() => SchoolGetxController());
  await DbSettings().initDb() ;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: Locale('ar'),
        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primaryColor: Colors.deepPurple/*Color(0xff5C5EC8)*/,
          canvasColor: Color(0xffFF9800),
          hoverColor: Color(0xff4CAF50),
          primaryColorDark: Color(0xffF44336),
          scaffoldBackgroundColor: /*Color(0xffF5F5F5)*/Colors.white,
          fontFamily: 'cairo',
        ),
        home:  Onbording(),
      ),
    );
  }
}


