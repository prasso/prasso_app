// Flutter imports:
import 'package:delegate_app/utils/prasso_themedata.dart';
import 'package:flutter/material.dart';

//
// TabItem outlines the maximum tabs this app could have
// Overflow will hold any pages defined by the data
//
enum TabItem { position1, position2, position3, position4, positionOverflow }

class TabItemData {
  TabItemData(
      {required this.key,
      required this.title,
      required this.icon,
      required this.pageUrl,
      required this.pageTitle,
      required this.extraHeaderInfo,
      required this.sortOrder,
      required this.parent,
      required this.iconImageFileName,
      required this.isActive,
      required this.subscriptionRequired});

  final String key;
  final String? title;
  final IconData? icon;
  final String? pageUrl;
  final String? pageTitle;
  final String? extraHeaderInfo;
  final int? sortOrder;
  final int? parent;
  bool isActive;
  final String? iconImageFileName;
  final bool subscriptionRequired;

  Color? _color;

  Color? get color {
    isActive ? _color = PrassoColors.brightOrange : _color = Colors.grey;
    return _color;
  }
}
