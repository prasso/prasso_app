// Project imports:
import 'package:prasso_app/models/tab_item.dart';

class AppModel {
  AppModel(this.documentId, this.pageTitle, this.pageUrl, this.tabIcon,
      this.tabLabel, this.extraHeaderInfo, this.sortOrder);

  String? documentId;
  String? pageTitle;
  String? pageUrl;
  String? tabIcon;
  String? tabLabel;
  String? extraHeaderInfo;
  int? sortOrder;
  factory AppModel.empty() {
    return AppModel('', '', '', '', '', '', 0);
  }
  factory AppModel.fromTabItemData(TabItemData value) {
    return AppModel(
        value.key,
        value.title,
        value.pageUrl,
        value.icon.toString(),
        value.pageTitle,
        value.extraHeaderInfo,
        value.sortOrder);
  }

  factory AppModel.fromMap(Map<String, dynamic> data, String documentId) {


    return AppModel(
        documentId,
        data['page_title'].toString(),
        data['page_url'].toString(),
        data['icon'].toString(),
        data['label'].toString(),
        data['extra_header_info'],
        int.parse(data['sort_order'].toString()));
  }

  Map<String, dynamic> toMap() {
    return {
      'page_title': pageTitle,
      'page_url': pageUrl,
      'icon': tabIcon,
      'label': tabLabel,
      'extra_header_info': extraHeaderInfo,
      'sort_order': sortOrder
    };
  }

  @override
  String toString() =>
      'id: $documentId, title: $pageTitle, url: $pageUrl, icon: $tabIcon, label: $tabLabel, extra_header_info: $extraHeaderInfo, sort_order: $sortOrder';
}
