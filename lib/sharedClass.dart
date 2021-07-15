import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:documents_picker/documents_picker.dart';

class sharedClass extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<sharedClass> {
  Future<void> share() async {
    await FlutterShare.share(
      text: 'Example share text',
    );
  }

  Future<void> shareFile() async {
    List<dynamic> docs = await DocumentsPicker.pickDocuments;
    if (docs == null || docs.isEmpty)
      return null;

    await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: docs[0] as String,
    );
  }

  @override
  Widget build(BuildContext context) {
    share();
  }
}
