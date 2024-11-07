import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Method to capture a new photo from the camera
  Future<void> _captureImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              // Horizontal padding as 10% of screen width
              vertical: screenHeight *
                  0.02, // Vertical padding as 2% of screen height
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    // Show dialog to choose source
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Choose Profile Picture"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _pickImageFromGallery();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Gallery"),
                          ),
                          TextButton(
                            onPressed: () {
                              _captureImageFromCamera();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Camera"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: screenWidth * 0.15,
                    // Adjust size based on screen width
                    backgroundImage: _profileImage != null
                        ? FileImage(
                            _profileImage!) // Display the selected image
                        : null,
                    // Otherwise, show the camera icon
                    child: _profileImage == null
                        ? const Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildResponsiveTextField('Name', Icons.person, screenWidth),
                const SizedBox(height: 20),
                _buildResponsiveTextField('Email', Icons.email, screenWidth),
                const SizedBox(height: 20),
                _buildResponsiveTextField(
                    'Phone Number', Icons.phone, screenWidth),
                const SizedBox(height: 20),
                _buildResponsiveTextField('Password', Icons.lock, screenWidth,
                    isPassword: true),
                const SizedBox(height: 20),
                _buildResponsiveTextField(
                    'Confirm Password', Icons.lock, screenWidth,
                    isPassword: true),
                const SizedBox(height: 30),
                SizedBox(
                  width: screenWidth * 0.6, // Make button responsive
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle signup action
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Signup",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text("Already have an account?",
                      style: TextStyle(color: Colors.blueAccent)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create responsive TextFields
  Widget _buildResponsiveTextField(
      String label, IconData icon, double screenWidth,
      {bool isPassword = false}) {
    return SizedBox(
      width: screenWidth * 0.8, // TextField width as 80% of screen width
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
