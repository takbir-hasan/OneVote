class PriceModel {
  final double pricePerVoter;

  // Constructor
  PriceModel({required this.pricePerVoter});

  // Convert the PriceModel to a Map for Firestore (or any other storage)
  Map<String, dynamic> toMap() {
    return {
      'pricePerVoter': pricePerVoter,
    };
  }

  // Create a PriceModel instance from a Map (useful for Firestore retrieval)
  factory PriceModel.fromMap(Map<String, dynamic> map) {
    return PriceModel(
      pricePerVoter: map['pricePerVoter'] ?? 0.0,
    );
  }
}
