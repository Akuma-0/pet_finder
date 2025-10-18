import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors_manager.dart';

class AppElevatedButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final Widget buttonChild;
  final VoidCallback onPressed;
  const AppElevatedButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.buttonHeight,
    this.buttonWidth,
    required this.buttonChild,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((.25 * 255).round()),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? ColorsManager.tealB6,
          ),
          fixedSize: WidgetStateProperty.all(
            Size(buttonWidth?.w ?? 297.w, buttonHeight ?? 54.h),
          ),
        ),
        onPressed: onPressed,
        child: buttonChild,
      ),
    );
  }
}
