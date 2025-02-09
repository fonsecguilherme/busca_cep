// import 'package:bloc_test/bloc_test.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get_it/get_it.dart';
// import 'package:zip_search/data/repositories/via_cep_repository_imp.dart';
// import 'package:zip_search/presentation/counter_page/counter_page.dart';
// import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
// import 'package:zip_search/presentation/favorite_page/favorite_page.dart';
// import 'package:zip_search/presentation/navigation_page/cubit/navigation_cubit.dart';
// import 'package:zip_search/presentation/navigation_page/cubit/navigation_state.dart';
// import 'package:zip_search/presentation/navigation_page/navigation_page.dart';
// import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
// import 'package:zip_search/presentation/search_page/search_page.dart';
// import 'package:zip_search/presentation/theme/cubit/theme_cubit.dart';
// import 'package:zip_search/data/shared_services.dart';
// import 'package:zip_search/domain/repositories/via_cep_repository.dart';

// import '../../firebase_mock.dart';

// class MockNavigationCubit extends MockCubit<NavigationState>
//     implements NavigationCubit {}

// late NavigationCubit navigationCubit;

// void main() {
//   setupFirebaseAnalyticsMocks();
//   final getItTest = GetIt.instance;

//   setUp(() async {
//     await Firebase.initializeApp();
//     navigationCubit = MockNavigationCubit();
//     getItTest.registerLazySingleton<IViaCepRepository>(
//       () => ViaCepRepositoryImp(),
//     );
//     getItTest.registerLazySingleton<SharedServices>(
//       () => SharedServices(),
//     );
//     getItTest.registerLazySingleton(() => FirebaseAnalytics.instance);
//   });

//   tearDown(
//     () => getItTest.reset(),
//   );

//   testWidgets(
//     'Find counter page',
//     (tester) async {
//       await _createWidget(tester);

//       expect(find.byType(CounterPage), findsOneWidget);
//     },
//   );

//   testWidgets('Go to search page', (tester) async {
//     await _createWidget(tester);

//     final iconButton = find.byIcon(CupertinoIcons.search);

//     await tester.tap(iconButton);

//     await tester.pump();

//     expect(find.byType(SearchPage), findsOneWidget);
//   });

//   testWidgets(
//     'Find favorites page',
//     (tester) async {
//       await _createWidget(tester);

//       final iconButton = find.byKey(NavigationPage.navigationBarStarIcon);

//       await tester.tap(iconButton);

//       await tester.pump();

//       expect(find.byType(FavoritePage), findsOneWidget);
//     },
//   );
// }

// final _sharedServices = SharedServices();
// final _repository = ViaCepRepositoryImp();

// Future<void> _createWidget(WidgetTester tester) async {
//   await tester.pumpWidget(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => NavigationCubit(),
//         ),
//         BlocProvider(
//           create: (context) => FavoriteCubit(
//             sharedServices: _sharedServices,
//           ),
//         ),
//         BlocProvider(
//           create: (context) => SearchCubit(
//             viaCepRepository: _repository,
//             sharedServices: _sharedServices,
//           ),
//         ),
//         BlocProvider(
//           create: (context) => ThemeCubit(),
//         )
//       ],
//       child: const MaterialApp(
//         home: NavigationPage(),
//       ),
//     ),
//   );
//   await tester.pump();
// }
