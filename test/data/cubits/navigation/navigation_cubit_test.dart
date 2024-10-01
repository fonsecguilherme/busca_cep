import 'package:bloc_test/bloc_test.dart';
import 'package:zip_search/presentation/navigation_page/cubit/navigation_cubit.dart';
import 'package:zip_search/presentation/navigation_page/cubit/navigation_state.dart';

void main() {
  blocTest<NavigationCubit, NavigationState>(
    'Navigate to counter page',
    build: () => NavigationCubit(),
    act: (cubit) => cubit.getNavBarItem(NavBarItem.counter),
    expect: () => const <NavigationState>[
      NavigationState(NavBarItem.counter, 0),
    ],
  );

  blocTest<NavigationCubit, NavigationState>(
    'Navigate to search page',
    build: () => NavigationCubit(),
    act: (cubit) => cubit.getNavBarItem(NavBarItem.search),
    expect: () => const <NavigationState>[
      NavigationState(NavBarItem.search, 1),
    ],
  );

  blocTest<NavigationCubit, NavigationState>(
    'Navigate to favorites page',
    build: () => NavigationCubit(),
    act: (cubit) => cubit.getNavBarItem(NavBarItem.saved),
    expect: () => const <NavigationState>[
      NavigationState(NavBarItem.saved, 2),
    ],
  );
}
