import 'package:flutter/material.dart';
import 'package:flutter_map/core/common/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOptionCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final IconData trailingIcon;
  final VoidCallback? onTap;

  const CustomOptionCard({
    super.key,
    required this.title,
    this.backgroundColor = Colors.blue,
    this.trailingIcon = Icons.arrow_forward_outlined,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 8.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: title, fontSize: 16),
            Icon(trailingIcon, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
