import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_cubit.dart';
import 'package:zip_search/data/cubits/search_zip/search_zip_state.dart';
import 'package:zip_search/pages/search_page/widgets/initial_widget.dart';

class MockSearchZipCubit extends MockCubit<SearchZipState>
    implements SearchZipCubit {}

late SearchZipCubit searchZipCubit;

void main() {
  setUp(() {
    searchZipCubit = MockSearchZipCubit();
  });

  testWidgets('Find inital widget when app loads', (tester) async {
    await _createWidget(tester);

    expect(find.byKey(InitialWidget.initialWidgetKey), findsOneWidget);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    BlocProvider<SearchZipCubit>.value(
      value: searchZipCubit,
      child: const MaterialApp(
        home: Scaffold(
          body: InitialWidget(),
        ),
      ),
    ),
  );
  await tester.pump();
}
