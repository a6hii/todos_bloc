import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  final String userId;
  final String name;
  final String email;
  final String? city;
  final String? pincode;
  final String? state;
  final String? profilePicUrl;
  final String? linkedInLink;

  const User({
    required this.userId,
    required this.name,
    required this.email,
    this.city,
    this.pincode,
    this.state,
    this.profilePicUrl,
    this.linkedInLink,
  });

  User.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.data()['user_id'] as String,
        name = snapshot.data()['name'] as String,
        email = snapshot.data()['email'] as String,
        city = snapshot.data()['city'] as String?,
        pincode = snapshot.data()['pincode'] as String?,
        state = snapshot.data()['state'] as String?,
        profilePicUrl = snapshot.data()['profilePicUrl'] as String?,
        linkedInLink = snapshot.data()['linkedInLink'] as String?;
}
