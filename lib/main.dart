import 'package:flutter/material.dart';
import 'ProfilePage.dart';
<<<<<<< Updated upstream


=======
import 'adminprofile.dart';
>>>>>>> Stashed changes
void main() {
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
        home: const HomeActivity());
  }
}

class HomeActivity extends StatelessWidget {
  const HomeActivity({super.key});

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
        actions: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
          IconButton(
              onPressed: () {
                mySnackBar("Searching...", context);
              },
              icon: const Icon(Icons.search)),


          IconButton(
              onPressed: () {
                mySnackBar("Give me feedback", context);
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.lightBlue),
              title: const Text("Profile"),
              onTap: () {
                mySnackBar("Profile Page", context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.lightBlue),
              title: const Text("Feedback"),
              onTap: () {
                mySnackBar("Feedback Page", context);
              },
            ),
            ListTile(
<<<<<<< Updated upstream
              leading: const Icon(Icons.email, color: Colors.lightBlue),
              title: const Text("Admin"),
              onTap: () {
                mySnackBar("admin Page", context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.lightBlue),
              title: const Text("About Us"),
              onTap: () {
                mySnackBar("about Page", context);
=======
              leading: const Icon(Icons.admin_panel_settings, color: Colors.amber),
              title: const Text("Admin"),
              onTap: () {
                mySnackBar("Admin Page", context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminProfile()),
                );
>>>>>>> Stashed changes
              },
            ),
          ],
        ),
      ),
      // endDrawer: Drawer(
      //   child: ListView(
      //     children: [
      //       DrawerHeader(
      //           padding: const EdgeInsets.all(0),
      //           child: UserAccountsDrawerHeader(
      //             decoration: const BoxDecoration(color: Colors.lightBlue),
      //             accountName: const Text(
      //               "Sajid Hasan Takbir",
      //               style: TextStyle(color: Colors.black),
      //             ),
      //             accountEmail: const Text("takbirhasan274gmail.com"),
      //             currentAccountPicture: Image.network(
      //                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfGQ_rvk0VOH1B9_6ikH75UH4jiEUc8uNYOQ&s"),
      //             onDetailsPressed: () {
      //               mySnackBar("Profile Page", context);
      //             },
      //           )),
      //       ListTile(
      //         leading: const Icon(Icons.contact_page),
      //         title: const Text("Contact"),
      //         onTap: () {
      //           mySnackBar("Contact Page", context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.person),
      //         title: const Text("Profile"),
      //         onTap: () {
      //           mySnackBar("Profile Page", context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.email),
      //         title: Text("Email"),
      //         onTap: () {
      //           mySnackBar("Contact Page", context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.feedback),
      //         title: Text("Feedback"),
      //         onTap: () {
      //           mySnackBar("Feedback Page", context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: (),

      floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Colors.lightBlue,
          onPressed: () {
            mySnackBar("I am floating action button", context);
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
            mySnackBar("Home Button", context);
          }
          if (index == 1) {
            mySnackBar("Message button clicked", context);
          }
          if (index == 2) {
            // Navigate to ProfilePage when the Profile tab is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
      ),
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 0)),
          child: Image.network(
              "https://pbs.twimg.com/media/El9bi-8VkAINwqY?format=jpg&name=large"),
        ),
      ),
    );
  }
}
