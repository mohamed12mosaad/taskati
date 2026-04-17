import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:taskati_app/core/constants/app_image.dart';
import 'package:taskati_app/core/presentation/cubit/theme_cubit.dart';
import 'package:taskati_app/core/presentation/cubit/theme_state.dart';
import 'package:taskati_app/core/services/hive_helper.dart';
import 'package:taskati_app/core/styles/colors.dart';
import 'package:taskati_app/core/styles/themes.dart';
import 'package:taskati_app/feature/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Hive.box('userBox');
    
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final isDarkMode = context.read<ThemeCubit>().isDarkMode;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            builder: (context, child) {
              final overlayStyle = isDarkMode
                  ? const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                      statusBarBrightness: Brightness.dark,
                    )
                  : const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                    );

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: overlayStyle,
                child: SafeArea(
                  top: false,
                  bottom: Platform.isAndroid,
                  child: Stack(
                    children: [
                      Container(
                        color: isDarkMode
                            ? AppColors.blackColor
                            : AppColors.whiteColor,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Image.asset(
                        AppImage.background,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      child ?? Container(),
                    ],
                  ),
                ),
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
