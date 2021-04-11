// Flutter imports:
import 'package:flutter/material.dart';

//
// TabItem outlines the maximum tabs this app could have
// Overflow will hold any pages defined by the data
//
enum TabItem { position1, position2, position3, position4, positionOverflow }

class TabItemData {
  TabItemData(
      {@required this.key,
      @required this.title,
      @required this.icon,
      @required this.pageUrl,
      @required this.pageTitle,
      this.extraHeaderInfo,
      this.sortOrder,
      this.parent});

  final String key;
  final String title;
  final IconData icon;
  final String pageUrl;
  final String pageTitle;
  final String extraHeaderInfo;
  final int sortOrder;
  final int parent;
}
