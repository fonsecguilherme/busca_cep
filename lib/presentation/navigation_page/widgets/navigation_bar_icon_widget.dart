import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:zip_search/core/model/nav_item_model.dart';
import 'package:zip_search/presentation/navigation_page/cubit/export_navigation_cubit.dart';

import 'animated_bar_widget.dart';

class NavigationBarIconWidget extends StatelessWidget {
  final NavigationState navigationState;
  final int selectedNavBarIndex;
  final NavItemModel icon;
  final void Function(Artboard)? onInit;
  final String iconText;
  final int iconPositionIndex;
  final bool isDarkThemeEnable;

  const NavigationBarIconWidget({
    super.key,
    required this.navigationState,
    required this.selectedNavBarIndex,
    required this.icon,
    required this.onInit,
    required this.iconText,
    required this.iconPositionIndex,
    required this.isDarkThemeEnable,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(
            height: 36,
            width: 36,
            child: Opacity(
              opacity: navigationState.index == selectedNavBarIndex ? 1 : 0.5,
              child: RiveAnimation.asset(
                isDarkThemeEnable ? icon.rive.srcLight : icon.rive.srcDark,
                artboard: icon.rive.artboard,
                onInit: onInit,
              ),
            ),
          ),
          Text(iconText),
          AnimatedBarWidget(
            isActive: navigationState.index == iconPositionIndex,
          ),
        ],
      );
}
