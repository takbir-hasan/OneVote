import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
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
                mySnackBar("It is Settings", context);
              },
              icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                mySnackBar("I am email", context);
              },
              icon: const Icon(Icons.email)),
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
                  currentAccountPicture: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfGQ_rvk0VOH1B9_6ikH75UH4jiEUc8uNYOQ&s"),
                  onDetailsPressed: () {
                    mySnackBar("Profile Page", context);
                  },
                )),
            ListTile(
              leading: const Icon(Icons.contact_page),
              title: const Text("Contact"),
              onTap: () {
                mySnackBar("Contact Page", context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                mySnackBar("Profile Page", context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              onTap: () {
                mySnackBar("Contact Page", context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Feedback"),
              onTap: () {
                mySnackBar("Feedback Page", context);
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
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Contact"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (int index) {
          if (index == 0) {
            mySnackBar("Home Button", context);
          }
          if (index == 1) {
            mySnackBar("Message button clicked", context);
          }
          if (index == 2) {
            mySnackBar("Your Profile", context);
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
              color: Colors.redAccent,
              border: Border.all(color: Colors.black, width: 6)),
          child: Image.network(
              "https://pbs.twimg.com/media/El9bi-8VkAINwqY?format=jpg&name=large"),
        ),
      ),
    );
  }
}
