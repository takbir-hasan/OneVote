import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CastVotePage extends StatefulWidget {
  final String pollId;

  const CastVotePage({Key? key, required this.pollId}) : super(key: key);

  @override
  _CastVotePageState createState() => _CastVotePageState();
}

class _CastVotePageState extends State<CastVotePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, String> _selectedCandidates = {};
  String _statusMessage = "";

  Future<Map<String, dynamic>?> _fetchPollData() async {
    try {
      DocumentSnapshot pollDoc =
      await _firestore.collection('polls').doc(widget.pollId).get();
      if (pollDoc.exists) {
        final data = pollDoc.data() as Map<String, dynamic>;

        // Convert Firestore Timestamp to DateTime
        DateTime startTime = (data['startTime'] as Timestamp).toDate();
        DateTime endTime = (data['endTime'] as Timestamp).toDate();
        data['startTime'] = startTime;
        data['endTime'] = endTime;

        return data;
      } else {
        return null;
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error fetching poll data: $e";
      });
      return null;
    }
  }

  String _getPollStatus(DateTime startTime, DateTime endTime) {
    final now = DateTime.now();

    if (now.isBefore(startTime)) {
      return "Starts in: ${_timeDifference(now, startTime)}";
    } else if (now.isAfter(endTime)) {
      return "Completed";
    } else {
      return "Running";
    }
  }

  Color _getStatusColor(String status) {
    if (status.startsWith("Starts in")) {
      return Colors.orange;
    } else if (status == "Running") {
      return Colors.green;
    } else if (status == "Completed") {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  String _timeDifference(DateTime from, DateTime to) {
    final duration = to.difference(from);
    if (duration.inDays > 0) {
      return "${duration.inDays} days ${duration.inHours % 24} hours";
    } else if (duration.inHours > 0) {
      return "${duration.inHours} hours ${duration.inMinutes % 60} minutes";
    } else {
      return "${duration.inMinutes} minutes";
    }
  }

  void _submitVotes(DateTime startTime, DateTime endTime) async {
    final now = DateTime.now();

    if (now.isBefore(startTime)) {
      setState(() {
        _statusMessage = "Voting hasn't started yet.";
      });
      return;
    }

    if (now.isAfter(endTime)) {
      setState(() {
        _statusMessage = "Voting has already ended.";
      });
      return;
    }

    try {
      for (var position in _selectedCandidates.keys) {
        final candidateId = _selectedCandidates[position];
        if (candidateId != null) {
          final candidateDoc = _firestore
              .collection('polls')
              .doc(widget.pollId)
              .collection('positions')
              .doc(position)
              .collection('candidates')
              .doc(candidateId);

          await candidateDoc.update({
            'voteCount': FieldValue.increment(1),
          });
        }
      }

      setState(() {
        _statusMessage = "Votes submitted successfully!";
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Error submitting votes: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cast Your Vote"),
        backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchPollData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final pollData = snapshot.data;
          if (pollData == null) {
            return const Center(
              child: Text("Poll not found."),
            );
          }

          final positions = List<Map<String, dynamic>>.from(pollData['positions']);
          final pollTitle = pollData['pollTitle'];
          final startTime = pollData['startTime'] as DateTime;
          final endTime = pollData['endTime'] as DateTime;
          final status = _getPollStatus(startTime, endTime);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Poll Details Header
                Center(
                  child: Column(
                    children: [
                      Text(
                        pollTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Start Time: ${DateFormat.yMMMd().add_jm().format(startTime)}"),
                      Text("End Time: ${DateFormat.yMMMd().add_jm().format(endTime)}"),
                      Text(
                        "$status",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Positions and Candidates List
                Expanded(
                  child: ListView.builder(
                    itemCount: positions.length,
                    itemBuilder: (context, index) {
                      final position = positions[index];
                      final positionTitle = position['positionTitle'];
                      final candidates = List<Map<String, dynamic>>.from(
                          position['candidates']);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Center( child: Text(
                             positionTitle,
                             style: const TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                             ),
                           )),


                            ...candidates.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> candidate = entry.value;
                              bool isSelected = _selectedCandidates[positionTitle] == index.toString();

                              return GestureDetector(
                                onTap: (status == "Running")
                                    ? () {
                                  setState(() {
                                    _selectedCandidates[positionTitle] = index.toString();
                                  });
                                }
                                    : null,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16), // Rounded corners
                                    border: Border.all(
                                      color: isSelected ? Colors.blue : Colors.grey, // Optional border
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8), // Padding inside the container
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: MemoryImage(
                                          Base64Decoder().convert(candidate['image']),
                                        ),
                                        onBackgroundImageError: (_, __) => const Icon(Icons.person),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(candidate['name']),
                                      ),
                                      Radio<String>(
                                        value: index.toString(),
                                        groupValue: _selectedCandidates[positionTitle],
                                        onChanged: (status == "Running")
                                            ? (value) {
                                          setState(() {
                                            _selectedCandidates[positionTitle] = value!;
                                          });
                                        }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),



                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: (status == "Running" && _selectedCandidates.isNotEmpty)
                      ? () {
                    _submitVotes(startTime, endTime);
                  }
                      : null,
                  child: const Text("Submit Votes"),
                ),
                if (_statusMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: _statusMessage.contains("successfully")
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}