import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/pages/media_service.dart';
import 'package:testapp/services/alert_service.dart';
import 'package:testapp/services/auth_service.dart';
import 'package:testapp/services/navigation_service.dart';
import 'firebase_options.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AlertService>(AlertService());
  getIt.registerSingleton<MediaService>(MediaService());
}
