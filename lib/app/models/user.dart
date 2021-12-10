import 'package:flutter/foundation.dart';

class UserData{
  UserData({@required this.firstName,@required this.points});
  String firstName;
  int points;

  factory UserData.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      final String firstName = data['firstName'];
      final int points= data['points'];
      return UserData(
        firstName: firstName,
        points: points,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName':firstName,
      'points':points
    };
  }
}