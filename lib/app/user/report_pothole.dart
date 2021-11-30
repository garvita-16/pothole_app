
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportPothole extends StatelessWidget {
  //const ReportPothole({Key? key}) : super(key: key);

  final ImagePicker _picker = ImagePicker();

  Future<XFile> pickImage() async{
    return await  _picker.pickImage(source: ImageSource.gallery);
  }
  Future<XFile> captureImage() async{
    return await  _picker.pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Pothole'),
      ),
      body: Column(
        children: [
          RaisedButton(
            child: Text('Take an image'),
            onPressed: captureImage,
          ),
          SizedBox(height: 8.0),
          RaisedButton(
            child: Text('Select an image'),
            onPressed: pickImage,
          ),
        ],
      ),
    );
  }
}
