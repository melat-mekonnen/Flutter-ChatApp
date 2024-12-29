import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/pages/media_service.dart';
import 'package:testapp/services/alert_service.dart';
import 'package:testapp/services/auth_service.dart';
import 'package:testapp/services/databse_service.dart';
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

  getIt.registerSingleton<DatabaseService>(DatabaseService());
}

// Function to generate a unique chat ID based on two user IDs
String generateChatId(String uid1, String uid2) {

  List uids = [uid1, uid2];

  // Sort the user IDs in ascending order to ensure consistent order
  uids.sort();

  // Create a single chatID usind the 'fold' method iterates through the list and concatenates the user IDs
  String chatId = uids.fold("", (currentUid, nextUid) => "$currentUid$nextUid");

  return chatId;
}

