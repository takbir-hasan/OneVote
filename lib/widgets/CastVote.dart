import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CastVotePage extends StatefulWidget {
  final String pollId;
  final String mail;
  final String token;

  const CastVotePage({
    Key? key,
    required this.pollId,
    required this.mail,
    required this.token,
  }) : super(key: key);

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

  // Future<void> _submitVotes(DateTime startTime, DateTime endTime) async {
  //   final now = DateTime.now();
  //   if (now.isBefore(startTime)) {
  //     setState(() {
  //       _statusMessage = "Voting hasn't started yet.";
  //     });
  //     return;
  //   }
  //
  //   if (now.isAfter(endTime)) {
  //     setState(() {
  //       _statusMessage = "Voting has already ended.";
  //     });
  //     return;
  //   }
  //
  //   // try {
  //   //   for (var position in _selectedCandidates.keys) {
  //   //     final candidateId = _selectedCandidates[position];
  //   //     if (candidateId != null) {
  //   //       final pollDoc = await _firestore.collection('polls').doc(widget.pollId).get();
  //   //       if (!pollDoc.exists) {
  //   //         setState(() {
  //   //           _statusMessage = "Poll document not found.";
  //   //         });
  //   //         return;
  //   //       }
  //   //
  //   //       final pollData = pollDoc.data();
  //   //       if (pollData == null || pollData['positions'] == null) {
  //   //         setState(() {
  //   //           _statusMessage = "Invalid poll data.";
  //   //         });
  //   //         return;
  //   //       }
  //   //
  //   //       final positions = List.from(pollData['positions']);
  //   //       final positionIndex =
  //   //       positions.indexWhere((pos) => pos['positionTitle'] == position);
  //   //
  //   //       if (positionIndex == -1) {
  //   //         setState(() {
  //   //           _statusMessage = "Position not found.";
  //   //         });
  //   //         return;
  //   //       }
  //   //
  //   //       final positionDocId = positionIndex.toString();
  //   //       final candidateRef = _firestore
  //   //           .collection('polls')
  //   //           .doc(widget.pollId)
  //   //           .collection('positions')
  //   //           .doc(positionDocId)
  //   //           .collection('candidates')
  //   //           .doc(candidateId);
  //   //
  //   //       await _firestore.runTransaction((transaction) async {
  //   //         final snapshot = await transaction.get(candidateRef);
  //   //         if (snapshot.exists) {
  //   //           final currentCount = snapshot.get('voteCount') ?? 0;
  //   //           transaction.update(candidateRef, {'voteCount': currentCount + 1});
  //   //         }
  //   //       });
  //   //
  //   //       await _updateVoterStatus();
  //   //       setState(() {
  //   //         _statusMessage = "Votes submitted successfully!";
  //   //       });
  //   //
  //   //       showDialog(
  //   //         context: context,
  //   //         builder: (context) {
  //   //           return AlertDialog(
  //   //             title: const Text('Vote Complete'),
  //   //             content: Text(
  //   //                 'Thank you for your vote.\nResults will be published at $startTime.'),
  //   //             actions: [
  //   //               TextButton(
  //   //                 onPressed: () => Navigator.pop(context),
  //   //                 child: const Text('Ok'),
  //   //               ),
  //   //             ],
  //   //           );
  //   //         },
  //   //       );
  //   //     }
  //   //   }
  //   // } catch (e) {
  //   //   setState(() {
  //   //     _statusMessage = "Error submitting votes: $e";
  //   //   });
  //   // }
  //
  //   try {
  //     final pollDoc = await _firestore.collection('polls').doc(widget.pollId).get();
  //     if (!pollDoc.exists) {
  //       setState(() {
  //         _statusMessage = "Poll not found.";
  //       });
  //       return;
  //     }
  //
  //     final pollData = pollDoc.data();
  //     if (pollData == null || pollData['positions'] == null) {
  //       setState(() {
  //         _statusMessage = "Poll data is invalid.";
  //       });
  //       return;
  //     }
  //
  //     final positions = List<Map<String, dynamic>>.from(pollData['positions']);
  //     for (var position in _selectedCandidates.keys) {
  //       final candidateId = _selectedCandidates[position];
  //       if (candidateId != null) {
  //         final positionIndex = positions.indexWhere(
  //               (pos) => pos['positionTitle'] == position,
  //         );
  //
  //         if (positionIndex == -1) {
  //           setState(() {
  //             _statusMessage = "Position '$position' not found.";
  //           });
  //           return;
  //         }
  //
  //         final positionDocId = positionIndex.toString();
  //         final candidateRef = _firestore
  //             .collection('polls')
  //             .doc(widget.pollId)
  //             .collection('positions')
  //             .doc(positionDocId)
  //             .collection('candidates')
  //             .doc(candidateId);
  //
  //         await _firestore.runTransaction((transaction) async {
  //           final candidateSnapshot = await transaction.get(candidateRef);
  //           if (candidateSnapshot.exists) {
  //             final currentVoteCount = candidateSnapshot.get('voteCount') ?? 0;
  //             transaction.update(candidateRef, {'voteCount': currentVoteCount + 1});
  //           } else {
  //             throw Exception("Candidate not found.");
  //           }
  //         });
  //       } else {
  //         setState(() {
  //           _statusMessage = "Invalid candidate selection for '$position'.";
  //         });
  //         return;
  //       }
  //     }
  //
  //     await _updateVoterStatus();
  //     setState(() {
  //       _statusMessage = "Votes submitted successfully!";
  //     });
  //
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('Vote Complete'),
  //           content: const Text('Thank you for voting!'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     setState(() {
  //       _statusMessage = "Error submitting votes: $e";
  //     });
  //   }
  //
  // }

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
      // Fetch poll document
      final pollDoc = await _firestore.collection('polls').doc(widget.pollId).get();

      if (!pollDoc.exists) {
        setState(() {
          _statusMessage = "Poll not found.";
        });
        return;
      }

      final pollData = pollDoc.data();
      if (pollData == null || pollData['positions'] == null) {
        setState(() {
          _statusMessage = "Poll data is invalid.";
        });
        return;
      }

      // Retrieve positions array
      final List<dynamic> positions = pollData['positions'];

      for (var positionTitle in _selectedCandidates.keys) {
        final candidateId = _selectedCandidates[positionTitle];
        if (candidateId == null) {
          setState(() {
            _statusMessage = "No candidate selected for $positionTitle.";
          });
          return;
        }

        // Find the matching position
        final position = positions.firstWhere(
              (pos) => pos['positionTitle'] == positionTitle,
          orElse: () => null,
        );

        if (position == null) {
          setState(() {
            _statusMessage = "Position '$positionTitle' not found.";
          });
          return;
        }

        // Find the candidate in the position's candidates array
        final List<dynamic> candidates = position['candidates'];
        final candidate = candidates.firstWhere(
              (cand) => cand['candidateId'] == candidateId,
          orElse: () => null,
        );

        if (candidate == null) {
          setState(() {
            _statusMessage = "Candidate not found for position '$positionTitle'.";
          });
          return;
        }

        // Increment the vote count for the selected candidate
        candidate['voteCount'] = (candidate['voteCount'] ?? 0) + 1;
      }

      // Update the poll document with the modified positions array
      await _firestore.collection('polls').doc(widget.pollId).update({
        'positions': positions,
      });

      // Update voter status
      await _updateVoterStatus();

      setState(() {
        _statusMessage = "Votes submitted successfully!";
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Vote Complete'),
            content: const Text('Thank you for voting!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _statusMessage = "Error submitting votes: $e";
      });
    }
  }

  Future<void> _updateVoterStatus() async {
    try {
      final pollDoc = await _firestore.collection('polls').doc(widget.pollId).get();
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

      final voterList = List.from(data['voterList'] ?? []);
      final voterIndex = voterList.indexWhere((voter) => voter['email'] == widget.mail);

      if (voterIndex == -1) {
        setState(() {
          _statusMessage = "Email not found in the voter list.";
        });
        return;
      }

      if (voterList[voterIndex]['uniqueId'] == widget.token) {
        voterList[voterIndex]['hasVoted'] = true;
        await _firestore.collection('polls').doc(widget.pollId).update({
          'voterList': voterList,
        });
      } else {
        setState(() {
          _statusMessage = "Invalid token.";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error updating voter status: $e";
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
            return Center(child: Text("Error: ${snapshot.error}"));
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
              children: [
                Text(
                  pollTitle,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Start Time: ${DateFormat.yMMMd().add_jm().format(startTime)}"),
                Text("End Time: ${DateFormat.yMMMd().add_jm().format(endTime)}"),
                Text(
                  status,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _getStatusColor(status)),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: positions.length,
                    itemBuilder: (context, index) {
                      final position = positions[index];
                      final positionTitle = position['positionTitle'] ?? 'Position';
                      final candidates = List<Map<String, dynamic>>.from(position['candidates'] ?? []);

                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              positionTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...candidates.map((candidate) {
                            final candidateID = candidate['candidateId'] ?? '';
                            final candidateName = candidate['name'] ?? 'Unknown';
                            final candidateImage = candidate['image'] ?? '';
                            final isSelected = _selectedCandidates[positionTitle] == candidateID;

                            return GestureDetector(
                              onTap: status == "Running"
                                  ? () {
                                setState(() {
                                  _selectedCandidates[positionTitle] = candidateID;
                                });
                              }
                                  : null,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
                                  color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    if (candidateImage.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Image.memory(
                                          base64Decode(candidateImage),
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        candidateName,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(Icons.check_circle, color: Colors.blue),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedCandidates.isNotEmpty
                      ? () => _submitVotes(startTime, endTime)
                      : null, // Button disabled if no votes are selected
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCandidates.isNotEmpty ? Colors.lightBlue : Colors.grey, // Color changes dynamically
                  ),
                  child: const Text("Submit Votes", style: TextStyle(color: Colors.black)),
                ),

                if (_statusMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _statusMessage,
                      style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
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
