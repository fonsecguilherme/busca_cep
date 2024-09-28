import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:zip_search/core/features/theme/theme_colors.dart';

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
  ThemeCubit() : super(AppTheme.light);

  void toggleTheme() {
    emit(switch (state) {
      AppTheme.light => AppTheme.dark,
      AppTheme.dark => AppTheme.light,
    });
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
