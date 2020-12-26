import 'dart:math';
import 'package:prasso_app/app_widgets/sign_in/sign_in_button.dart';
import 'package:prasso_app/app_widgets/sign_in/sign_in_view_model.dart';
import 'package:prasso_app/constants/keys.dart';
import 'package:prasso_app/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prasso_app/services/prasso_api_service.dart';
import 'package:prasso_app/routing/router.dart';
import 'package:provider/provider.dart';

class SignInPageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PrassoApiService auth =
        Provider.of<PrassoApiService>(context, listen: false);
    return ChangeNotifierProvider<SignInViewModel>(
      create: (_) => SignInViewModel(auth: auth),
      child: Consumer<SignInViewModel>(
        builder: (_, viewModel, __) => SignInPage._(
          viewModel: viewModel,
          title: 'Prasso',
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage._({Key key, this.viewModel, this.title}) : super(key: key);
  final SignInViewModel viewModel;
  final String title;

  static const Key emailPasswordButtonKey = Key(Keys.emailPassword);

  Future<void> _showEmailPasswordSignInPage(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed(
      Routes.emailPasswordSignInPage,
      arguments: () => Navigator.of(context).pop,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(title),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildSignIn(context),
    );
  }

  Widget _buildHeader() {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      Strings.signIn,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: min(constraints.maxWidth, 600),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 32.0),
              SizedBox(
                height: 50.0,
                child: _buildHeader(),
              ),
              const SizedBox(height: 32.0),
              SignInButton(
                key: emailPasswordButtonKey,
                text: Strings.signInWithEmailPassword,
                onPressed: viewModel.isLoading
                    ? null
                    : () => _showEmailPasswordSignInPage(context),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        );
      }),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<SignInViewModel>('viewModel', viewModel));
    properties.add(StringProperty('title', title));
  }
}
