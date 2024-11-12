import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Login failed: ${e.message}");
      return null;
    }
  }

  // Check if the user has admin role
  Future<bool> isAdmin(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        String role = data['role'] ?? '';
        return role == 'admin';
      }
      return false;
    } catch (e) {
      print("Error checking role: $e");
      return false;
    }
  }

  // Reset password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message; // Return the error message
    }
  }
}
