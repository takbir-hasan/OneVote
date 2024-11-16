import 'package:OneVote/widgets/Notifaction.dart';
import 'package:OneVote/widgets/PollCreate.dart';
import 'package:OneVote/widgets/adminLoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import '../auths/adminAuthentication.dart';
import 'ProfilePage.dart';
import 'Login.dart';
import 'AboutUs.dart';
import 'adminprofile.dart';
import 'VotingResultPage.dart';
import 'Feedback.dart';
import '../auths/userAuthentication.dart';
import 'package:OneVote/widgets/SplashScreen.dart';
import 'package:OneVote/widgets/ProfilePage.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      darkTheme: ThemeData(primarySwatch: Colors.grey),
      debugShowCheckedModeBanner: false,
      // home: HomeActivity());
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => HomeActivity(), // Your HomeActivity
      },
    );
  }
}

class HomeActivity extends StatelessWidget {
  // Dummy data for elections
  final List<Map<String, dynamic>> electionData = [
    {
      "name": "Presidential Election",
      "date": "10 Nov 2024",
      "description": "The presidential election for this term.",
      "status": "Running",
      "remainingTime": const Duration(hours: 2),
    },
    {
      "name": "Parliamentary Election",
      "date": "20 Dec 2024",
      "description": "Election for the national parliament seats.",
      "status": "Upcoming",
      "remainingTime": const Duration(days: 5),
    },
    {
      "name": "Presidential Election",
      "date": "10 Nov 2024",
      "description": "The presidential election for this term.",
      "status": "Running",
      "remainingTime": const Duration(hours: 2),
    },
    {
      "name": "Parliamentary Election",
      "date": "20 Dec 2024",
      "description": "Election for the national parliament seats.",
      "status": "Upcoming",
      "remainingTime": const Duration(days: 5),
    },
    {
      "name": "Local Council Election",
      "date": "5 Jan 2025",
      "description": "Election for local government councils.",
      "status": "Completed",
      "remainingTime": const Duration(days: 0), // Already completed
    },
    {
      "name": "State Election",
      "date": "15 Feb 2025",
      "description": "Election for state-level legislative assemblies.",
      "status": "Upcoming",
      "remainingTime": const Duration(days: 80),
    },
    {
      "name": "Senate Election",
      "date": "1 Mar 2024",
      "description": "Election for the national Senate members.",
      "status": "Completed",
      "remainingTime": const Duration(days: -1), // Already completed
    },
  ];

  HomeActivity({Key? key}) : super(key: key);

  mySnackBar(message, context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OneVote"),
        titleSpacing: 20,
        // centerTitle: true,
        backgroundColor: Colors.lightBlue,
        // toolbarHeight: 60,
        // toolbarOpacity: 1,
        // elevation: 0,
        // backgroundColor: Colors.transparent, // Transparent AppBar
        // elevation: 0, // Remove shadow
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //       image: NetworkImage(
        //         'https://img.freepik.com/premium-vector/halftone-gradient-background-with-dots-abstract-purple-dotted-pop-art-pattern-comic-style_515038-12692.jpg?ga=GA1.1.1545834930.1731245301&semt=ais_hybrid', // Replace with your image URL
        //       ),
        //       fit: BoxFit.cover, // Make the image cover the entire AppBar
        //     ),
        //   ),
        // ),
        actions: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
          IconButton(
              onPressed: () {
                mySnackBar("Searching...", context);
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                // mySnackBar("Notification", context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationPage()),
                );
              },
              icon: const Icon(Icons.notification_important)),

          IconButton(
              onPressed: () {
                // mySnackBar("Give me feedback", context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackForm()),
                );
              },
              icon: const Icon(Icons.feedback)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                padding: const EdgeInsets.all(0),
                child: UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.lightBlue),
                  accountName: const Text(
                    "Sajid Hasan Takbir",
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: const Text("takbirhasan274gmail.com"),
                  currentAccountPicture: ClipOval(
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfGQ_rvk0VOH1B9_6ikH75UH4jiEUc8uNYOQ&s",
                      width: 80.0, // Adjust the size of the image
                      height: 80.0, // Adjust the size of the image
                      fit: BoxFit.cover, // Ensures the image covers the circle
                    ),
                  ),
                  onDetailsPressed: () {
                    mySnackBar("Profile Page", context);
                  },
                )),
            ListTile(
              leading: const Icon(Icons.where_to_vote, color: Colors.lightBlue),
              title: const Text("Create Pole"),
              onTap: () {
                mySnackBar("pole Page", context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PollCreatePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.lightBlue),
              title: const Text("Profile"),
              onTap: () {
                // mySnackBar("Profile Page", context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AuthenticationPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.lightBlue),
              title: const Text("Feedback"),
              onTap: () {
                // mySnackBar("Feedback Page", context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_sharp,
                  color: Colors.lightBlue),
              title: const Text("Admin"),
              onTap: () {
                // mySnackBar("admin Page", context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminAuthenticationPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.lightBlue),
              title: const Text("About Us"),
              onTap: () {
                // mySnackBar("about Page", context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Colors.lightBlue,
          onPressed: () {
            // mySnackBar("I am floating action button", context);
             Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PollCreatePage()),
                );
          },
          child: const Icon(Icons.add)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          // BottomNavigationBarItem(icon: Icon(Icons.message), label: "Contact"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.blueGrey,
        onTap: (int index) {
          if (index == 0) {
            // mySnackBar("Home Button", context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeActivity()),
            );
          }
          // if (index == 1) {
          //   mySnackBar("Message button clicked", context);
          // }
          if (index == 1) {
            // Navigate to ProfilePage when the Profile tab is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AuthenticationPage()),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: electionData.map((election) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VotingResultPage(
                        electionName: election["name"],
                        electionDate: election["date"],
                        electionDescription: election["description"],
                        electionStatus: election["status"],
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              election["name"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.how_to_vote,
                              color: Colors.blue,
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Date: ${election['date']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Description: ${election['description']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status: ${election['status']}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: election['status'] == 'Running'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            CountdownTimer(
                              endTime: DateTime.now()
                                  .add(election['remainingTime'])
                                  .millisecondsSinceEpoch,
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
