import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskati_app/core/constants/app_image.dart';
import 'package:taskati_app/core/styles/colors.dart';
import 'package:taskati_app/core/styles/text_style.dart';

class AddTaskTime extends StatelessWidget {
  const AddTaskTime({
    super.key,
    required this.text,
    required this.value,
    required this.iconPath,
    this.onTap,
  });

  final String text;
  final String value;
  final String iconPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentColor.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          horizontalTitleGap: 12,
          leading: SvgPicture.asset(
            iconPath,
            height: 24,
            width: 24,
          ),
          title: Text(
            text,
            style: AppTextStyles.caption2
                .copyWith(color: AppColors.seconderyColor, fontSize: 12),
          ),
          subtitle: Text(
            value,
            style: AppTextStyles.caption1.copyWith(fontWeight: FontWeight.w500),
          ),
          trailing: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onTap,
            constraints: const BoxConstraints(),
            icon: SvgPicture.asset(
              AppImage.arrowDownSvg,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
