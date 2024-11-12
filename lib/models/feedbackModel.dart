class FeedbackModel {
  String name;
  String email;
  String feedback;

  FeedbackModel({
    required this.name,
    required this.email,
    required this.feedback,
  });

  // Serialize the data to JSON (for server communication or storage)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'feedback': feedback,
    };
  }

  // Factory constructor to create FeedbackModel from a Map (useful for deserialization)
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      name: json['name'],
      email: json['email'],
      feedback: json['feedback'],
    );
  }
}
