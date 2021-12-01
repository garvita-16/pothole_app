 import 'package:flutter/cupertino.dart';
 import 'package:meta/meta.dart';
class Job{
   Job({@required this.id, @required this.image, @required this.severity,}); //this.location});
   final String id;
  final dynamic image;
  final double severity;
  // final dynamic location;

  factory Job.fromMap(Map<String,dynamic>data, String DocumentId){
    if(data == null){
      return null;
    }
    final dynamic image = data['image'];
    final double severity = data['severity'];
    // final dynamic location = data['location'];
    return Job(
      id: DocumentId,
      image: image,
      severity: severity,
      // location: location,
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'image' : image,
      // 'location': location,
      'severity':severity,
    };
  }
 }