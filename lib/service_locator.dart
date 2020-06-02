import 'package:firbase_chat/core/services/firebaseapi.dart';
import 'package:firbase_chat/core/viewmodels/chatModel.dart';
import 'package:firbase_chat/core/viewmodels/firCrudModel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseApi());
  locator.registerLazySingleton(() => FirCrudModel());
  locator.registerFactory(() => ChatModel());
}
