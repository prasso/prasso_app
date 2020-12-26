import 'package:prasso_app/app_widgets/sign_in/email_password_sign_in_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prasso_app/services/prasso_api_service.dart';
import 'package:prasso_app/models/api_user.dart';
import 'package:provider/provider.dart';

class MockAuthService extends Mock implements PrassoApiService {}

void main() {
  MockAuthService mockAuth;

  setUp(() {
    mockAuth = MockAuthService();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<PrassoApiService>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (_) => EmailPasswordSignInPage(
                onSignedIn: onSignedIn,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<ApiUser>.value(const ApiUser(uid: '123')));
  }

  void stubSignInWithEmailAndPasswordThrows() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenThrow(PlatformException(code: 'ERROR_WRONG_PASSWORD'));
  }

  void stubCreateUserWithEmailAndPasswordSucceeds() {
    when(mockAuth.createUserWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<ApiUser>.value(const ApiUser(uid: '123')));
  }

  void stubCreateUserWithEmailAndPasswordThrows() {
    when(mockAuth.createUserWithEmailAndPassword(any, any))
        .thenThrow(PlatformException(code: 'ERROR_EMAIL_ALREADY_IN_USE'));
  }

  void stubSendPasswordResetEmailSucceeds() {
    when(mockAuth.sendPasswordResetEmail(any))
        .thenAnswer((_) => Future<void>.value());
  }

  group('sign-in', () {
    testWidgets(
        'WHEN user doesn\'t enter the email and password'
        'AND user taps on the sign-in button'
        'THEN signInWithEmailAndPassword is not called', (tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final primaryButton = find.byKey(const Key('primary-button'));
      expect(primaryButton, findsOneWidget);
      await tester.tap(primaryButton);

      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
      expect(signedIn, false);
    });

    testWidgets(
        'WHEN user enters valid email and password'
        'AND user taps on the sign-in button'
        'THEN signInWithEmailAndPassword is called'
        'AND user is signed in', (tester) async {
      const email = 'email@email.com';
      const password = 'password';

      stubSignInWithEmailAndPasswordSucceeds();

      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final emailField = find.byKey(const Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(const Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // trigger frame
      await tester.pump();

      final primaryButton = find.byKey(const Key('primary-button'));
      expect(primaryButton, findsOneWidget);
      await tester.tap(primaryButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, true);
    });

    testWidgets(
        'WHEN user enters invalid email and password'
        'AND user taps on the sign-in button'
        'THEN signInWithEmailAndPassword is called'
        'AND user is not signed in', (tester) async {
      const email = 'email@email.com';
      const password = 'password';

      stubSignInWithEmailAndPasswordThrows();

      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final emailField = find.byKey(const Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(const Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // trigger frame
      await tester.pump();

      final primaryButton = find.byKey(const Key('primary-button'));
      expect(primaryButton, findsOneWidget);
      await tester.tap(primaryButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, false);
    });
  });

  group('register', () {
    testWidgets(
        'WHEN user taps on the `need account` button'
        'THEN form toggles to registration mode', (tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final secondaryButton = find.byKey(const Key('secondary-button'));
      await tester.tap(secondaryButton);

      await tester.pump();

      final signInButton =
          find.text(EmailPasswordSignInStrings.createAnAccount);
      expect(signInButton, findsOneWidget);

      verifyNever(mockAuth.createUserWithEmailAndPassword(any, any));
      expect(signedIn, false);
    });

    testWidgets(
        'WHEN user taps on the `need account` button'
        'AND user enters valid email and password'
        'AND user taps on the register button'
        'THEN createUserWithEmailAndPassword is called'
        'AND user is signed in', (tester) async {
      const email = 'email@email.com';
      const password = 'password';

      stubCreateUserWithEmailAndPasswordSucceeds();

      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      // Toggle form
      final secondaryButton = find.byKey(const Key('secondary-button'));
      await tester.tap(secondaryButton);

      final emailField = find.byKey(const Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(const Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final createAccountButton =
          find.text(EmailPasswordSignInStrings.createAnAccount);
      expect(createAccountButton, findsOneWidget);
      await tester.tap(createAccountButton);

      verify(mockAuth.createUserWithEmailAndPassword(email, password))
          .called(1);
      expect(signedIn, true);
    });

    testWidgets(
        'WHEN user taps on the `need account` button'
        'AND user enters invalid email and password'
        'AND user taps on the register button'
        'THEN createUserWithEmailAndPassword is called'
        'AND user is not signed in', (tester) async {
      const email = 'email@email.com';
      const password = 'password';

      stubCreateUserWithEmailAndPasswordThrows();

      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      // Toggle form
      final secondaryButton = find.byKey(const Key('secondary-button'));
      await tester.tap(secondaryButton);

      final emailField = find.byKey(const Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(const Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final createAccountButton =
          find.text(EmailPasswordSignInStrings.createAnAccount);
      expect(createAccountButton, findsOneWidget);
      await tester.tap(createAccountButton);

      verify(mockAuth.createUserWithEmailAndPassword(email, password))
          .called(1);
      expect(signedIn, false);
    });
  });

  group('forgot password', () {
    testWidgets(
        'WHEN user taps on the forgot password button'
        'THEN form toggles to forgot password mode', (tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final secondaryButton = find.byKey(const Key('tertiary-button'));
      await tester.tap(secondaryButton);

      await tester.pump();

      final sendResetPasswordButton =
          find.text(EmailPasswordSignInStrings.sendResetLink);
      expect(sendResetPasswordButton, findsOneWidget);

      verifyNever(mockAuth.sendPasswordResetEmail(any));
      expect(signedIn, false);
    });
  });

  testWidgets(
      'WHEN user taps on the forgot password button'
      'AND user enters an email'
      'AND user taps on the send reset password link'
      'THEN sendPasswordResetEmail is called'
      'AND user is not signed in', (tester) async {
    const email = 'email@email.com';

    stubSendPasswordResetEmailSucceeds();

    var signedIn = false;
    await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

    // Toggle form
    final secondaryButton = find.byKey(const Key('tertiary-button'));
    await tester.tap(secondaryButton);

    final emailField = find.byKey(const Key('email'));
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);

    await tester.pump();

    final sendResetLinkButton =
        find.text(EmailPasswordSignInStrings.sendResetLink);
    expect(sendResetLinkButton, findsOneWidget);
    await tester.tap(sendResetLinkButton);

    verify(mockAuth.sendPasswordResetEmail(email)).called(1);
    expect(signedIn, false);
  });

  // TODO: Error presentation tests
}
