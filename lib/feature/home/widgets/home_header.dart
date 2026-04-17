import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskati_app/core/constants/app_image.dart';
import 'package:taskati_app/core/functions/extensions.dart';
import 'package:taskati_app/core/presentation/cubit/theme_cubit.dart';
import 'package:taskati_app/core/services/hive_helper.dart';
import 'package:taskati_app/core/styles/text_style.dart';
import 'package:taskati_app/feature/profile/page/profile_screen.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String name = '';
  String path = '';
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    String savedName = HiveHelper.getData(HiveHelper.nameKey) ?? 'User';
    String savedPath = HiveHelper.getData(HiveHelper.imageKey) ?? '';

    setState(() {
      name = savedName;
      path = savedPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        getData();
      },
      child: ListTile(
        leading: ClipOval(
          child: (path.isNotEmpty && File(path).existsSync())
              ? Image.file(File(path), height: 55, width: 55, fit: BoxFit.cover)
              : Image.asset(AppImage.user,
                  height: 55, width: 55, fit: BoxFit.cover),
        ),
        title: Text('Hello!', style: AppTextStyles.caption1.copyWith(
          color: context.isDarkMode ? Colors.white : Colors.black,
        )),
        subtitle: Text(name, style: AppTextStyles.title.copyWith(
          color: context.isDarkMode ? Colors.white : Colors.black,
        )),
        trailing: IconButton(
          onPressed: () {
            context.read<ThemeCubit>().changeTheme();
          },
          icon: Icon(
            context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
