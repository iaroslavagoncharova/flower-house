import 'package:flutter/material.dart';
import 'package:flutter_flower_shop/core/theme/app_colors.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const ActionButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: AppColors.primary,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
