import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

enum Status{
  pending,
  accepted,
  completed,
  declined,
  undefined,
}

String statusToString(Status status){
  if(status==Status.pending)
    {
      return 'pending';
    }
  else if(status==Status.accepted)
  {
    return 'accepted';
  }
  else if(status==Status.declined)
  {
    return 'declined';
  }
  else if(status==Status.completed)
  {
    return 'completed';
  }
  else
  {
    return 'undefined';
  }
}

Status stringToStatus(String status){
  if(status=='pending')
  {
    return Status.pending;
  }
  else if(status=='accepted')
  {
    return Status.accepted;
  }
  else if(status=='declined')
  {
    return Status.declined;
  }
  else if(status=='completed')
  {
    return Status.completed;
  }
  else
  {
    return Status.undefined;
  }
}

class Report {
  Report({
    @required this.id,
    @required this.image,
    @required this.severity,
    @required this.location,
    @required this.status,
    this.userId,
  });
  String id;
  String image;
  double severity;
  dynamic location;
  Status status;
  String userId;
  factory Report.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String image = data['image'];
    final double severity = data['severity'];
    final dynamic location = data['location'];
    final String status =data['status'];
    final String userId =data['userId'];
    final Status st=stringToStatus(status);
    return Report(
      id: documentId,
      image: image,
      severity: severity,
      location: location,
      status: st,
      userId: userId,
    );
  }
  Map<String, dynamic> toMap(String uid) {
    return {
      'image': image,
      'location': location,
      'severity': severity,
      'status': statusToString(status),
      'userId': uid,
    };
  }

  Map<String, dynamic> withStatusToMap(String uid,Status status) {
    return {
      'image': image,
      'location': location,
      'severity': severity,
      'status': statusToString(status),
      'userId': uid,
    };
  }
}
