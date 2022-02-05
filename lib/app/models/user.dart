import 'package:flutter/foundation.dart';

class UserData{
  UserData({@required this.firstName,@required this.points, @required this.isAdmin});
  String firstName;
  int points;
  bool isAdmin;

  factory UserData.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      final String firstName = data['firstName'];
      final int points= data['points'];
      final bool isAdmin = data['isAdmin'];
      return UserData(
        firstName: firstName,
        points: points,
        isAdmin: isAdmin,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName':firstName,
      'points':points,
      'isAdmin': isAdmin,
    };
  }
}