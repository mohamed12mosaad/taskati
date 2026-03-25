import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskati_app/core/constants/app_image.dart';
import 'package:taskati_app/core/constants/functions/navigations.dart';
import 'package:taskati_app/core/models/task_model.dart';
import 'package:taskati_app/core/services/hive_helper.dart';
import 'package:taskati_app/core/styles/colors.dart';
import 'package:taskati_app/core/styles/text_style.dart';
import 'package:taskati_app/core/styles/widgets/custem_text_form_fielf.dart';
import 'package:taskati_app/core/styles/widgets/main_button.dart';
import 'package:taskati_app/feature/home/pages/home_screen.dart';
import 'package:taskati_app/feature/home/widgets/add_task_time.dart';

class AddTask extends StatefulWidget {
  final TaskModel? task;
  const AddTask({super.key, this.task});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late String _date;
  late String _startTime;
  late String _endTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? "");
    _date =
        widget.task?.date ?? DateFormat('dd MMM, yyyy').format(DateTime.now());
    _startTime =
        widget.task?.startTime ?? DateFormat('hh:mm a').format(DateTime.now());
    _endTime = widget.task?.endTime ??
        DateFormat('hh:mm a').format(
          DateTime.now().add(const Duration(hours: 1)),
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2060),
    );

    if (pickedDate != null) {
      setState(() {
        _date = DateFormat('dd MMM, yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime.format(context);
        } else {
          _endTime = pickedTime.format(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(AppImage.back, height: 30, width: 30),
        ),
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task',
            style: AppTextStyles.headline),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title',
                  style: AppTextStyles.caption1
                      .copyWith(color: AppColors.seconderyColor)),
              const Gap(8),
              CustomTextFormField(
                  controller: _titleController,
                  hintText: 'Enter title here',
                  maxLines: 1),
              const Gap(18),
              Text('Description',
                  style: AppTextStyles.caption1
                      .copyWith(color: AppColors.seconderyColor)),
              const Gap(14),
              CustomTextFormField(
                  controller: _descriptionController,
                  hintText: 'Enter description here',
                  height: 100,
                  maxLines: 5),
              const Gap(41),
              AddTaskTime(
                iconPath: AppImage.calendarSvg,
                text: 'Date',
                value: _date,
                onTap: _getDateFromUser,
              ),
              const Gap(24),
              AddTaskTime(
                iconPath: AppImage.timeSvg,
                text: 'Start Time',
                value: _startTime,
                onTap: () => _getTimeFromUser(isStartTime: true),
              ),
              const Gap(12),
              AddTaskTime(
                iconPath: AppImage.timeSvg,
                text: 'End Time',
                value: _endTime,
                onTap: () => _getTimeFromUser(isStartTime: false),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),
        child: MainButton(
          text: widget.task == null ? "Add Task" : "Update Task",
          onPress: () {
            if (_titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty) {
              String id = widget.task?.id ??
                  DateTime.now().millisecondsSinceEpoch.toString();

              HiveHelper.cacheTask(
                id,
                TaskModel(
                  id: id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  date: _date,
                  startTime: _startTime,
                  endTime: _endTime,
                  isCompleted: widget.task?.isCompleted ?? false,
                ),
              );

              PopTo(context, const HomeScreen());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields!')),
              );
            }
          },
        ),
      ),
    );
  }
}
