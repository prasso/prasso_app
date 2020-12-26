import 'package:prasso_app/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:prasso_app/services/prasso_api_service.dart';

class MockAuthService extends Mock implements PrassoApiService {}

class MockDatabase extends Mock implements FirestoreDatabase {}

class MockWidgetsBinding extends Mock implements WidgetsBinding {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
