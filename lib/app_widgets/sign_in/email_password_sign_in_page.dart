part of email_password_sign_in_ui;

class EmailPasswordSignInPage extends HookConsumerWidget {
  const EmailPasswordSignInPage({Key? key, this.onSignedIn, this.formType}) : super(key: key);
  final VoidCallback? onSignedIn;
  final EmailPasswordSignInFormType? formType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EmailPasswordSignInModel _thismodel = ref.watch(emailPasswordSigninViewModelProvider);

    return EmailPasswordSignInPageContents(model: _thismodel, onSignedIn: onSignedIn);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onSignedIn', onSignedIn));
    properties.add(EnumProperty<EmailPasswordSignInFormType>('formType', formType));
  }
}

class EmailPasswordSignInPageContents extends StatefulWidget {
  const EmailPasswordSignInPageContents({Key? key, required this.model, this.onSignedIn})
      : super(key: key);
  final EmailPasswordSignInModel model;
  final VoidCallback? onSignedIn;

  @override
  _EmailPasswordSignInPageContentsState createState() => _EmailPasswordSignInPageContentsState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EmailPasswordSignInModel>('model', model));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onSignedIn', onSignedIn));
  }
}

class _EmailPasswordSignInPageContentsState extends State<EmailPasswordSignInPageContents> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  void _passwordToggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  EmailPasswordSignInModel get model => widget.model;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(EmailPasswordSignInModel model, dynamic exception) {
    if (mounted) {
      showExceptionAlertDialog(
        context: context,
        title: model.errorAlertTitle,
        exception: exception,
      );
    }
  }

  Future<void> navigateIntroPages() async {
    final navigator = Navigator.of(context);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Navigator.canPop(context)) {
        // There is a previous route on the navigation stack
        // You can use `Navigator.pop(context)` if needed
      } else {
        // No previous route on the navigation stack
        Navigator.pushReplacementNamed(
          context,
          Routes.introPages,
          arguments: () => navigator.pop(),
        );
      }
    });
  }

  Future<void> navigateToHome() async {
    final navigator = Navigator.of(context);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // fetch data
      navigator.pushNamed(
        Routes.homePage,
        arguments: () => navigator.pop(),
      );
    });
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await showAlertDialog(
            context: context,
            title: EmailPasswordSignInStrings.resetLinkSentTitle,
            content: EmailPasswordSignInStrings.resetLinkSentMessage,
            defaultActionText: EmailPasswordSignInStrings.ok,
          );
        } else {
          if (model.formType == EmailPasswordSignInFormType.register) {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            final SharedPreferencesService sharedPreferencesServiceProvider =
                SharedPreferencesService(prefs);
            final savedUser = sharedPreferencesServiceProvider.getUserData();
            if (savedUser == null || savedUser.isEmpty) {
              print('User is null');
              return;
            }
            await navigateIntroPages();
          }
          if (widget.onSignedIn != null && mounted) {
            widget.onSignedIn!();
            await navigateToHome();
          }
        }
      }
    } catch (e) {
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitEmail) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType(EmailPasswordSignInFormType? formType) {
    model.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
  }

  Widget _buildEmailField() {
    return TextField(
      key: const Key('email'),
      controller: _emailController,
      decoration: InputDecoration(
        labelText: EmailPasswordSignInStrings.emailLabel,
        hintText: EmailPasswordSignInStrings.emailHint,
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onChanged: model.updateEmail,
      onEditingComplete: _emailEditingComplete,
      inputFormatters: <TextInputFormatter>[
        model.emailInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      key: const Key('password'),
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: model.passwordLabelText,
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
        suffixIcon: InkWell(
          onTap: _passwordToggle,
          child: Icon(
            _obscureText ? Icons.remove_red_eye_outlined : Icons.remove_red_eye_sharp,
            size: 15.0,
            color: Colors.black,
          ),
        ),
      ),
      obscureText: _obscureText,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePassword,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget _buildContent() {
    return FocusScope(
      node: _node,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 10.0),
          _buildEmailField(),
          if (model.formType != EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
            const SizedBox(height: 10.0),
            _buildPasswordField(),
          ],
          const SizedBox(height: 10.0),
          FormSubmitButton(
            key: const Key('primary-button'),
            color: Theme.of(context).secondaryHeaderColor,
            text: model.primaryButtonText!,
            loading: model.isLoading,
            onPressed: model.isLoading ? null : _submit,
          ),
          const SizedBox(height: 10.0),
          TextButton(
            key: const Key('secondary-button'),
            child: Text(model.secondaryButtonText!),
            onPressed:
                model.isLoading ? null : () => _updateFormType(model.secondaryActionFormType),
          ),
          if (model.formType == EmailPasswordSignInFormType.signIn)
            TextButton(
              key: const Key('tertiary-button'),
              child: const Text(EmailPasswordSignInStrings.forgotPasswordQuestion),
              onPressed: model.isLoading
                  ? null
                  : () => _updateFormType(EmailPasswordSignInFormType.forgotPassword),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 2.0,
          centerTitle: true,
          title: Text(
            model.title!,
            style: TextStyle(color: Theme.of(context).colorScheme.background),
          )),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: min(constraints.maxWidth, 600),
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildContent(),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EmailPasswordSignInModel>('model', model));
  }
}
