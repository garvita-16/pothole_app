import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/models/report.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:provider/provider.dart';

class AdminShowReportDetails extends StatefulWidget {
  //const AddJobPage({Key? key}) : super(key: key);
  const AdminShowReportDetails({Key key, @required this.database, this.report})
      : super(key: key);
  final Database database;
  final Report report;
  @override
  _AdminShowReportDetailsState createState() => _AdminShowReportDetailsState();
}

class _AdminShowReportDetailsState extends State<AdminShowReportDetails> {
  bool _isLoading = true;
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    dropdownValue = dropdownValue==null?statusToString(widget.report.status):dropdownValue;

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Report Details'),
      ),
      body: _buildContent(context),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(50),
              child: _getImage(context, widget.report.image),
            ),
            Container(
              child: Center(
                child: Text(
                  'Severity : ${widget.report.severity}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Center(
                child: Text(
                  'Location : ${widget.report.location['address']}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Center(
                child: Text(
                  'Latitude : ${widget.report.location['latitude']}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Center(
                child: Text(
                  'Longitude : ${widget.report.location['longitude']}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Status : ',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (newValue) async {
                        setState(() {
                          dropdownValue = newValue;
                        });
                        await widget.database.updateStatus(widget.report,stringToStatus(newValue));
                      },
                      items: <String>['pending', 'accepted', 'completed', 'declined']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImage(BuildContext context, String image) {
    Image m;
    m = Image.network(image);
    return m;
  }
}
