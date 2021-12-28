import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/models/report.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:provider/provider.dart';

class ShowReportDetails extends StatefulWidget {
  //const AddJobPage({Key? key}) : super(key: key);
  const ShowReportDetails({Key key, @required this.database, this.report})
      : super(key: key);
  final Database database;
  final Report report;
  @override
  _ShowReportDetailsState createState() => _ShowReportDetailsState();
}

class _ShowReportDetailsState extends State<ShowReportDetails> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Report Details'),
        backgroundColor: Color(0xff14DAE2),
      ),
      body: _buildContent(context),
      backgroundColor: Color(0xff251F34),
    );
  }

  int _prediction() {
    if (widget.report.isPothole) {
      return (widget.report.modelAccuracy * 100).ceil();
    } else {
      return 100 - (widget.report.modelAccuracy * 100).ceil();
    }
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
                    color: Colors.white,
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
                    color: Colors.white,
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
                    color: Colors.white,
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
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Center(
                child: Text(
                  'Pothole : ${_prediction()}%',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Center(
                child: Text(
                  'Status : ${statusToString(widget.report.status)}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
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
