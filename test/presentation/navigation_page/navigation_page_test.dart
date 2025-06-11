import 'package:bloc_test/bloc_test.dart';
import 'package:zip_search/presentation/navigation_page/cubit/navigation_cubit.dart';
import 'package:zip_search/presentation/navigation_page/cubit/navigation_state.dart';

class MockNavigationCubit extends MockCubit<NavigationState>
    implements NavigationCubit {}

late NavigationCubit navigationCubit;

void main() {
  // setupFirebaseAnalyticsMocks();
  // final getItTest = GetIt.instance;

  // setUp(() async {
  //   await Firebase.initializeApp();
  //   navigationCubit = MockNavigationCubit();
  //   getItTest.registerLazySingleton<IViaCepRepository>(
  //     () => ViaCepRepositoryImp(),
  //   );
  //   getItTest.registerLazySingleton<SharedServices>(
  //     () => SharedServices(),
  //   );
  //   getItTest.registerLazySingleton(() => FirebaseAnalytics.instance);
  // });

  // tearDown(
  //   () => getItTest.reset(),
  // );

  // testWidgets(
  //   'Find counter page',
  //   (tester) async {
  //     await _createWidget(tester);

  //     expect(find.byType(CounterPage), findsOneWidget);
  //   },
  // );

  // testWidgets('Go to search page', (tester) async {
  //   await _createWidget(tester);

  //   final iconButton = find.byIcon(CupertinoIcons.search);

  //   await tester.tap(iconButton);

  //   await tester.pump();

  //   expect(find.byType(SearchPage), findsOneWidget);
  // });

  // testWidgets(
  //   'Find favorites page',
  //   (tester) async {
  //     await _createWidget(tester);

  //     final iconButton = find.byKey(NavigationPage.navigationBarStarIcon);

  //     await tester.tap(iconButton);

  //     await tester.pump();

  //     expect(find.byType(FavoritePage), findsOneWidget);
  //   },
  // );
}

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
