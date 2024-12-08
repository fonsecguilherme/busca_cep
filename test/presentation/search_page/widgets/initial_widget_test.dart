import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';
import 'package:zip_search/presentation/search_page/widgets/initial_widget.dart';

class MockSearchZipCubit extends MockCubit<SearchState>
    implements SearchCubit {}

class MockTracker extends Mock implements FirebaseAnalytics {}

late SearchCubit searchZipCubit;
late FirebaseAnalytics analytics;

void main() {
  setUp(() {
    searchZipCubit = MockSearchZipCubit();
    analytics = MockTracker();

    when(() => searchZipCubit.getBrStates()).thenReturn([]);
  });

  testWidgets('Find inital widget when app loads', (tester) async {
    when(() => searchZipCubit.state).thenReturn(const InitialSearchState());

    await _createWidget(tester);

    expect(find.byKey(InitialWidget.initialWidgetKey), findsOneWidget);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    BlocProvider<SearchCubit>.value(
      value: searchZipCubit,
      child: MaterialApp(
        home: Scaffold(
          body: InitialWidget(
            analytics: analytics,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
