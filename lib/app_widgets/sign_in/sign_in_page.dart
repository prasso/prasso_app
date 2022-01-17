// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:prasso_app/app_widgets/sign_in/sign_in_view_model.dart';
import 'package:prasso_app/app_widgets/top_level_providers.dart';
import 'package:prasso_app/common_widgets/alert_dialogs.dart';
import 'package:prasso_app/common_widgets/custom_buttons.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:prasso_app/routing/router.dart';
import 'package:prasso_app/utils/prasso_themedata.dart';

import 'email_password_sign_in_ui.dart';

final signInModelProvider = ChangeNotifierProvider<SignInViewModel>(
  (ref) => SignInViewModel(auth: ref.watch(prassoApiService)),
);

class SignInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final signInModel = watch(signInModelProvider);
    return ProviderListener<SignInViewModel>(
      provider: signInModelProvider,
      onChange: (context, model) async {
        if (model.error != null) {
          await showExceptionAlertDialog(
            context: context,
            title: EmailPasswordSignInStrings.signInFailed,
            exception: model.error,
          );
        }
      },
      child: SignInPageContents(
        viewModel: signInModel,
        title: Strings.appName,
      ),
    );
  }
}

class SignInPageContents extends StatelessWidget {
  const SignInPageContents(
      {Key key, this.viewModel, this.title = Strings.appName})
      : super(key: key);
  final SignInViewModel viewModel;
  final String title;

  static const Key emailPasswordButtonKey = Key(Keys.emailPassword);
  static const Key emailSignupButtonKey = Key(Keys.emailSignup);

  Future<void> _showEmailPasswordSignInPage(BuildContext context) async {
    final EmailPasswordSignInModel _thismodel =
        context.read(emailPasswordSigninViewModelProvider);
    _thismodel.formType = EmailPasswordSignInFormType.signIn;
    final navigator = Navigator.of(context);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // fetch data
      navigator.pushNamed(
        Routes.emailPasswordSignInPage,
        arguments: () => navigator.pop(),
      );
    });
  }

  Future<void> _showEmailPasswordRegisterPage(BuildContext context) async {
    final EmailPasswordSignInModel _thismodel =
        context.read(emailPasswordSigninViewModelProvider);
    _thismodel.formType = EmailPasswordSignInFormType.register;
    final navigator = Navigator.of(context);
    await navigator.pushNamed(
      Routes.emailPasswordRegisterPage,
      arguments: () => navigator.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(color: PrassoColors.lightGray),
        ),
      ),
      backgroundColor: PrassoColors.lightGray,
      body: _buildSignIn(context),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    const fontSize = 20.0;
    return LayoutBuilder(builder: (context, constraints) {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: min(constraints.maxWidth, 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16.0),
                Text(
                  EmailPasswordSignInStrings.noPlan,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: fontSize),
                ),
                Expanded(
                    child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: SvgPicture.asset('media/Phonemaintenance-rafiki.svg'),
                )),
                const Text(
                  EmailPasswordSignInStrings.yourStatus,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomRaisedButton(
                    color: PrassoColors.olive,
                    onPressed: viewModel.isLoading
                        ? null
                        : () => _showEmailPasswordSignInPage(context),
                    child: SizedBox(
                        child: Text(
                      EmailPasswordSignInStrings.createAPlan,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(height: 50.0),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              key: emailSignupButtonKey,
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () =>
                                      _showEmailPasswordRegisterPage(context),
                              child: const Text(
                                EmailPasswordSignInStrings
                                    .signUpWithEmailPassword,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            Text(
                              '-or-',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: Colors.white),
                            ),
                            TextButton(
                              key: emailPasswordButtonKey,
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () => _showEmailPasswordSignInPage(context),
                              child: const Text(
                                EmailPasswordSignInStrings
                                    .signInWithEmailPassword,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ]),
                    )),
                const SizedBox(height: 16.0),
              ],
            ),
          ));
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<SignInViewModel>('viewModel', viewModel));
    properties.add(StringProperty('title', title));
  }
}
