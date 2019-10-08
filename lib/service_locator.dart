import 'package:get_it/get_it.dart';
import 'package:school/view_model/language_view_model.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => LanguageModel());
}