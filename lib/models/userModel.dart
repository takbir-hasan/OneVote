class UserModel {
  final String name;
  final String email;
  final String number;
  final String password;
  final String confirmPassword;
  final String photo; // Base64 encoded image string
  final String role;

  UserModel({
    required this.name,
    required this.email,
    required this.number,
    required this.password,
    required this.confirmPassword,
    required this.photo,
    required this.role,
  });

  // Convert UserModel to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'number': number,
      'password': password,
      'confirmPassword': confirmPassword,
      'photo': photo, // Store the base64 image
      'role': role,
    };
  }

  // Convert map to UserModel (for Firestore retrieval)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      number: map['number'],
      password: map['password'],
      confirmPassword: map['confirmPassword'],
      photo: map['photo'],
      // Retrieve the base64 image
      role: map['role'],
    );
  }
}
