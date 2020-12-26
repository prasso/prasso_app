import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prasso_app/app_widgets/sign_in/sign_in_page.dart';
import 'package:prasso_app/services/prasso_api_service.dart';
import 'package:provider/provider.dart';
import 'package:prasso_app/routing/router.dart' as _rtr;
import 'package:prasso_app/models/api_user.dart';

import 'mocks.dart';

void main() {
  group('sign-in page', () {
    MockNavigatorObserver mockNavigatorObserver;
    StreamController<ApiUser> onAuthStateChangedController;

    PrassoApiService Function(BuildContext context) apiBuilder;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
      onAuthStateChangedController = StreamController<ApiUser>();
      apiBuilder = (_) => PrassoApiService();
    });

    tearDown(() {
      onAuthStateChangedController.close();
    });

    Future<void> pumpSignInPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<PrassoApiService>(
              create: apiBuilder,
            ),
          ],
          child: MaterialApp(
            home: SignInPageBuilder(),
            onGenerateRoute: _rtr.Router.onGenerateRoute,
            navigatorObservers: [mockNavigatorObserver],
          ),
        ),
      );
      // didPush is called once when the widget is first built
      verify(mockNavigatorObserver.didPush(any, any)).called(1);
    }

    testWidgets('email & password navigation', (tester) async {
      await pumpSignInPage(tester);

      final emailPasswordButton = find.byKey(SignInPage.emailPasswordButtonKey);
      expect(emailPasswordButton, findsOneWidget);

      await tester.tap(emailPasswordButton);
      await tester.pumpAndSettle();

      verify(mockNavigatorObserver.didPush(any, any)).called(1);
    });
  });
}
