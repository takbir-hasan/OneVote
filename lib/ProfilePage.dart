import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key}); // Ensure this line is present

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.amber,
      ),
      body: const Center(
        child: Text("Welcome to your Profile!"),
      ),
    );
    
  }
}

