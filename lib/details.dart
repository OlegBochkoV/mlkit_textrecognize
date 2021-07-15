import 'package:clipboard/clipboard.dart';
import 'package:documents_picker/documents_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:text_recognition/sharedClass.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_share/flutter_share.dart';

class Details extends StatefulWidget {
  final String text;

  Details(this.text);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.orange,
        actions: [
          Row(children: [
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                FlutterClipboard.copy(widget.text).then((value) => _key
                    .currentState
                    .showSnackBar(new SnackBar(content: Text('Copied'))));
              },
            ),
            IconButton(
              icon: Icon(Icons.description),
              onPressed: () async {
                await FlutterShare.share(
                    title: 'Share',
                    text: widget.text.toString(),
                    chooserTitle: 'Shared text');
              },
            )
          ])
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: SelectableText(
            widget.text.isEmpty ? 'No Text Available' : widget.text),
      ),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}
