import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart'; // Add this package


Future<void> handlePaymentSuccess(String pollId, List<Map<String, Object>> voterList) async {
  try {
    // Step 1: Update Firestore to set `isPayment` to 1
    await FirebaseFirestore.instance.collection('polls').doc(pollId).update({
      'isPayment': 1,
    });
    print("Payment status updated successfully for pollId: $pollId");
    final user = FirebaseAuth.instance.currentUser?.email;

    // Step 2: Send emails to voters
    String title = await getPollData(pollId);
    final data = await _fetchUserData();
    String name = data?['name'];

    for (var voterMap in voterList) {
      await sendEmailToVoter(voterMap, title, name);
    }

    // print("Emails sent to all voters.");
    confirmationMail(user!,title);
    // print("Confirmation emails sent.");
  } catch (e) {
    print("Error in handlePaymentSuccess: $e");
  }
}

// Future<void> sendEmailToVoter(Map<String, Object> voterMap, String title, String name) async {
//   String token = voterMap['uniqueId'] as String;
//   String voterEmail = voterMap['email'] as String;
//
//   final Email email = Email(
//     body: 'Dear Voter,\n$name has created a poll named $title and you are requested to vote.\n\nYour unique ID for the poll is: $token.\nPlease use this ID to cast your vote.\n\nThank you!',
//     subject: 'Your Poll Unique ID',
//     recipients: [voterEmail],
//     isHTML: false,
//   );
//
//   try {
//     await FlutterEmailSender.send(email);
//     print("Email sent to $voterEmail.");
//   } catch (e) {
//     print("Failed to send email to $voterEmail: $e");
//   }
// }


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

Future<void> sendEmailToVoter(Map<String, Object> voterMap, String title, String name) async {
  String token = voterMap['uniqueId'] as String;
  String voterEmail = voterMap['email'] as String;

  String username = 'onevote.official@gmail.com';
  String password = 'jsfeyymjpizbnmzi';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'OneVote')
    ..recipients.add(voterEmail)
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'Your Vote Unique ID'
    ..text = 'Dear Voter,\n$name has created a poll named $title and you are requested to vote.\n\nYour unique ID for the poll is: $token\nPlease use this ID to cast your vote.\n\nThank you!';
    message.html = '''
      <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
        <p style="font-size: 16px;">Dear Voter,</p>
        <p style="font-size: 16px;">We are excited to inform you that <strong>$name</strong> has created a poll named <strong>$title</strong>, and your participation is requested!</p>
        <p style="font-size: 16px;">Your unique ID for the poll is: <strong style="color: #4CAF50; font-size: 18px;">$token</strong></p>
        <p style="font-size: 16px;">Please use this ID to cast your vote and make your voice heard.</p>
        <p>If you haven't downloaded the app yet, please do so by clicking the button below:</p>
        <p style="text-align: center; margin: 20px 0;">
        <a href="https://drive.google.com/file/d/1Wz5p-OMMdhJaymjTWEKdlrioiuFdmC9c/view?usp=sharing" 
           target="_blank" 
           style="text-decoration: none;">
            <button style="padding: 12px 24px; font-size: 16px; background-color: #0068ff; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
                Download App
            </button>
        </a>
        </p>
        <br>
        <p style="font-size: 16px;">Thank you for your valuable time and contribution!</p>
        <p style="font-size: 16px; color: #777;">If you have any questions or need assistance, feel free to contact us at: 
            <a href="mailto:onevote.official@gmail.com" style="color: #0068ff; text-decoration: none;"><strong>onevote.official@gmail.com</strong></a>
        </p>
      </div>
      ''';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}



Future<void> confirmationMail(String email, String title) async {

  String username = 'onevote.official@gmail.com';
  String password = 'jsfeyymjpizbnmzi';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'OneVote')
    ..recipients.add(email)
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'Poll Creation Confirmation'
    ..text = 'Dear user,\n Your poll named $title is live now!\n\nThank you for being with us.';
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}