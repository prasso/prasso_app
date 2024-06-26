// Dart imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
// Project imports:
import 'package:prasso_app/app_widgets/sign_in/sign_in_page.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/routing/router.dart' as _rtr;
import 'package:prasso_app/services/prasso_api_repository.dart';

import 'mocks.dart';

@GenerateMocks([PrassoApiRepository, NavigatorObserver])
void main() {
  group('sign-in page', () {
    late MockPrassoAuth mockPrassoAuth;
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockPrassoAuth = MockPrassoAuth();
      mockNavigatorObserver = MockNavigatorObserver();
    });

    Future<void> pumpSignInPage(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prassoApiService.overrideWithProvider(
              Provider<PrassoApiRepository?>((ref) => mockPrassoAuth),
            ),
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
      // ignore: cast_from_null_always_fails
      verify(mockNavigatorObserver.didPush(any as Route<dynamic>, any as Route<dynamic>?)).called(1);
    }

    testWidgets('email & password navigation', (tester) async {
      await pumpSignInPage(tester);

      final emailPasswordButton = find.byKey(SignInPageContents.emailPasswordButtonKey);
      expect(emailPasswordButton, findsOneWidget);

      await tester.tap(emailPasswordButton);
      await tester.pumpAndSettle();

      // ignore: cast_from_null_always_fails
      verify(mockNavigatorObserver.didPush(any as Route<dynamic>, any as Route<dynamic>?)).called(1);
    });
  });
}
