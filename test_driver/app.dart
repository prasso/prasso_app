// Flutter imports:
// Package imports:
// Project imports:
import 'package:delegate_app/app_widgets/top_level_providers.dart';
import 'package:delegate_app/main.dart';
import 'package:delegate_app/services/firestore_database.dart';
import 'package:delegate_app/services/prasso_api_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../test/mocks.dart';

// Run with:
// flutter drive --target=test_driver/app.dart
Future<void> main() async {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // TODO: Somehow Firebase.initializeApp() is required when running this driver test
  // Need to figure out what code path triggers this as both FirebaseAuth and Firestore are mocked
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  runApp(ProviderScope(
    overrides: [
      prassoApiService.overrideWithProvider(
          Provider<PrassoApiRepository?>((ref) => MockAuthService())),
      databaseProvider.overrideWithProvider(
          Provider<FirestoreDatabase?>((ref) => MockDatabase())),
    ],
    child: PrassoCore(),
  ));
}
