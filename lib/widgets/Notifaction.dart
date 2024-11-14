import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // FirebaseFirestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch and sort notifications
  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    // Fetch data from Firestore
    QuerySnapshot snapshot = await _firestore.collection('notifications').get();

    // Convert Firestore documents to a list of maps
    List<Map<String, dynamic>> notifications = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'title': data['title'],
        'description': data['description'],
        'date': (data['date'] as Timestamp).toDate(),
        // Convert Timestamp to DateTime
        'icon': Icons.notifications,
        // Placeholder icon
      };
    }).toList();

    // Sort notifications by date (most recent first)
    notifications.sort((a, b) {
      DateTime dateA = a['date'];
      DateTime dateB = b['date'];
      return dateB.compareTo(dateA); // Sort in descending order
    });

    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching notifications'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No notifications available'));
            }

            final notifications = snapshot.data!;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        notification['icon'],
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      notification['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notification['description'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          // Format DateTime into a readable format
                          "${notification['date'].day}-${notification['date'].month}-${notification['date'].year}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    // trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
