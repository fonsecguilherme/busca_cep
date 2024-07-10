import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_cubit.dart';
import 'package:zip_search/core/features/search_page/cubit/search_zip_state.dart';
import 'package:zip_search/core/features/search_page/widgets/initial_widget.dart';

class MockSearchZipCubit extends MockCubit<SearchZipState>
    implements SearchZipCubit {}

class MockTracker extends Mock implements FirebaseAnalytics {}

late SearchZipCubit searchZipCubit;
late FirebaseAnalytics analytics;

void main() {
  setUp(() {
    searchZipCubit = MockSearchZipCubit();
    analytics = MockTracker();
  });

  testWidgets('Find inital widget when app loads', (tester) async {
    when(() => searchZipCubit.state).thenReturn(InitialSearchZipState());

    await _createWidget(tester);

    expect(find.byKey(InitialWidget.initialWidgetKey), findsOneWidget);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    BlocProvider<SearchZipCubit>.value(
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
