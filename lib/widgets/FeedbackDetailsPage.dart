import 'package:flutter/material.dart';

class FeedbackDetailsPage extends StatelessWidget {
  final Map<String, String> feedback;

  const FeedbackDetailsPage({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Details'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feedback from: ${feedback['name']}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Feedback: ${feedback['feedback']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Date: ${feedback['date']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Add more details or actions if needed
          ],
        ),
      ),
    );
  }
}
