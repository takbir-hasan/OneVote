import 'dart:convert'; // For base64 encoding
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For password hashing
import '../models/userModel.dart';
import '../auths/userAuthentication.dart';

class UserController {
  // Hash the password
  static String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert password to bytes
    var digest = sha256.convert(bytes); // Hash the bytes
    return digest.toString(); // Return the hashed password
  }

  // Sign up user and save data to Firestore
  static Future<void> signUpUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String profileImageBase64, // Accept base64 image string
    required BuildContext context,
    required String role,
  }) async {
    try {
      // Hash the password
      String hashedPassword = hashPassword(password);

      // Attempt to create Firebase user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create UserModel instance
      UserModel user = UserModel(
        name: name,
        email: email,
        number: phone,
        password: hashedPassword,
        confirmPassword: hashedPassword,
        photo: profileImageBase64,
        // Store base64 image here
        role: 'user',
      );

      // print("Saving user to Firestore with photo: ${user.photo}"); // Debugging line

      // Save user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());

      // Handle user sign up success
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(const SnackBar(content: Text("Signup successful!")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase specific errors
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "You already have an account on this email. Please login.")),
        );
      } else {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      }
    }
  }
}
