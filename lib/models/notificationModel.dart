import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String title;
  final String description;

  NotificationModel({
    required this.title,
    required this.description,
  });

  // To convert NotificationModel to Firestore-friendly Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': FieldValue.serverTimestamp(), // Use Firestore server timestamp
    };
  }

  // Factory method to create a NotificationModel from Firestore document
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'],
      description: map['description'],
    );
  }
}
