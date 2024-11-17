import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/priceModel.dart';

class PriceController {
  // Reference to the document where the price is stored
  final DocumentReference _priceDocument = FirebaseFirestore.instance.collection('prices').doc('current_price');

  // Save or update the price document in Firestore
  Future<void> updatePrice(PriceModel priceModel) async {
    try {
      // Update the price document in Firestore (merge:true ensures no other fields are removed)
      await _priceDocument.set(priceModel.toMap(), SetOptions(merge: true));
      print("Price updated successfully!");
    } catch (e) {
      print("Error updating price: $e");
      throw Exception("Error updating price to Firestore: $e");
    }
  }

  // Fetch the current price from Firestore (optional)
  Future<PriceModel?> fetchPrice() async {
    try {
      final docSnapshot = await _priceDocument.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return PriceModel.fromMap(data);
      }
      return null; // No price found
    } catch (e) {
      print("Error fetching price: $e");
      return null;
    }
  }
}
