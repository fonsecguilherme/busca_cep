import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/cubit/theme_cubit.dart';

class AnimatedBarWidget extends StatelessWidget {
  const AnimatedBarWidget({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final isDarkThemeEnable = context.watch<ThemeCubit>().state.isDark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(
        bottom: 2.0,
      ),
      height: 4,
      width: isActive ? 36 : 0,
      decoration: BoxDecoration(
        color: isDarkThemeEnable ? Colors.white : Colors.black,
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
    );
  }
}
