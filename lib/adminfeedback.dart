import 'package:flutter/material.dart';
import 'FeedbackDetailsPage.dart';

class AdminFeedBack extends StatelessWidget {
  final List<Map<String, String>> feedbackList = [
    {'name': 'John Doe', 'feedback': 'Great service!', 'date': '2024-11-06'},
    {'name': 'Jane Smith', 'feedback': 'Could improve response time.', 'date': '2024-11-05'},
    {'name': 'Alex Johnson', 'feedback': 'Very helpful, thank you!', 'date': '2024-11-04'},
    // Add more feedback items as needed
  ];

  AdminFeedBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Feedback'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true, // This ensures that the ListView doesn't try to take all available space
              physics: const NeverScrollableScrollPhysics(), // Prevents scrolling on ListView
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feedbackList[index]['name']!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              feedbackList[index]['date']!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          feedbackList[index]['feedback']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to the details page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedbackDetailsPage(feedback: feedbackList[index]),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1877F2),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('See Details', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
