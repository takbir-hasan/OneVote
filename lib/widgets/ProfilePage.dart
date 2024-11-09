import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/Login.dart'; // Your Login Page
import 'main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth instance for sign-out
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeActivity()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                  child: ClipOval(
                child: Container(
                  width: 100.0, // Adjust the width and height as needed
                  height: 100.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://img.freepik.com/free-photo/horizontal-portrait-smiling-happy-young-pleasant-looking-female-wears-denim-shirt-stylish-glasses-with-straight-blonde-hair-expresses-positiveness-poses_176420-13176.jpg?ga=GA1.2.209838246.1722743839&semt=ais_hybrid',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),

              const SizedBox(height: 16.0),

              // Profile Name Card
              const Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    "Name",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Dr. Syed Md Galib"),
                ),
              ),
              const SizedBox(height: 10.0),

              // Mobile Number Card
              const Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    "Mobile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text("+1234567890"), // Placeholder for mobile number
                ),
              ),
              const SizedBox(height: 10.0),

              // Email Card
              const Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    "Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text("galib.cse@gmail.com"), // Placeholder for email
                ),
              ),
              const SizedBox(height: 20.0),

              // Logout and Edit Profile Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logout Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          // Sign out the user
                          await _auth.signOut();

                          // After sign out, navigate to login page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        } catch (e) {
                          // Handle any errors
                          print("Error signing out: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Logout failed!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        // Facebook blue color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Adjust the rounding
                        ),
                      ),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white, // Icon color
                      ),
                      label: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white), // Text color
                      ),
                    ),
                  ),

                  // Add some spacing between the buttons
                  const SizedBox(width: 16),

                  // Edit Profile Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add Edit Profile functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        // Facebook blue color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Adjust the rounding
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit, // Icon for Edit Profile
                        color: Colors.white, // Icon color
                      ),
                      label: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white), // Text color
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0),
              const Divider(height: 10, thickness: 1),
              // Voting Service Table
              const Center(
                child: Text(
                  "Voting Services",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10.0),
              Card(
                child: Table(
                  border: TableBorder.all(),
                  children: const [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.lightBlueAccent),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Title',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Amount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Election 2023'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Jan 1, 2023'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '200 BDT',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Election 2024'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Feb 15, 2024'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '100 BDT',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Election 2024'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Feb 15, 2024'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '100 BDT',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Election 2024'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Feb 15, 2024'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '100 BDT',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // Add more rows as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
