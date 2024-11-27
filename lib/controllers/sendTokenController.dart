import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart'; // Add this package


Future<void> handlePaymentSuccess(String pollId, List<Map<String, Object>> voterList) async {
  try {
    // Step 1: Update Firestore to set `isPayment` to 1
    await FirebaseFirestore.instance.collection('polls').doc(pollId).update({
      'isPayment': 1,
    });
    print("Payment status updated successfully for pollId: $pollId");

    // Step 2: Send emails to voters
    String title = await getPollData(pollId);
    final data = await _fetchUserData();
    String name = data?['name'];

    for (var voterMap in voterList) {
      await sendEmailToVoter(voterMap, title, name);
    }
    print("Emails sent to all voters.");
  } catch (e) {
    print("Error in handlePaymentSuccess: $e");
  }
}

Future<void> sendEmailToVoter(Map<String, Object> voterMap, String title, String name) async {
  String token = voterMap['uniqueId'] as String;
  String voterEmail = voterMap['email'] as String;

  final Email email = Email(
    body: 'Dear Voter,\n$name has created a poll named $title and you are requested to vote.\n\nYour unique ID for the poll is: $token.\nPlease use this ID to cast your vote.\n\nThank you!',
    subject: 'Your Poll Unique ID',
    recipients: [voterEmail],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
    print("Email sent to $voterEmail.");
  } catch (e) {
    print("Failed to send email to $voterEmail: $e");
  }
}


Future<String> getPollData(String pollId) async {
  try {
    // Reference to the document
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('polls')
        .doc(pollId)
        .get();

    if (document.exists) {
      // Access the data
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      print("Poll Title: ${data['pollTitle']}");
      print("Voting Description: ${data['votingDescription']}");
      return data['pollTitle'];
    } else {
      print("Document does not exist");
      return "";
    }
  } catch (e) {
    print("Error fetching document: $e");
    return "Error fetching document: $e";
  }
}

Future<Map<String, dynamic>?> _fetchUserData() async {
  try {
    // Get the current user's UID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    // Fetch user data from Firestore
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (docSnapshot.exists) {
      return docSnapshot.data();
    } else {
      return null;
    }
  } catch (e) {
    print("Error fetching user data: $e");
    return null;
  }
}