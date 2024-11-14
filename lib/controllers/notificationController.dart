import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notificationModel.dart';

class FirestoreController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Method to upload the notification to Firestore
  Future<void> uploadNotification(NotificationModel notification) async {
    try {
      await _firebaseFirestore
          .collection('notifications')
          .add(notification.toMap());
      print('Notification uploaded successfully');
    } catch (e) {
      print('Error uploading notification: $e');
    }
  }
}
