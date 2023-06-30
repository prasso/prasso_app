// Flutter imports:
// Package imports:
// Project imports:
import 'package:delegate_app/models/api_user.dart';
import 'package:delegate_app/services/firestore_database.dart';
import 'package:delegate_app/services/prasso_api_repository.dart';
import 'package:delegate_app/services/shared_preferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthService extends Mock implements PrassoApiRepository {}

class MockDatabase extends Mock implements FirestoreDatabase {}

class MockWidgetsBinding extends Mock implements WidgetsBinding {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockPrassoAuth extends Mock implements PrassoApiRepository {}

// ignore: must_be_immutable
class MockUser extends Mock implements ApiUser {}

class MockUserCredential extends Mock implements UserCredential {}

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

class MockSharedPreferences extends Mock implements SharedPreferences {}
