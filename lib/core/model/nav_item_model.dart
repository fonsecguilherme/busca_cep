import 'rive_model.dart';

class NavItemModel {
  final String title;
  final RiveModel rive;

  NavItemModel({
    required this.title,
    required this.rive,
  });
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(
    title: 'Home',
    rive: RiveModel(
      src: 'assets/animated_icons.riv',
      artboard: 'HOME',
      stateMachine: 'HOME_interactivity',
    ),
  ),
  NavItemModel(
    title: 'Search',
    rive: RiveModel(
      src: 'assets/animated_icons.riv',
      artboard: 'SEARCH',
      stateMachine: 'SEARCH_Interactivity',
    ),
  ),
  NavItemModel(
    title: 'Like',
    rive: RiveModel(
      src: 'assets/animated_icons.riv',
      artboard: 'LIKE/STAR',
      stateMachine: 'STAR_Interactivity',
    ),
  ),
];
List<NavItemModel> whiteBottomNavItems = [
  NavItemModel(
    title: 'Home',
    rive: RiveModel(
      src: 'assets/animated_icons_white.riv',
      artboard: 'HOME',
      stateMachine: 'HOME_interactivity',
    ),
  ),
  NavItemModel(
    title: 'Search',
    rive: RiveModel(
      src: 'assets/animated_icons_white.riv',
      artboard: 'SEARCH',
      stateMachine: 'SEARCH_Interactivity',
    ),
  ),
  NavItemModel(
    title: 'Like',
    rive: RiveModel(
      src: 'assets/animated_icons_white.riv',
      artboard: 'LIKE/STAR',
      stateMachine: 'STAR_Interactivity',
    ),
  ),
];
