import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../gen/colors.gen.dart';

class WaitingWidget extends StatelessWidget {
  final String? message;
  
  const WaitingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.allPrimaryColor,
            strokeWidth: 3.w,
          ),
          SizedBox(height: 16.h),
          Text(
            message ?? 'Loading...',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.c606060,
            ),
          ),
        ],
      ),
    );
  }
}