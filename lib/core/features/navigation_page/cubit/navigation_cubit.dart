import 'package:bloc/bloc.dart';
import 'package:zip_search/core/features/navigation_page/cubit/navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavBarItem.counter, 0));

  void getNavBarItem(NavBarItem navBarItem) {
    switch (navBarItem) {
      case NavBarItem.counter:
        emit(const NavigationState(NavBarItem.counter, 0));
        break;
      case NavBarItem.search:
        emit(const NavigationState(NavBarItem.search, 1));
        break;
      case NavBarItem.saved:
        emit(const NavigationState(NavBarItem.saved, 2));
        break;
    }
  }
}
