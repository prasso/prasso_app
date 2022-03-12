// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    required this.header,
    required this.value,
    required this.children,
    this.onValueChanged,
  });
  final Widget header;
  final T value;
  final Map<T, Widget> children;
  final ValueChanged<T>? onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: header,
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoSegmentedControl<Object>(
            children: children,
            groupValue: value,
            onValueChanged: onValueChanged!,
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('value', value));
    properties.add(DiagnosticsProperty<Map<T, Widget>>('children', children));
    properties.add(ObjectFlagProperty<ValueChanged<T>>.has(
        'onValueChanged', onValueChanged));
  }
}
