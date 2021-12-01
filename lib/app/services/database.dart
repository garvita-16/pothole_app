
import 'package:flutter/foundation.dart';
import 'package:pothole_detection_app/app/models/report.dart';

import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database{
  Future<void> createReport(Report report);
  Stream<List<Report>> reportStream();
  Future<void> deleteReport(Report report);
  String getUid();
}
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
class FirestoreDatabase implements Database{
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;
  @override
  Future<void> createReport(Report report) async => await _service.setData(
    path: APIpath.report(uid, report.id),
    data: report.toMap(),
  );
  @override
  Future<void> deleteReport(Report report) async{
    return _service.deleteData(
      path: APIpath.report(uid,report.id),
    );
  }
  @override
  Stream<List<Report>> reportStream(){
    return _service.collectionStream(
      path: APIpath.reports(uid),
      builder: (data, documentId) => Report.fromMap(data, documentId),
    );
  }

  @override
  String getUid()
  {
    return uid;
  }
}