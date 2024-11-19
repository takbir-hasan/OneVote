import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  String pollId;
  String pollTitle;
  String votingDescription;
  List<Voter> voterList;  // Storing the list of voters in the Poll model
  DateTime startTime;
  DateTime endTime;
  List<Position> positions;  // Positions with Candidates
  String csvFileName;
  String csvFileURL;
  DateTime createdAt;
  String createdBy;
  int isPayment;  // New field to track payment status, default to 0

  Poll({
    required this.pollId,
    required this.pollTitle,
    required this.votingDescription,
    required this.voterList,
    required this.startTime,
    required this.endTime,
    required this.positions,
    required this.csvFileName,
    required this.csvFileURL,
    required this.createdAt,
    required this.createdBy,
    this.isPayment = 0,  // Default isPayment to 0
  });

  // Convert Poll object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'pollId': pollId,
      'pollTitle': pollTitle,
      'votingDescription': votingDescription,
      'voterList': voterList.map((voter) => voter.toMap()).toList(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'positions': positions.map((position) => position.toMap()).toList(),
      'csvFileName': csvFileName,
      'csvFileURL': csvFileURL,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'isPayment': isPayment,  // Include the isPayment field
    };
  }

  // Convert Firestore document to Poll object
  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
      pollId: map['pollId'],
      pollTitle: map['pollTitle'],
      votingDescription: map['votingDescription'],
      voterList: List<Voter>.from(map['voterList'].map((v) => Voter.fromMap(v))),
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      positions: List<Position>.from(map['positions'].map((p) => Position.fromMap(p))),
      csvFileName: map['csvFileName'],
      csvFileURL: map['csvFileURL'],
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'],
      isPayment: map['isPayment'] ?? 0,  // Default to 0 if isPayment is not provided
    );
  }
}

class Position {
  String positionTitle;
  List<Candidate> candidates;

  Position({required this.positionTitle, required this.candidates});

  // Convert Position object to Map
  Map<String, dynamic> toMap() {
    return {
      'positionTitle': positionTitle,
      'candidates': candidates.map((c) => c.toMap()).toList(),
    };
  }

  // Convert Firestore document to Position object
  factory Position.fromMap(Map<String, dynamic> map) {
    return Position(
      positionTitle: map['positionTitle'],
      candidates: List<Candidate>.from(map['candidates'].map((c) => Candidate.fromMap(c))),
    );
  }
}

class Candidate {
  String candidateId;
  String name;
  String image; // Candidate's image URL
  int voteCount;

  Candidate({
    required this.candidateId,
    required this.name,
    required this.image,
    this.voteCount = 0, // Default voteCount is 0
  });

  // Convert Candidate object to Map
  Map<String, dynamic> toMap() {
    return {
      'candidateId': candidateId,
      'name': name,
      'image': image,  // Include image in the map
      'voteCount': voteCount, // Include voteCount in the map
    };
  }

  // Convert Firestore document to Candidate object
  factory Candidate.fromMap(Map<String, dynamic> map) {
    return Candidate(
      candidateId: map['candidateId'],
      name: map['name'],
      image: map['image'],  // Retrieve image from map
      voteCount: map['voteCount'] ?? 0, // Default to 0 if voteCount is not provided
    );
  }

  // Increment vote count for the candidate
  void incrementVote() {
    voteCount++;
  }
}

class Voter {
  String voterId;
  String voterName;
  bool hasVoted;

  Voter({
    required this.voterId,
    required this.voterName,
    this.hasVoted = false,  // Default hasVoted is false
  });

  // Convert Voter object to Map
  Map<String, dynamic> toMap() {
    return {
      'voterId': voterId,
      'voterName': voterName,
      'hasVoted': hasVoted,
    };
  }

  // Convert Firestore document to Voter object
  factory Voter.fromMap(Map<String, dynamic> map) {
    return Voter(
      voterId: map['voterId'],
      voterName: map['voterName'],
      hasVoted: map['hasVoted'] ?? false, // Default to false if not provided
    );
  }
}
