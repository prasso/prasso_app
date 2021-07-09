// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:prasso_app/app_widgets/sign_in/sign_in_page.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/routing/router.dart' as _rtr;
import 'mocks.dart';

void main() {
  group('sign-in page', () {
    MockPrassoAuth mockPrassoAuth;
    MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockPrassoAuth = MockPrassoAuth();
      mockNavigatorObserver = MockNavigatorObserver();
    });

    Future<void> pumpSignInPage(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prassoApiService
                .overrideWithProvider(Provider((ref) => mockPrassoAuth)),
          ],
          child: Consumer(builder: (context, watch, __) {
            return MaterialApp(
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.blue,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                ),
              ),
              home: SignInPage(),
              onGenerateRoute: _rtr.Router.onGenerateRoute,
              navigatorObservers: [mockNavigatorObserver],
            );
          }),
        ),
      );
      // didPush is called once when the widget is first built
      verify(mockNavigatorObserver.didPush(any, any)).called(1);
    }

    testWidgets('email & password navigation', (tester) async {
      await pumpSignInPage(tester);

      final emailPasswordButton =
          find.byKey(SignInPageContents.emailPasswordButtonKey);
      expect(emailPasswordButton, findsOneWidget);

      await tester.tap(emailPasswordButton);
      await tester.pumpAndSettle();

      verify(mockNavigatorObserver.didPush(any, any)).called(1);
    });
  });
}
