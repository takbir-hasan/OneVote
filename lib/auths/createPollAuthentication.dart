import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../payment/checkout.dart';
import '../widgets/Login.dart';

// Function to check if the user is signed in and show a dialog if not
Future<String> checkUserAndShowDialog(BuildContext context) async {
  // Check if there is a current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    //Fetch user data from Firestore
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection(
        'users') // Assuming user data is stored in 'users' collection
        .doc(currentUser.uid)
        .get();

    String createdBy = userDoc['name'] ?? 'No Name';
    print("User Name: $createdBy");  // You can use this email for further processing
    return createdBy;
  } else {
    // No user is signed in, show a dialog box and return "Unknown"
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Not Signed In'),
          content: Text('You need to be signed in to proceed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close the dialog
              },
              child: Text('OK'),
            ),TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Login()),
                );
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
    // Return "Unknown" when no user is signed in
    return "Unknown";
  }
}

// Function to show the payment dialog, for example when the user needs to be signed in
void payment(BuildContext context, String name, String email, String price) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Payment Info'),
        content: Text('Please pay the fees to complete the process.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Checkout()),
              );
            },
            child: Text('Pay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);  // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}
