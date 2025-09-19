import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextStyle? hintTextStyle;
  final ValueChanged<String>? onChanged;
  final Function(String)? onFieldSubmit;
  final Function(PointerDownEvent)? onTapOutside;
  final Color? containerColor;
  final Color? containerBorderColor;
  final double? containerBorderWidth;
  final double? radius;
  final int? maxLines;
  final bool readonly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final String? prefixIconPath;
  final String? prefixText;
  final TextStyle? prefixTextStyle;
  final Widget? suffixIcon;
  final String? suffixIconPath;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final VoidCallback? onTap; // Add this line

  const CustomTextFormField({
    super.key,
     this.controller,
    required this.hintText,
    this.hintTextStyle,
    this.onChanged,
    this.onFieldSubmit,
    this.onTapOutside,
    this.containerColor,
    this.containerBorderColor,
    this.containerBorderWidth,
    this.maxLines,
    this.radius,
    this.readonly = false,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.prefixIconPath,
    this.prefixText,
    this.prefixTextStyle,
    this.suffixIcon,
    this.suffixIconPath,
    this.suffixText,
    this.suffixTextStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor ?? Colors.white,
        border: Border.all(
          color: containerBorderColor ?? Color(0xffF1F1F1),
          width: containerBorderWidth ?? 1.5,
        ),
        borderRadius: BorderRadius.circular(radius ?? 16.h),
      ),
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: onFieldSubmit,
        onTapOutside: onTapOutside,
        readOnly: readonly,
        obscureText: obscureText,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              hintTextStyle ??
              GoogleFonts.onest(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
          prefixText: prefixText != null ? '$prefixText  ' : null,
          prefixStyle:
              prefixTextStyle ??
              GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
          prefixIcon:
              prefixIcon ??
              (prefixIconPath != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: Image.asset(prefixIconPath!, width: 1.w),
                    )
                  : null),
          suffixIcon:
              suffixIcon ??
              (suffixIconPath != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 11.w),
                      child: Image.asset(suffixIconPath!, width: 26.w),
                    )
                  : null),
          suffixText: suffixText != null ? '  $suffixText' : null,
          suffixStyle:
              suffixTextStyle ??
              GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
          border: border ?? InputBorder.none,
          focusedBorder: focusedBorder ?? InputBorder.none,
          focusedErrorBorder: focusedErrorBorder ?? InputBorder.none,
          enabledBorder: enabledBorder ?? InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        ),
      ),
    );
  }
}