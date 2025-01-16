import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pollModel.dart';
import 'CastVote.dart';

class ValidateVoterPage extends StatefulWidget {
  final String electionName;
  final String startingDate;
  final String endingDate;
  final String electionDescription;
  final String electionStatus;
  final String pollId;
  final int isOwner;

  const ValidateVoterPage({
    Key? key,
    required this.electionName,
    required this.startingDate,
    required this.endingDate,
    required this.electionDescription,
    required this.electionStatus,
    required this.pollId,
    required this.isOwner,
  }) : super(key: key);

  @override
  _ValidateVoterPageState createState() => _ValidateVoterPageState();
}

class _ValidateVoterPageState extends State<ValidateVoterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _statusMessage = "";

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> validateVoter(String pollId, String email, String token) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> pollDoc =
      await _firestore.collection('polls').doc(pollId).get();

      if (!pollDoc.exists) {
        setState(() {
          _statusMessage = "Poll not found.";
        });
        return;
      }

      final data = pollDoc.data();
      if (data == null) {
        setState(() {
          _statusMessage = "Poll document has no data.";
        });
        return;
      }


      // Directly query email and uniqueId from voterList
      final List<dynamic> voterList = data['voterList'] ?? [];
      // print("Voter List: $voterList"); // Debugging voterList

      // Find voter by email
      final voter = voterList.firstWhere(
        (voter) => voter['email'] == email,
        orElse: () => null,
      );

      if (voter == null) {
        setState(() {
          _statusMessage = "Email not found in the voter list.";
        });
        return;
      }

      // print("Found Voter: $voter"); // Debugging found voter

      // Token validation
      if (voter['uniqueId'] == token) {
        setState(() {
          // _statusMessage = "Validation successful!";
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CastVotePage(pollId: pollId, mail: email, token: token)),
          );
        });
      } else {
        setState(() {
          _statusMessage = "Invalid token.";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error: ${e.toString()}";
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Validate Voter"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter Email and Token",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: "Unique ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                final token = _tokenController.text.trim();
                final pollId = widget.pollId;

                if (email.isEmpty || token.isEmpty) {
                  setState(() {
                    _statusMessage = "Email and token are required.";
                  });
                } else {
                  validateVoter(pollId, email, token);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Validate", style: TextStyle(color: Colors.black)),


            ),
            const SizedBox(height: 16),
            Text(
              _statusMessage,
              style: TextStyle(
                fontSize: 16,
                color: _statusMessage == "Validation successful!"
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
