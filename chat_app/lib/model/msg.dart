import 'package:cloud_firestore/cloud_firestore.dart';

class MSG {
  String? message;
  String? username;
  String? id;
  Timestamp? createdAt;
  MSG({this.message, this.username, this.id, this.createdAt});

  MSG.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        username = json['username'],
        createdAt = json['createdAt'],
        id = json['id'];
  Map<String, dynamic> toJson() => {
        'message': message,
        'username': username,
        'id': id,
        'createdAt': createdAt
      };
}
