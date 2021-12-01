import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pothole_detection_app/app/input_location.dart';

class ReportPothole extends StatefulWidget {
  @override
  State<ReportPothole> createState() => _ReportPotholeState();
}

class _ReportPotholeState extends State<ReportPothole> {
  final ImagePicker _picker = ImagePicker();

  var image;
  Map<dynamic, dynamic> _locationData;

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

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
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
            Container(
              color: Colors.grey[200],
              height: pH(30),
              padding: EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    Text(
                        _locationData == null
                            ? "Add address"
                            : _locationData['address'].toString().substring(0,
                            _locationData['address'].toString().indexOf(',')),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ]),
                  Container(
                    margin: EdgeInsets.all(4),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: Border.all(color: Colors.blue),
                    ),
                    child: RaisedButton(
                        color: Colors.white,
                        child: Text(
                          "Change",
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                        onPressed: () {
                          navigateAndDisplay(context);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  navigateAndDisplay(BuildContext context) async {
    final Map<String, dynamic> locationData =
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => InputLocation(),
    ));
    print(locationData);
    if (locationData != null) {
      setState(() {
        _locationData = locationData;
      });
    }
  }
}
