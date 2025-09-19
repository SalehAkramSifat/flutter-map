import 'package:flutter/material.dart';
import 'package:flutter_map/feature/presentation/widget/custom_option_card_widget.dart';
import 'package:flutter_map/route/app_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.generalMapScreen);
                },
                child: CustomOptionCard(title: 'General Map'),
              ),
              SizedBox(height: 15.h),
              CustomOptionCard(title: 'General Map'),
              SizedBox(height: 15.h),

              CustomOptionCard(title: 'General Map')
            ],
          ),
        ),
      ),
    );
  }
}
