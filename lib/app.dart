import 'package:flutter/material.dart';
import 'package:flutter_map/route/app_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Abdi',

          themeMode: ThemeMode.light,
          initialRoute: AppRoute.homeScreen,
          getPages: AppRoute.pages,
        );
      },
    );
  }
}
