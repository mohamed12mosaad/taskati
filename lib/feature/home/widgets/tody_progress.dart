import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskati_app/core/styles/colors.dart';
import 'package:taskati_app/core/styles/text_style.dart';

class TodyProgress extends StatelessWidget {
  const TodyProgress({
    super.key,
    required this.progessPercentage,
    required this.selectedDate,
  });

  final int progessPercentage;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.MMMEd().format(selectedDate),
                  style: AppTextStyles.caption1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Gap(13),
                Text(
                  progessPercentage == 100
                      ? 'Great job!\nAll tasks completed!'
                      : 'Your tasks for this day\nalmost done!',
                  style: AppTextStyles.caption1.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                tween: Tween<double>(begin: 0, end: progessPercentage / 100),
                builder: (context, value, _) {
                  return CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: const Color(0xff8764FF),
                    value: value,
                    strokeWidth: 9,
                    strokeCap: StrokeCap.round,
                    constraints: const BoxConstraints.tightFor(width: 76, height: 76),
                  );
                },
              ),
              Text(
                '$progessPercentage%',
                style: AppTextStyles.caption1.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}