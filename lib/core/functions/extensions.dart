import 'package:flutter/material.dart';
import 'package:taskati_app/core/services/database_helper.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  Color get cardColor => theme.cardColor;
  Color get hoverColor => theme.hoverColor;
  bool get isDarkMode => DatabaseHelper.getData(DatabaseHelper.isDarkModeKey) == true;
}

extension NavigationExtension on BuildContext {
  void pushTo(Widget newScreen) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => newScreen));
  }
}

extension SpaceExtension on num {
  SizedBox get h {
    return SizedBox(height: toDouble());
  }
}
