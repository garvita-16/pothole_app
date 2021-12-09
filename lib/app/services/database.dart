
import 'package:flutter/foundation.dart';
import 'package:pothole_detection_app/app/models/report.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database{
  Future<void> createReport(Report report);
  Stream<List<Report>> reportStream();
  Future<void> deleteReport(Report report);
  String getUid();
  Stream<List<Report>> reportAllStream();
  Future<void> updateStatus(Report report,Status status);
}
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
class FirestoreDatabase implements Database{
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;
  @override
  Future<void> createReport(Report report) async {
    await _service.setData(
      path: APIpath.report(uid, report.id),
      data: report.toMap(uid),
    );
    await _service.setData(
      path: APIpath.adminReport(report.id),
      data: report.toMap(uid),
    );
  }
  @override
  Future<void> deleteReport(Report report) async{
    await _service.deleteData(
      path: APIpath.report(uid,report.id),
    );
    return await _service.deleteData(
      path: APIpath.adminReport(report.id),
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
  Stream<List<Report>> reportAllStream(){
    return _service.collectionStream(
      path: APIpath.adminReports(),
      builder: (data, documentId) => Report.fromMap(data, documentId),
    );
  }

  @override
  Future<void> updateStatus(Report report,Status status) async {
    await _service.updateData(
      path: APIpath.report(report.userId, report.id),
      data: report.withStatusToMap(report.userId,status),
    );
    await _service.updateData(
      path: APIpath.adminReport(report.id),
      data: report.withStatusToMap(report.userId,status),
    );
  }

  @override
  String getUid()
  {
    return uid;
  }
}