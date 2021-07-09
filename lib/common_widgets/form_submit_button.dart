part of custom_buttons;

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton(
      {Key key,
      String text,
      @required Color color,
      bool loading = false,
      VoidCallback onPressed,
      double height = 50.0})
      : super(
            key: key,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            height: height,
            color: color,
            textColor: Colors.black87,
            loading: loading,
            onPressed: onPressed,
            borderRadius: 15);
}
