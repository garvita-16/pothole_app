import 'dart:io';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pothole_detection_app/app/custom_widgets/custom_error_dialog.dart';
import 'package:pothole_detection_app/app/home_page.dart';
import 'package:pothole_detection_app/app/models/report.dart';
import 'package:pothole_detection_app/app/models/user.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pothole_detection_app/app/input_location.dart';
import 'package:tflite/tflite.dart';

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
  List<dynamic> _outputs;
  bool _isLoading = false;
  Map<dynamic, dynamic> _locationData;
  final TextEditingController _nameController=TextEditingController();

  loadModel() async {
    await Tflite.loadModel(
      model: 'model/model_unquant.tflite',
      labels: 'model/labels.txt',
    );
  }

  classifyImage(image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
//Declare List _outputs in the class which will be used to show the classified classs name and confidence
      _outputs = output;
    });
  }

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
        style: TextStyle(fontSize: 25, color: Colors.white),
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
        backgroundColor: Color(0xff14DAE2),
        elevation: 2.0,
      ),
      backgroundColor: Color(0xff251F34),
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
                      child: Text('Take an image', style: TextStyle(color: Colors.white),),
                      onPressed: captureImage,
                      style: ElevatedButton.styleFrom(primary:Color(0xfff3B324E),
                        shadowColor: Color(0xff14DAE2),),
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      child: Text('Select an image', style: TextStyle(color: Colors.white)),
                      onPressed: pickImage,
                      style: ElevatedButton.styleFrom(primary:Color(0xfff3B324E),
                        shadowColor: Color(0xff14DAE2),),
                    ),
                    SizedBox(height: 28.0),
                    Container(
                      color: Color(0xfff3B324E),
                      height: pH(60),
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ]),
                          ElevatedButton(
                              child: Text(
                                "Change",
                                style: TextStyle(fontSize: 15),
                              ),
                              style: ElevatedButton.styleFrom(primary: Color(0xff14DAE2),
                                shadowColor: Color(0xff14DAE2),),
                              onPressed: () {
                                navigateAndDisplay(context);
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    const Text(
                      'Please Select Severity',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10.0),
                    Slider(
                      activeColor: Color(0xff14DAE2),
                      inactiveColor: Colors.white,
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
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(primary: Color(0xff14DAE2),
                        shadowColor: Color(0xff14DAE2),),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<bool> _uploadReportImage() async {
    setState(() {
      _isLoading = true;
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

  Future<void> _checkModel() async {
    await loadModel();
    await classifyImage(_image);
    print(_outputs);
    //CustomErrorDialog.show(context: context,title: _outputs[0]['label'].substring(2),message: 'confidence- '+_outputs[0]['confidence'].toString());
}

  Future<void> _submit(BuildContext context) async {
    if (_image != null) {
      if (_locationData != null) {
        UserData _user=await widget.database.getUser();
        if (_user!=null && _user.firstName!=null) {
          final id = documentIdFromCurrentDate();
          await _checkModel();
          if(await _uploadReportImage())
            {
              bool isPothole=_outputs[0]['label'].substring(2) == 'pothole';
              final report = Report(
                id: id,
                image: _imageUrl,
                severity: _rating,
                location: _locationData,
                status: Status.pending,
                isPothole: isPothole,
                modelAccuracy: _outputs[0]['confidence'],
              );
              try {
                await widget.database.createReport(report);
                print("report submitted");
                UserData _updatedUser=UserData(
                  firstName: _user.firstName,
                  points: _user.points,
                  isAdmin: false,
                );
                await widget.database.setUser(_updatedUser);
                setState(() {
                  _isLoading = false;
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
            }
          else
            {
              CustomErrorDialog.show(
                  context: context,
                  title: 'Upload Failed',
                  message: 'please upload image');
            }
        } else {
          showPlatformDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Enter your name', style: TextStyle(
                color: Colors.white,
              ),),
              backgroundColor: Color(0xff251F34),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )
                    ),
                  )
                ],
              ),
              actions: [
                FlatButton(
                  onPressed: () async {
                    try {
                      UserData newUser=UserData(
                        firstName: _nameController.text,
                        points: 0,
                        isAdmin: false,
                      );
                      await widget.database.setUser(newUser);
                      Navigator.of(context).pop();

                    }
                    catch(e)
                    {
                      print(e.toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('ok',
                      style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  color: Color(0xff14DAE2),
                )
              ],
            ),
          );
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
          title: 'Image Missing',
          message: 'Please take/add image of the pothole');
    }
  }
}
