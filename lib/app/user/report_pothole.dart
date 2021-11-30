import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportPothole extends StatefulWidget {
  @override
  State<ReportPothole> createState() => _ReportPotholeState();
}

class _ReportPotholeState extends State<ReportPothole> {
  final ImagePicker _picker = ImagePicker();

  var image;

  Future<void> pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = File(img.path);
    });
  }

  Future<void> captureImage() async {
    final img = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      image = File(img.path);
    });
  }

  Widget _chooseDisplay() {
    if (image != null)
      return Image.file(image);
    else
      return Text('Take an image',style: TextStyle(fontSize: 25),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Pothole'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(50),
              child: _chooseDisplay(),
            ),
            ElevatedButton(
              child: Text(
                'Take an image'
              ),
              onPressed: captureImage,
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              child: Text('Select an image'),
              onPressed: pickImage,
            ),
          ],
        ),
      ),
    );
  }
}
