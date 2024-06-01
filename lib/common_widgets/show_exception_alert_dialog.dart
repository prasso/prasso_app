part of alert_dialogs;

Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String? title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: _message(exception),
      defaultActionText: 'OK',
    );

String? _message(dynamic exception) {
  try {
  if (exception is FirebaseException) {
    return exception.message;
  }
  if (exception is PlatformException) {
    return exception.message;
  }
  print(exception.toString());

  return exception.message.toString();

} catch (e) {
  if (e is NoSuchMethodError) {
    print('NoSuchMethodError: ${e.toString()}');
    return e.toString();
  } else if (e is TypeError) {
    print('TypeError: ${e.toString()}');
  } else if (e is Exception) {
    // General exception handling
    // Check if it has a message property
    try {
      // This checks if the exception has a message property
      var message = (e as dynamic).message;
      print('Exception: $message');
    } catch (_) {
      print('Exception: ${e.toString()}');
    }
  } else {
    // Catch any other type of error
    print('Error: ${e.toString()}');
  }
}
}

// TODO: Revisit this
// NOTE: The full list of FirebaseAuth errors is stored here:
// https://github.com/firebase/firebase-ios-sdk/blob/2e77efd786e4895d50c3788371ec15980c729053/Firebase/Auth/Source/FIRAuthErrorUtils.m
// These are just the most relevant for email & password sign in:
// Map<String, String> _errors = {
//   'ERROR_WEAK_PASSWORD': 'The password must be 8 characters long or more.',
//   'ERROR_INVALID_CREDENTIAL': 'The email address is badly formatted.',
//   'ERROR_EMAIL_ALREADY_IN_USE':
//       'The email address is already registered. Sign in instead?',
//   'ERROR_INVALID_EMAIL': 'The email address is badly formatted.',
//   'ERROR_WRONG_PASSWORD': 'The password is incorrect. Please try again.',
//   'ERROR_USER_NOT_FOUND':
//       'The email address is not registered. Need an account?',
//   'ERROR_TOO_MANY_REQUESTS':
//       'We have blocked all requests from this device due to unusual activity. Try again later.',
//   'ERROR_OPERATION_NOT_ALLOWED':
//       'This sign in method is not allowed. Please contact support.',
// };
