
import 'package:flutter/foundation.dart';
import 'package:pothole_detection_app/app/models/job.dart';

import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database{
  Future<void> createJob(Job job);
  Stream<List<Job>> jobStream();
  Future<void> deleteJob(Job job);
}
String DocumentIdFromCurrentDate() => DateTime.now().toIso8601String();
class FirestoreDatabase implements Database{
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;
  @override
  Future<void> createJob(Job job) async => await _service.setData(
    path: APIpath.job(uid, job.id),
    data: job.toMap(),
  );
  @override
  Future<void> deleteJob(Job job) async{
    return _service.deleteData(
      path: APIpath.job(uid,job.id),
    );
  }
  @override
  Stream<List<Job>> jobStream(){
    return _service.collectionStream(
      path: APIpath.jobs(uid),
      builder: (data, documentId) => Job.fromMap(data, documentId),
    );
  }
}