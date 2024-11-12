import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/adminLoginPage.dart'; // Your Login Page
import '../widgets/adminprofile.dart'; // Your Profile Page

class AdminAuthenticationPage extends StatefulWidget {
  const AdminAuthenticationPage({super.key});

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AdminAuthenticationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    // Listen to authentication state changes
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        // If the user is logged in, check the role in Firestore
        await _checkUserRole(user);
      } else {
        // If the user is not logged in, navigate to LoginPage
        _navigateToLogin();
      }
    });
  }

  // Function to check the user role from Firestore
  Future<void> _checkUserRole(User user) async {
    try {
      // Fetch the user document from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        // Get the role from the user document
        String role = userDoc.get('role');
        if (role == 'admin') {
          // If the role is admin, navigate to the AdminProfile page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminProfile()),
          );
        } else {
          // If the role is not admin, navigate to the LoginPage
          _navigateToLogin();
        }
      } else {
        // If the user document doesn't exist, navigate to LoginPage
        _navigateToLogin();
      }
    } catch (e) {
      // If there's an error fetching user data, navigate to LoginPage
      _navigateToLogin();
    }
  }

  // Function to navigate to LoginPage
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Admin()),
    );
  }

  // Function to sign the user out
  Future<void> _signOut() async {
    await _auth.signOut(); // Sign out the user
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Admin(),
      ), // Navigate back to the login page
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading screen while checking the authentication and user role
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
