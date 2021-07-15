import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

import 'details.dart';

main() async {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _text = '';
  PickedFile _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Text Recognition'),
          actions: [
            FlatButton(
              onPressed: scanText,
              child: Text(
                'Scan',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black54,
          backgroundColor: Colors.orange,
          animatedIconTheme: IconThemeData.fallback(),
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
                child: Icon(Icons.add_a_photo),
                label: "Camera",
                onTap: getImageCamera),
            SpeedDialChild(
                child: Icon(Icons.photo_library),
                label: "Galery",
                onTap: getImageGalery)
          ],
        ),
        // floatingActionButton: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     FloatingActionButton(
        //         onPressed: getImageCamera, child: Icon(Icons.camera_alt)),
        //     SizedBox(height: 20),
        //     FloatingActionButton(
        //         onPressed: getImageGalery, child: Icon(Icons.photo)),
        //   ],
        //   //onPressed: getImageCamera,
        //   //child: Icon(Icons.add_a_photo),
        // ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: _image != null
              ? Image.file(
                  File(_image.path),
                  fit: BoxFit.fitWidth,
                )
              : Container(),
        ));
  }

  Future scanText() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Center(
                child: CircularProgressIndicator(),
              )
          );
        });
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(_image.path));
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        _text += line.text + '\n';
      }
    }

    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Details(_text)));
  }

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('No image selected');
      }
    });
  }

  Future getImageGalery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('No image selected');
      }
    });
  }
}
