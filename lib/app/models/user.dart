import 'package:flutter/foundation.dart';

class UserData{
  UserData({@required this.firstName,@required this.lastName,@required this.address,@required this.mobileNumber,@required this.email,@required this.pincode});
  String firstName;
  String lastName;
  String address;
  String mobileNumber;
  String email;
  String pincode;

  factory UserData.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      final String firstName = data['firstName'];
      final String lastName= data['lastName'];
      final String address= data['address'];
      final String mobileNumber = data['mobileNumber'];
      final String email = data['email'];
      final String pincode = data['pincode'];
      return UserData(
        firstName: firstName,
        lastName: lastName,
        address: address,
        mobileNumber: mobileNumber,
        email: email,
        pincode: pincode,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName':firstName,
      'lastName':lastName,
      'address':address,
      'mobileNumber':mobileNumber,
      'email':email,
      'pincode':pincode,
    };
  }
}