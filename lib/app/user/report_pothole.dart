import 'dart:io';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pothole_detection_app/app/custom_widgets/custom_error_dialog.dart';
import 'package:pothole_detection_app/app/home_page.dart';
import 'package:pothole_detection_app/app/models/report.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pothole_detection_app/app/input_location.dart';

class ReportPothole extends StatefulWidget {
  const ReportPothole({Key key, @required this.database}) : super(key: key);

  @override
  State<ReportPothole> createState() => _ReportPotholeState();

  final Database database;
  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReportPothole(database: database),
        fullscreenDialog: true,
      ),
    );
  }
}

class _ReportPotholeState extends State<ReportPothole> {
  final ImagePicker _picker = ImagePicker();
  double _rating = 0.0;
  String _imageUrl;
  File _image;
  bool _isLoading = false;
  Map<dynamic, dynamic> _locationData;

  Future<void> pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(img.path);
    });
  }

  Future<void> captureImage() async {
    final img = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(img.path);
    });
  }

  Widget _chooseDisplay() {
    if (_image != null)
      return Image.file(_image);
    else
      return Text(
        'Take an image',
        style: TextStyle(fontSize: 25),
      );
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(50),
                      child: _chooseDisplay(),
                    ),
                    ElevatedButton(
                      child: Text('Take an image'),
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
                                    : _locationData['address']
                                        .toString()
                                        .substring(
                                            0,
                                            _locationData['address']
                                                .toString()
                                                .indexOf(',')),
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
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                                onPressed: () {
                                  navigateAndDisplay(context);
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Slider(
                      activeColor: Colors.red,
                      inactiveColor: Colors.black38,
                      value: _rating,
                      min: 0.0,
                      max: 5.0,
                      divisions: 5,
                      label: _rating.toString(),
                      onChanged: (double newRating) {
                        setState(() {
                          _rating = newRating;
                        });
                      },
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () => _submit(context),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }


  Future<bool> _uploadReportImage() async {
    setState(() {
      _isLoading=true;
    });
    Reference storageReference = FirebaseStorage.instance.ref().child(
        'reports/${widget.database.getUid()}/${documentIdFromCurrentDate()}');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.then((TaskSnapshot snapshot) async {
      _imageUrl = await storageReference.getDownloadURL();
      print(' Photo Uploaded');
    }).catchError((Object e) {
      print(e); // FirebaseException
      return false;
    });
    return true;
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

  Future<void> _submit(BuildContext context) async {
    if (_image != null) {
      if (_locationData != null) {
        if (await _uploadReportImage()) {
          final id = documentIdFromCurrentDate();
          final report = Report(
            id: id,
            image: _imageUrl,
            severity: _rating,
            location: _locationData,
          );
          try {
            await widget.database.createReport(report);
            await widget.database.createReportForAdmin(report);
            setState(() {
              _isLoading=false;
            });
            await CustomErrorDialog.show(
                context: context,
                title: 'Upload Successful',
                message: 'Successful');
            Navigator.of(context).pop();
          } catch (e) {
            CustomErrorDialog.show(
                context: context,
                title: 'Upload Failed',
                message: e.toString());
          }
        } else {
          CustomErrorDialog.show(
              context: context,
              title: 'Location Missing',
              message: 'Please Select Location');
        }
      } else {
        CustomErrorDialog.show(
            context: context,
            title: 'Failed to upload image',
            message: 'Please try again');
      }
    } else {
      CustomErrorDialog.show(
          context: context,
          title: 'Image Missing',
          message: 'Please take/add image of the pothole');
    }
  }
}
