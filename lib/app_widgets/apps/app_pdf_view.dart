// Dart imports:

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

// Package imports:
class AppRunPdfView extends StatelessWidget {
  final String? title;
  final String urlPDFPath;

  const AppRunPdfView({
    required this.title,
    required this.urlPDFPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title!, style: TextStyle(color: Theme.of(context).colorScheme.background)),
      ),
      body: const PDF().cachedFromUrl(
        urlPDFPath,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('urlPDFPath', urlPDFPath));
  }
}
