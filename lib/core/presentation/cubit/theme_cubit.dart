import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskati_app/core/presentation/cubit/theme_state.dart';
import 'package:taskati_app/core/services/database_helper.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitialState());

  bool isDarkMode = DatabaseHelper.getData(DatabaseHelper.isDarkModeKey) == true;

  void changeTheme() {
    isDarkMode = !isDarkMode;
    DatabaseHelper.cacheData(DatabaseHelper.isDarkModeKey, isDarkMode);
    emit(ThemeChangedState());
  }
}
