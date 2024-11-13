import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'FeedbackDetailsPage.dart';

class AdminFeedBack extends StatelessWidget {
  Future<List<Map<String, String>>> fetchFeedbacks() async {
  try {
    var feedbackSnapshot = await FirebaseFirestore.instance
        .collection('feedbacks')
        .orderBy('timestamp', descending: true) 
        .get();

    print("Feedback fetched: ${feedbackSnapshot.docs.length} documents found.");

    return feedbackSnapshot.docs.map((doc) {
      var timestamp = (doc['timestamp'] as Timestamp).toDate();
      String formattedDate = "${timestamp.day}-${timestamp.month}-${timestamp.year} ${timestamp.hour}:${timestamp.minute}";

      return {
        'name': (doc['name'] ?? 'Unknown').toString(),
        'feedback': (doc['feedback'] ?? 'No feedback provided').toString(),
        'date': formattedDate, 
      };
    }).toList();
  } catch (e) {
    // print("Error fetching feedbacks: $e");
    return []; 
  }
}


  const AdminFeedBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Feedback'),
        backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchFeedbacks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No feedback available.'));
          } else {
            List<Map<String, String>> feedbackList = snapshot.data!;

            return SingleChildScrollView(
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                                '${feedbackList[index]['feedback']!
                                .split(' ')
                                .take(10)
                                .join(' ')}...',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FeedbackDetailsPage(
                                          feedback: feedbackList[index],
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1877F2),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('See Details',
                                      style: TextStyle(color: Colors.white)),
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
            );
          }
        },
      ),
    );
  }
}
