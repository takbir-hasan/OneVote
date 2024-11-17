import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auths/adminAuthentication.dart';
import '../controllers/adminController.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Admin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserAuthentication _userAuth = UserAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  bool _isLoading = false;
  String _errorMessage = '';

  // Handle user login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = ''; // Clear any previous error message
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      UserCredential? userCredential =
          await _userAuth.signInWithEmailPassword(email, password);

      if (userCredential != null) {
        // Check if the user is an admin
        bool isAdmin = await _userAuth.isAdmin(userCredential.user!.uid);
        if (isAdmin) {
          // Navigate to the authenticated page if the user is an admin
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminAuthenticationPage()),
          );
        } else {
          setState(() {
            _errorMessage = "You are not authorized to log in as an Admin.";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Invalid email or password!";
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle password reset
  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email address")),
      );
      return;
    }

    try {
      // Step 1: Check if the email exists in Firestore
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // Step 2: If the email exists in Firestore, check the user's role
      if (snapshot.docs.isNotEmpty) {
        var userDoc = snapshot.docs.first;
        String role = userDoc['role'] ?? '';

        if (role == 'admin') {
          // Step 3: If the role is 'user', send the password reset email
          await _auth.sendPasswordResetEmail(email: email);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password reset email sent")),
          );
        } else {
          // If the role is not 'user', show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found with this email.")),
          );
        }
      } else {
        // If no user is found with the given email in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found with this email.")),
        );
      }
    } catch (e) {
      print("Error: $e");

      // Handle Firebase errors (like network issues, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("An error occurred. Please try again later.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Login"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildResponsiveTextField(
                    'Email',
                    Icons.email,
                    screenWidth,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildResponsiveTextField(
                    'Password',
                    Icons.lock,
                    screenWidth,
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                  ),
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: _showResetPasswordDialog,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveTextField(
      String label, IconData icon, double screenWidth,
      {bool isPassword = false,
      TextEditingController? controller,
      String? Function(String?)? validator}) {
    return SizedBox(
      width: screenWidth * 0.8,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Enter your email address",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _resetPassword();
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
