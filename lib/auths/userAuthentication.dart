import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import '../widgets/Login.dart'; // Your Login Page
import '../widgets/ProfilePage.dart'; // Your Profile Page

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser; // Get current authenticated user
    _checkUserRole();
  }

  // Function to check the user's role from Firestore
  Future<void> _checkUserRole() async {
    if (_user != null) {
      try {
        // Fetch the user document from Firestore using the UID
        DocumentSnapshot userDoc = await _firestore
            .collection(
                'users') // Ensure you have a 'users' collection in Firestore
            .doc(_user?.uid) // Get document by the user's UID
            .get();

        if (userDoc.exists) {
          // Get the role field from the document
          String role = userDoc.get('role');

          if (role == 'user') {
            // If the role is 'user', navigate to the profile page
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            });
          } else {
            // If role is not 'user', navigate to the login page
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            });
          }
        } else {
          // If the user document doesn't exist in Firestore, navigate to login
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          });
        }
      } catch (e) {
        // Handle any error fetching the user data (e.g., Firestore connection issue)
        print("Error fetching user role: $e");
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        });
      }
    } else {
      // If user is not logged in, navigate to the login page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      });
    }
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
