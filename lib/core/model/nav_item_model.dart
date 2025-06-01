import 'rive_model.dart';

class NavItemModel {
  final String title;
  final RiveAsset rive;

  NavItemModel({
    required this.title,
    required this.rive,
  });
}

List<RiveAsset> bottomNavItems = [
  RiveAsset(
    srcDark: 'assets/animated_icons.riv',
    srcLight: 'assets/animated_icons_white.riv',
    artboard: 'HOME',
    stateMachineName: 'HOME_interactivity',
    title: 'Home',
  ),
  RiveAsset(
    srcDark: 'assets/animated_icons.riv',
    srcLight: 'assets/animated_icons_white.riv',
    artboard: 'SEARCH',
    stateMachineName: 'SEARCH_Interactivity',
    title: 'Search',
  ),
  RiveAsset(
    srcDark: 'assets/animated_icons.riv',
    srcLight: 'assets/animated_icons_white.riv',
    artboard: 'LIKE/STAR',
    stateMachineName: 'STAR_Interactivity',
    title: 'Like',
  )
];
