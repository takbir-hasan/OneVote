import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // Import for base64 encoding
import 'Login.dart';

// import 'HomePage.dart'; // Assume you have a HomePage to navigate to
import '../controllers/userController.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  String _profileImageBase64 = ""; // Store base64 image string
  bool _isLoading = false; // Track the loading state
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Pick photo from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _profileImageBase64 = ''; // Clear previous base64 if image changes
      });
      await _convertImageToBase64();
    }
  }

  // Pick photo using camera
  Future<void> _captureImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _profileImageBase64 = ''; // Clear previous base64 if image changes
      });
      await _convertImageToBase64();
    }
  }

  // Convert image to base64 string
  Future<void> _convertImageToBase64() async {
    if (_profileImage != null) {
      List<int> imageBytes = await _profileImage!.readAsBytes();
      setState(() {
        _profileImageBase64 = base64Encode(imageBytes); // Store base64 image
      });
    }
  }

  // Sign up method
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String password = _passwordController.text;

      setState(() {
        _isLoading = true; // Set loading state to true
      });

      try {
        // Call the UserController to handle signup and create user in Firebase
        await UserController.signUpUser(
          name: name,
          email: email,
          phone: phone,
          password: password,
          profileImageBase64: _profileImageBase64,
          // Pass the base64 string
          context: context,
        );

        // Once signup is successful, navigate to another page (e.g., HomePage)
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomePage()),
        // );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false; // Reset loading state
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
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
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) // For new image
                          : _profileImageBase64.isNotEmpty
                              ? MemoryImage(base64Decode(
                                  _profileImageBase64)) // Display base64 image
                              : null, // Default state when no image is set
                      child:
                          _profileImage == null && _profileImageBase64.isEmpty
                              ? const Icon(Icons.camera_alt, size: 50)
                              : null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(_nameController, 'Name', Icons.person, false),
                  const SizedBox(height: 20),
                  _buildTextField(_emailController, 'Email', Icons.email, false,
                      validateEmail: true),
                  const SizedBox(height: 20),
                  _buildTextField(
                      _phoneController, 'Phone Number', Icons.phone, false,
                      validatePhone: true),
                  const SizedBox(height: 20),
                  _buildTextField(
                      _passwordController, 'Password', Icons.lock, true,
                      minLength: 8),
                  const SizedBox(height: 20),
                  _buildTextField(_confirmPasswordController,
                      'Confirm Password', Icons.lock, true,
                      confirmPassword: _passwordController.text),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Signup",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
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
      ),
    );
  }

  // TextField with validation
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, bool obscureText,
      {bool validateEmail = false,
      bool validatePhone = false,
      int minLength = 0,
      String confirmPassword = ''}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter your $label',
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your $label';
        if (validateEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email address';
        }
        if (validatePhone && !RegExp(r'^\d{10,15}$').hasMatch(value)) {
          return 'Enter a valid phone number';
        }
        if (minLength > 0 && value.length < minLength) {
          return 'Password must be at least $minLength characters';
        }
        if (confirmPassword.isNotEmpty && value != confirmPassword) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
