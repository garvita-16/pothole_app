import 'dart:io';
import 'package:pothole_detection_app/app/models/job.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:scroll_indicator/scroll_indicator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  double rating = 0.0;
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
      return Text(
        'Take an image',
        style: TextStyle(fontSize: 25),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Pothole'),
      ),
      body: Center(
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
              SizedBox(height: 20.0),

              Slider(
                activeColor: Colors.red,
                inactiveColor: Colors.black38,
                value: rating,
                min: 0.0,
                max: 5.0,
                divisions: 5,
                label: rating.toString(),
                onChanged: ( double newRating){
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
              SizedBox(height: 8.0),
              RaisedButton(
                onPressed:()=> _submit(context) ,
                child: Text('Submit', style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                ),
                color: Colors.indigo,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _submit(BuildContext context) async {
    final id = DocumentIdFromCurrentDate();
    final job = Job(
      id: id,
      image: image,
      severity: rating,
    );
    await widget.database.createJob(job);
    Navigator.of(context).pop();
  }

}
