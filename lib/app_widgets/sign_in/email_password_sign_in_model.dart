part of email_password_sign_in_ui;

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

class EmailAndPasswordValidators {
  final TextInputFormatter emailInputFormatter =
      ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator());
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
}

final emailPasswordSigninViewModelProvider =
    ChangeNotifierProvider<EmailPasswordSignInModel>(
        (ref) => EmailPasswordSignInModel(auth: ref.watch(prassoApiService)));

class EmailPasswordSignInModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailPasswordSignInModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
  });
  final PrassoApiRepository? auth;

  String email;
  String password;
  bool isLoading;
  bool submitted;

  EmailPasswordSignInFormType _formType = EmailPasswordSignInFormType.signIn;

  EmailPasswordSignInFormType get formType => _formType;

  set formType(EmailPasswordSignInFormType value) {
    _formType = value;
    notifyListeners();
  }

  Future<bool> submit(BuildContext context) async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      switch (formType) {
        case EmailPasswordSignInFormType.signIn:
          await auth!.signInWithEmailAndPassword(email, password);
          break;
        case EmailPasswordSignInFormType.register:
          await auth!.createUserWithEmailAndPassword(email, password);
          // Navigate to the intro pages after the user is registered.
          await Navigator.pushReplacement<IntroPage, bool>(
            context,
            MaterialPageRoute<IntroPage>(
              builder: (dynamic _) => IntroPage(),
              settings: const RouteSettings(),
              fullscreenDialog: true,
            ),
          );
          break;
        case EmailPasswordSignInFormType.forgotPassword:
          await auth!.sendPasswordResetEmail(email);
          break;
      }

      updateWith(isLoading: false);
      return true;
    } catch (e) {
      developer.log(
        'email password log data',
        name: 'prasso.app.email_password_sign_in',
        error: e.toString(),
      );
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateFormType(EmailPasswordSignInFormType? formType) {
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String? email,
    String? password,
    EmailPasswordSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return EmailPasswordSignInStrings.password8CharactersLabel;
    }
    return EmailPasswordSignInStrings.passwordLabel;
  }

  // Getters
  String? get primaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register:
          EmailPasswordSignInStrings.createAnAccount,
      EmailPasswordSignInFormType.signIn:
          EmailPasswordSignInStrings.signInTitle,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInStrings.sendResetLink,
    }[formType];
  }

  String? get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register:
          EmailPasswordSignInStrings.haveAnAccount,
      EmailPasswordSignInFormType.signIn:
          EmailPasswordSignInStrings.needAnAccount,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInStrings.backToSignIn,
    }[formType];
  }

  EmailPasswordSignInFormType? get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInFormType.signIn,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInFormType.register,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInFormType.signIn,
    }[formType];
  }

  String? get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register:
          EmailPasswordSignInStrings.registrationFailed,
      EmailPasswordSignInFormType.signIn:
          EmailPasswordSignInStrings.signInFailed,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInStrings.passwordResetFailed,
    }[formType];
  }

  String? get title {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInStrings.register,
      EmailPasswordSignInFormType.signIn:
          EmailPasswordSignInStrings.signInTitle,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInStrings.forgotPassword,
    }[formType];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmit {
    final bool canSubmitFields =
        formType == EmailPasswordSignInFormType.forgotPassword
            ? canSubmitEmail
            : canSubmitEmail && canSubmitPassword;
    return canSubmitFields && !isLoading;
  }

  String? get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText = email.isEmpty
        ? EmailPasswordSignInStrings.invalidEmailEmpty
        : EmailPasswordSignInStrings.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String? get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty
        ? EmailPasswordSignInStrings.invalidPasswordEmpty
        : EmailPasswordSignInStrings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}
