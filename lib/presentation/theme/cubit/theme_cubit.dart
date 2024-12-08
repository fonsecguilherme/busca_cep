import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:zip_search/core/di/setup_locator.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/presentation/theme/theme_colors.dart';

import '../../../core/commons/shared_preferences_keys.dart';

enum AppTheme {
  light,
  dark;

  bool get isDark => this == AppTheme.dark;
  bool get isLight => !isDark;

  ThemeData get value => switch (this) {
        AppTheme.light => ThemeColors.lightTheme,
        AppTheme.dark => ThemeColors.darkTheme
      };
}

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.light) {
    _getThemeFromPrefs();
  }

  final sharedServices = getIt<SharedServices>();

  Future<void> _getThemeFromPrefs() async {
    final isDarkThemeEnable =
        await sharedServices.getBool(SharedPreferencesKeys.isDarkThemeEnable) ??
            false;
    final savedTheme = isDarkThemeEnable ? AppTheme.dark : AppTheme.light;

    emit(savedTheme);
  }

  Future<void> toggleTheme() async {
    switch (state) {
      case AppTheme.light:
        sharedServices.saveBool(
          SharedPreferencesKeys.isDarkThemeEnable,
          true,
        );

        emit(AppTheme.dark);

      case AppTheme.dark:
        sharedServices.saveBool(
          SharedPreferencesKeys.isDarkThemeEnable,
          false,
        );

        emit(AppTheme.light);
    }
  }

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(
          Icons.wb_sunny_outlined,
          color: Colors.black,
        );
      }
      return const Icon(Icons.dark_mode);
    },
  );
}
