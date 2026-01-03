import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const price = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const summary = TextStyle(
    fontSize: 16,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const body = TextStyle(
    fontSize: 16,
    height: 1.6,
    color: AppColors.textPrimary,
  );
}
