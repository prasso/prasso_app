import 'package:delegate_app/utils/icons_helper.dart';
import 'package:delegate_app/utils/prasso_themedata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubListItem extends StatelessWidget {
  final String? title;
  final String? icon;

  const SubListItem({this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding:
                const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 0),
            child: Icon(
              icon != null
                  ? getIconUsingPrefix(name: icon!)
                  : getIconUsingPrefix(name: 'add_circle'),
              color: PrassoColors.primary,
            )),
        Padding(
            padding:
                const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 0),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge,
            ))
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('icon', icon));
  }
}
