import 'dart:convert';
import 'package:OneVote/models/pollModel.dart';
import 'package:bkash/bkash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
// import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
// import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
// import 'package:flutter_sslcommerz/sslcommerz.dart';
// import 'package:get/get.dart';
import 'package:uddoktapay/models/customer_model.dart';
import 'package:uddoktapay/models/request_response.dart';
import 'package:uddoktapay/uddoktapay.dart';

import '../controllers/sendTokenController.dart';
import '../widgets/main.dart';


// double totalPrice = 1.00;  // Example amount

void onButtonTap(BuildContext context, String selected, String name, String email, String price, String id, List<Map<String, Object>> voterlist) async {
  try {
    switch (selected) {
      case 'bkash':
        await bkashPayment(context, name, email, price, id, voterlist);
        break;

      case 'uddoktapay':
        await uddoktapay(context, name, email, price, id, voterlist);
        break;

      // case 'sslcommerz':
      //   await sslcommerz(context);
      //   break;

      default:
        print('No gateway selected');
        // Optionally show an alert or message
        break;
    }
  } catch (e) {
    print('Error during payment process: $e');
    _showErrorSnackBar(context, 'An error occurred during the payment process.');
  }
}

/// bKash Payment
bkashPayment(BuildContext context, String name, String email, String price, String id, List<Map<String, Object>> voterlist) async {
  final bkash = Bkash(logResponse: true);

  try {
    final response = await bkash.pay(
      context: context,
      amount: double.parse(price),
      merchantInvoiceNumber: 'Test0123456',
    );

    print('Payment successful, TRX ID: ${response.trxId}');
    print('Payment ID: ${response.paymentId}');
    _showSuccessSnackBar(context, 'Payment Successful', id,voterlist);
  } on BkashFailure catch (e) {
    print('bKash Payment Failed: ${e.message}');
    _showErrorSnackBar(context, 'Payment Failed: ${e.message}');
  }
}

/// UddoktaPay Payment
Future<void> uddoktapay(BuildContext context, String name, String email, String price, String id, List<Map<String, Object>> voterlist) async {
  try {
    final response = await UddoktaPay.createPayment(
      context: context,
      customer: CustomerDetails(
        fullName: name,
        email: email,
      ),
      amount: price,
    );

    if (response.status == ResponseStatus.completed) {
      print('Payment completed, TRX ID: ${response.transactionId}');
      print('Sender Number: ${response.senderNumber}');
      _showSuccessSnackBar(context, 'Payment Completed',id,voterlist);
    } else if (response.status == ResponseStatus.canceled) {
      print('Payment canceled');
      _showErrorSnackBar(context, 'Payment Canceled');
    } else if (response.status == ResponseStatus.pending) {
      print('Payment pending');
      _showErrorSnackBar(context, 'Payment Pending');
    }
  } catch (e) {
    print('UddoktaPay Error: $e');
    _showErrorSnackBar(context, 'Payment Error');
  }
}

// /// SslCommerz Payment
// Future<void> sslcommerz(BuildContext context) async {
//   try {
//     Sslcommerz sslcommerz = Sslcommerz(
//       initializer: SSLCommerzInitialization(
//         multi_card_name: "visa,master,bkash",
//         currency: SSLCurrencyType.BDT,
//         product_category: "Digital Product",
//         sdkType: SSLCSdkType.TESTBOX,
//         store_id: "your_store_id",
//         store_passwd: "your_store_password",
//         total_amount: totalPrice,
//         tran_id: "TestTRX001",
//       ),
//     );
//
//     final response = await sslcommerz.payNow();
//
//     if (response.status == 'VALID') {
//       print('Payment successful, TRX ID: ${response.tranId}');
//       print('Transaction Date: ${response.tranDate}');
//       _showSuccessSnackBar(context, 'Payment Successful');
//     } else if (response.status == 'Closed') {
//       print('Payment closed');
//       _showErrorSnackBar(context, 'Payment Closed');
//     } else if (response.status == 'FAILED') {
//       print('Payment failed');
//       _showErrorSnackBar(context, 'Payment Failed');
//     }
//   } catch (e) {
//     print('SslCommerz Error: $e');
//     _showErrorSnackBar(context, 'Payment Error');
//   }
// }

/// Show Success SnackBar
void _showSuccessSnackBar(BuildContext context, String message, String id, List<Map<String, Object>> voterlist) {
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: Text(message),
  //     backgroundColor: Colors.green,
  //   ),
  // );
  handlePaymentSuccess(id, voterlist);
  Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => HomeActivity())
  );
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Payment Success'),
        content: Text('Your poll is live now!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);  // Close the dialog
            },
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}

/// Show Error SnackBar
void _showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
