import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taskati_app/core/functions/extensions.dart';
import 'package:taskati_app/core/functions/navigations.dart';
import 'package:taskati_app/core/models/task_model.dart';
import 'package:taskati_app/core/services/hive_helper.dart';
import 'package:taskati_app/core/styles/colors.dart';
import 'package:taskati_app/core/styles/text_style.dart';
import 'package:taskati_app/feature/home/pages/add_task.dart';
import 'package:taskati_app/feature/home/widgets/home_header.dart';
import 'package:taskati_app/feature/home/widgets/task_list_builder.dart';
import 'package:taskati_app/feature/home/widgets/tody_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatePickerController controller = DatePickerController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      controller.animateToSelection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () => pushTo(context, const AddTask()),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ValueListenableBuilder(
              valueListenable: HiveHelper.taskBox.listenable(),
              builder: (context, Box<TaskModel> box, _) {
                String formattedDate = DateFormat('dd MMM, yyyy').format(_selectedDate);
                var filteredTasks = box.values.where((task) => task.date == formattedDate).toList();

                int totalCount = filteredTasks.length;
                int completedCount = filteredTasks.where((task) => task.isCompleted).length;
                int percentage = totalCount == 0 ? 0 : ((completedCount / totalCount) * 100).toInt();

                return Column(
                  children: [
                    const HomeHeader(),
                    const Gap(24),
                    TodyProgress(
                      progessPercentage: percentage,
                      selectedDate: _selectedDate,
                    ),
                    const Gap(30),
                    DatePicker(
                      DateTime.now().subtract(const Duration(days: 10)),
                      height: 90,
                      initialSelectedDate: DateTime.now(),
                      controller: controller,
                      selectionColor: AppColors.primaryColor,
                      selectedTextColor: context.cardColor,
                      dateTextStyle: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
                      monthTextStyle: AppTextStyles.caption2,
                      dayTextStyle: AppTextStyles.caption2,
                      onDateChange: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    const Gap(32),
                    ButtonsTabBar(
                      backgroundColor: AppColors.primaryColor,
                      unselectedBackgroundColor: AppColors.accentColor,
                      labelStyle: AppTextStyles.caption1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: AppTextStyles.caption1.copyWith(
                        color: AppColors.primaryColor,
                      ),
                      contentCenter: true,
                      radius: 15,
                      width: (MediaQuery.sizeOf(context).width - 40) / 3,
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'In Progress'),
                        Tab(text: 'Completed'),
                      ],
                    ),
                    const Gap(32),
                    Expanded(
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          TaskListBuilder(selectedDate: _selectedDate, filterStatus: 0),
                          TaskListBuilder(selectedDate: _selectedDate, filterStatus: 1),
                          TaskListBuilder(selectedDate: _selectedDate, filterStatus: 2),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}