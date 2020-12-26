//import 'package:prasso_app/main.dart' as app;
import 'package:prasso_app/services/firestore_database.dart';
import 'package:mockito/mockito.dart';
import 'package:prasso_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

class MockDatabase extends Mock implements FirestoreDatabase {}

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  runApp(PrassoCore(
    databaseBuilder: (_, __) => MockDatabase(),
  ));
}
