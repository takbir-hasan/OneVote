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
        data['startTime'] = (data['startTime'] as Timestamp).toDate();
        data['endTime'] = (data['endTime'] as Timestamp).toDate();
        return data;
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error fetching poll data: $e";
      });
    }
    return null;
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

  Future<void> _submitVotes(DateTime startTime, DateTime endTime) async {
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

        print("Position: $position");
        print("CandidateId: $candidateId");



        // String normalizedPosition = position.trim();
        // print("Normalized position: $normalizedPosition");
        //
        // var positionSnapshot = await _firestore
        //     .collection('polls')
        //     .doc(widget.pollId)
        //     .collection('positions')
        //     .where(normalizedPosition)
        //     .get();
        //
        // if (positionSnapshot.docs.isEmpty) {
        //   print("No documents found for positionTitle: $normalizedPosition");
        //   print("Available documents in positions collection:");
        //   var allPositions = await _firestore
        //       .collection('polls')
        //       .doc(widget.pollId)
        //       .collection('positions')
        //       .get();
        //   for (var doc in allPositions.docs) {
        //     print("Document ID: ${doc.id}, Data: ${doc.data()}");
        //   }
        // } else {
        //   print("Found ${positionSnapshot.docs.length} document(s):");
        //   for (var doc in positionSnapshot.docs) {
        //     print("Document ID: ${doc.id}, Data: ${doc.data()}");
        //   }
        // }


        if (candidateId != null) {
          // Fetch the poll document
          var pollSnapshot = await _firestore.collection('polls').doc(widget.pollId).get();

          if (pollSnapshot.exists) {
            var pollData = pollSnapshot.data();

            // Check if positions array exists
            if (pollData != null && pollData['positions'] != null) {
              List<dynamic> positions = pollData['positions'];



              int? matchingPositionIndex = positions.indexWhere(
                    (pos) => pos['positionTitle'] == position,
              );
              var matchingPosition;
              if (matchingPositionIndex != -1) {
                 matchingPosition = positions[matchingPositionIndex];
                // Now you can work with matchingPosition
                print("position......: $matchingPosition");
                print("index:,,,,,, $matchingPositionIndex");
              } else {
                print("Position not found.");
              }


              if (matchingPosition != null && matchingPositionIndex != -1) {


                // var positionSnapshot = await _firestore
                //     .collection('polls')
                //     .doc(widget.pollId)
                //     .collection('positions')
                //     .where('positionTitle', isEqualTo: position)
                //     .get();
                String positionDocId = matchingPositionIndex.toString();

                  //  positionDocId = matchingPosition.docs.first.id; // This gives you the Firestore-generated document ID
                  // print("Position document ID: $positionDocId");


                // Now, proceed to increment the vote count in the candidates subcollection
                // var positionDocId = matchingPosition['positionTitle']; // Use a unique ID if available
                // print("position pointing ....... :: $positionDocId");
                  await _firestore.runTransaction((transaction) async {
                  DocumentReference candidateRef = _firestore
                      .collection('polls')
                      .doc(widget.pollId)
                      .collection('positions')
                      .doc(positionDocId) // If needed, map positionTitle to its ID
                      .collection('candidates')
                      .doc(candidateId);

                  print("khela hbe: $candidateRef");
                  DocumentSnapshot snapshot = await transaction.get(candidateRef);
                  print("kheal hbe2: $snapshot");
                  print("Snapshot exists: ${snapshot.exists}");
                  print("Document data: ${snapshot.data()}");
                  if (snapshot.exists && snapshot.data() != null) {
                     // Print the current voteCount before incrementing
                      var currentVoteCount = (snapshot.data() as Map<String, dynamic>)['voteCount'] ?? 0;
                      print("Current voteCount: $currentVoteCount");
                    transaction.update(candidateRef, {'voteCount': FieldValue.increment(1)});
                    print("Vote count incremented successfully.");
                  } else {
                    print("Candidate not found.");
                  }
                });
              } else {
                print("Position not found.");
              }
            } else {
              print("No positions found in the poll document.");
            }
          } else {
            print("Poll not found.");
          }
      }
      }

      setState(() {
        _statusMessage = "Votes submitted successfully!";
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Error submitting votes: $e";
      });
      print(e);
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
            return const Center(child: Text("Poll not found."));
          }

          final positions = List<Map<String, dynamic>>.from(pollData['positions'] ?? []);
          final pollTitle = pollData['pollTitle'] ?? 'Poll';
          final startTime = pollData['startTime'] as DateTime;
          final endTime = pollData['endTime'] as DateTime;
          final status = _getPollStatus(startTime, endTime);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                        status,
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
                Expanded(
                  child: ListView.builder(
                    itemCount: positions.length,
                    itemBuilder: (context, index) {
                      final position = positions[index];
                      final positionTitle = position['positionTitle'] ?? 'Position';
                      final candidates = List<Map<String, dynamic>>.from(position['candidates'] ?? []);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                positionTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...candidates.map((candidate) {
                              final candidateID = candidate['candidateId'] ?? '';
                              final candidateName = candidate['name'] ?? 'Unknown';
                              final candidateImage = candidate['image'] ?? '';
                              final isSelected = _selectedCandidates[positionTitle] == candidateID;

                              return GestureDetector(
                                onTap: (status == "Running")
                                    ? () {
                                  setState(() {
                                    _selectedCandidates[positionTitle] = candidateID;
                                  });
                                }
                                    : null,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? Colors.blue : Colors.grey,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: candidateImage.isNotEmpty
                                            ? MemoryImage(Base64Decoder().convert(candidateImage))
                                            : null,
                                        child: candidateImage.isEmpty ? const Icon(Icons.person) : null,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(candidateName),
                                      ),
                                      Radio<String>(
                                        value: candidateID,
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
                      ? () => _submitVotes(startTime, endTime)
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
                        color: _statusMessage.contains("successfully") ? Colors.green : Colors.red,
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
