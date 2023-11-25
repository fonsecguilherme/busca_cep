import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zip_search/core/features/favorites_zip_page/cubit/favorites_cubit.dart';
import 'package:zip_search/core/features/navigation_page/cubit/navigation_cubit.dart';
import 'package:zip_search/core/features/navigation_page/cubit/navigation_state.dart';
import 'package:zip_search/core/features/counter_page/counter_page.dart';
import 'package:zip_search/core/features/favorites_zip_page/favorites_zip_page.dart';
import 'package:zip_search/core/features/navigation_page/navigation_page.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/features/search_page/search_page.dart';

class MockNavigationCubit extends MockCubit<NavigationState>
    implements NavigationCubit {}

late NavigationCubit navigationCubit;

void main() {
  setUp(() {
    navigationCubit = MockNavigationCubit();
  });

  testWidgets(
    'Find counter page',
    (tester) async {
      await _createWidget(tester);

      expect(find.byType(CounterPage), findsOneWidget);
    },
  );

  testWidgets('Go to search page', (tester) async {
    await _createWidget(tester);

    final iconButton = find.byIcon(Icons.search);

    await tester.tap(iconButton);

    await tester.pump();

    expect(find.byType(SearchPage), findsOneWidget);
  });

  testWidgets(
    'Find favorites page',
    (tester) async {
      await _createWidget(tester);

      final iconButton = find.byIcon(Icons.star_border_rounded);

      await tester.tap(iconButton);

      await tester.pump();

      expect(find.byType(FavoritesZipPAge), findsOneWidget);
    },
  );
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit(),
        ),
        BlocProvider(
          create: (context) => SearchZipCubit(),
        ),
      ],
      child: const MaterialApp(
        home: NavigationPage(),
      ),
    ),
  );
  await tester.pump();
}
