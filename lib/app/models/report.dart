import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class Report {
  Report({
    @required this.id,
    @required this.image,
    @required this.severity,
    @required this.location,
  });
  String id;
  String image;
  double severity;
  dynamic location;

  factory Report.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final dynamic image = data['image'];
    final double severity = data['severity'];
    final dynamic location = data['location'];
    return Report(
      id: documentId,
      image: image,
      severity: severity,
      location: location,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'location': location,
      'severity': severity,
    };
  }
}
