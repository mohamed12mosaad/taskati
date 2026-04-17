import 'package:flutter/material.dart';
import 'package:taskati_app/core/functions/extensions.dart';
import 'package:taskati_app/core/styles/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.suffix,
    this.prefix,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.controller,
    this.height,
    this.width,
    this.maxLines = 1,
  });

  final String? hintText;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final double? height;
  final double? width;
  final int? maxLines;
  final Function()? onTap;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: context.isDarkMode ? [] : [
            BoxShadow(
              color: AppColors.accentColor.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: (maxLines != null && maxLines! > 1)
              ? TextInputType.multiline
              : keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: prefixIcon,
            suffixIcon: suffix,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          validator: validator,
          onTap: onTap,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
