import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
import 'package:zip_search/data/shared_services.dart';
import 'package:zip_search/domain/repositories/via_cep_repository.dart';

import '../../data/repositories/via_cep_repository_imp.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<FirebaseAnalytics>(
    () => FirebaseAnalytics.instance,
  );

  getIt.registerLazySingleton<IViaCepRepository>(
    () => ViaCepRepositoryImp(),
  );

  getIt.registerLazySingleton<SharedServices>(
    () => SharedServices(),
  );
}
