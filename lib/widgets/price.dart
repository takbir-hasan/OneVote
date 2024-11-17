import 'package:flutter/material.dart';
import '../controllers/priceController.dart';
import '../models/priceModel.dart';
import 'adminprofile.dart'; // Assuming this is the next screen after submitting the price

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Price(),
    );
  }
}

class Price extends StatefulWidget {
  const Price({super.key});

  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  final TextEditingController priceController = TextEditingController();
  final PriceController priceControllerInstance = PriceController();
  double? currentPrice; // Variable to store the current price from Firestore
  bool isLoading = true; // Flag to show a loading indicator while fetching or updating the price
  bool isUpdating = false; // Flag to indicate if price is being updated

  @override
  void initState() {
    super.initState();
    _fetchCurrentPrice();
  }

  // Function to fetch the current price from Firestore
  Future<void> _fetchCurrentPrice() async {
    setState(() {
      isLoading = true; // Start loading when fetching price
    });
    try {
      // Get the current price from Firestore
      final priceModel = await priceControllerInstance.fetchPrice();

      setState(() {
        currentPrice = priceModel?.pricePerVoter;
        isLoading = false; // Stop loading once we have the price
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
      print("Error fetching price: $e");
    }
  }

  // Function to handle form submission
  void _submitData() async {
    final price = priceController.text;

    // Validate the input price
    if (price.isEmpty || double.tryParse(price) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid price per voter!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final priceModel = PriceModel(pricePerVoter: double.parse(price));

    setState(() {
      isUpdating = true; // Set isUpdating to true to show loader during update
    });

    try {
      // Update the price in Firestore using PriceController
      await priceControllerInstance.updatePrice(priceModel);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Price updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // After updating, fetch the updated price
      await _fetchCurrentPrice(); // Refresh the current price

      // Navigate to the next screen (e.g., Admin Profile)
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const AdminProfile()),
      // );
    } catch (e) {
      // Show error message if there's an issue with updating the price
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Stop the loading indicator after the update
      setState(() {
        isUpdating = false; // Reset isUpdating
      });
    }

    // Clear the text field after submission
    priceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Price Per Voter'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center the Column
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // Display current price section
            isLoading
                ? const CircularProgressIndicator() // Show a loading indicator while fetching
                : currentPrice == null
                ? const Text(
              'Price has not been set yet.',
              style: TextStyle(fontSize: 16, color: Colors.red),
            )
                : Text(
              'Current Price: \$${currentPrice?.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Spacer between the price display and input fields

            // Centered Price input with OutlineInputBorder and labelText
            Center(
              child: TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price Per Voter',  // Label text
                  border: OutlineInputBorder(),  // Outline border
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true), // Numeric input
              ),
            ),
            const SizedBox(height: 16), // Spacer between input field and button

            // Centered Submit Button with Blue Color
            Center(
              child: ElevatedButton(
                onPressed: isUpdating ? null : _submitData, // Disable the button while updating
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1877F2),
                ),
                child: isUpdating
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                ) // Show loading indicator inside the button while updating
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
