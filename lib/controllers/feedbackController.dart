import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/feedbackModel.dart';
import '../widgets/Feedback.dart';

class FeedbackController {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController feedbackController;

  FeedbackController({
    required this.nameController,
    required this.emailController,
    required this.feedbackController,
  });

  // Validates the form fields
  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  // Creates a FeedbackModel from the form data
  FeedbackModel createFeedbackModel() {
    return FeedbackModel(
      name: nameController.text,
      email: emailController.text,
      feedback: feedbackController.text,
    );
  }

  // Handles the feedback submission process and stores data in Firestore
  Future<void> submitFeedback(
      GlobalKey<FormState> formKey, BuildContext context) async {
    if (validateForm(formKey)) {
      // Create FeedbackModel from the form data
      FeedbackModel feedback = createFeedbackModel();

      // Save the feedback to Firestore
      try {
        await FirebaseFirestore.instance.collection('feedbacks').add({
          'name': feedback.name,
          'email': feedback.email,
          'feedback': feedback.feedback,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show success message after submitting feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Feedback Submitted Successfully!")),
        );

        // Clear the form fields after submission
        nameController.clear();
        emailController.clear();
        feedbackController.clear();
      } catch (e) {
        // Handle errors and show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting feedback: $e")),
        );
      }
    }
  }
}
