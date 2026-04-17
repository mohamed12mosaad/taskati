import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:taskati_app/core/constants/app_image.dart';
import 'package:taskati_app/core/functions/navigations.dart';
import 'package:taskati_app/core/models/task_model.dart';
import 'package:taskati_app/core/services/hive_helper.dart';
import 'package:taskati_app/core/styles/colors.dart';
import 'package:taskati_app/feature/home/pages/add_task.dart';
import 'package:taskati_app/feature/home/widgets/task_item.dart';

class TaskListBuilder extends StatelessWidget {
  final DateTime selectedDate;
  final int filterStatus;

  const TaskListBuilder({
    super.key,
    required this.selectedDate,
    required this.filterStatus,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM, yyyy').format(selectedDate);

    return ValueListenableBuilder(
      valueListenable: HiveHelper.taskBox.listenable(),
      builder: (context, Box<TaskModel> box, _) {
        List<TaskModel> tasks = box.values.where((task) {
          bool isSameDate = task.date == formattedDate;
          if (filterStatus == 1) return isSameDate && !task.isCompleted;
          if (filterStatus == 2) return isSameDate && task.isCompleted;
          return isSameDate;
        }).toList();

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AppImage.emptyJson, width: 250),
                const Gap(20),
                Text(
                  'No tasks for this day!',
                  style: TextStyle(color: Colors.grey[500], fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: tasks.length,
          padding: const EdgeInsets.only(top: 10, bottom: 80),
          separatorBuilder: (context, index) => const Gap(15),
          itemBuilder: (context, index) {
            final task = tasks[index];

            return Slidable(
              key: ValueKey(task.id),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(
                  onDismissed: () {
                    box.delete(task.id);
                  },
                ),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      box.delete(task.id);
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  if (!task.isCompleted)
                    SlidableAction(
                      onPressed: (context) {
                        box.put(task.id, task.copyWith(isCompleted: true));
                      },
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.done,
                      label: 'Complete',
                    ),
                  SlidableAction(
                    onPressed: (context) {
                      pushTo(context, AddTask(task: task));
                    },
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),
              child: TaskItem(
                title: task.title,
                note: task.description,
                startTime: task.startTime,
                endTime: task.endTime,
                isCompleted: task.isCompleted,
              ),
            );
          },
        );
      },
    );
  }
}