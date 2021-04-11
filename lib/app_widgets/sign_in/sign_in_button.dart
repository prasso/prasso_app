// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:prasso_app/common_widgets/custom_buttons.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    Key key,
    @required String text,
    @required Color color,
    @required VoidCallback onPressed,
    Color textColor = Colors.black87,
    double height = 70.0,
  }) : super(
            key: key,
            child: Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 20.0)),
            color: color,
            textColor: textColor,
            height: height,
            onPressed: onPressed,
            borderRadius: 15);
}
