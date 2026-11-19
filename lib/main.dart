import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskati_app/core/constants/app_image.dart';
import 'package:taskati_app/core/presentation/cubit/theme_cubit.dart';
import 'package:taskati_app/core/presentation/cubit/theme_state.dart';
import 'package:taskati_app/core/services/database_helper.dart';
import 'package:taskati_app/core/styles/colors.dart';
import 'package:taskati_app/core/styles/themes.dart';
import 'package:taskati_app/feature/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final bool isDarkMode = context.read<ThemeCubit>().isDarkMode;

          return MaterialApp(
            debugShowCheckedModeBanner: false,

            // Light Theme
            theme: AppTheme.light,

            // Dark Theme
            darkTheme: AppTheme.dark,

            // Current Theme
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

            builder: (context, child) {
              final SystemUiOverlayStyle overlayStyle = isDarkMode
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
                      // Background Color
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: isDarkMode
                            ? AppColors.blackColor
                            : AppColors.whiteColor,
                      ),

                      // Background Image
                      Image.asset(
                        AppImage.background,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      // App Content
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
