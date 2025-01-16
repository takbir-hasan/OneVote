import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class VotingResultPage extends StatefulWidget {
  final String electionName;
  final String startingDate;
  final String endingDate;
  final String electionDescription;
  final String electionStatus;
  final String pollId;
  final int isOwner;

  const VotingResultPage({
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
  _VotingResultPageState createState() => _VotingResultPageState();
}

class _VotingResultPageState extends State<VotingResultPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _pollData;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchPollData();
  }

  Future<void> _fetchPollData() async {
    try {
      DocumentSnapshot pollDoc =
      await _firestore.collection('polls').doc(widget.pollId).get();

      if (pollDoc.exists) {
        setState(() {
          _pollData = pollDoc.data() as Map<String, dynamic>;
        });
      } else {
        setState(() {
          _statusMessage = "Poll not found.";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error fetching poll data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
        backgroundColor: Colors.lightBlue,
      ),
      body: _pollData == null
          ? Center(
        child: _statusMessage.isNotEmpty
            ? Text(
          _statusMessage,
          style: const TextStyle(color: Colors.red),
        )
            : const CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.electionName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Text("Start Date: ${widget.startingDate}"),
                  Text("End Date: ${widget.endingDate}"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Description: ${widget.electionDescription}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Status: ${widget.electionStatus}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: widget.electionStatus == 'Running'
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildPositionWisePieCharts(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionWisePieCharts() {
    final List<dynamic> positions = _pollData?['positions'] ?? [];
    if (positions.isEmpty) {
      return const Center(child: Text("No positions available."));
    }

    // Build pie charts for each position
    return ListView.builder(
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final position = positions[index];
        final positionTitle = position['positionTitle'] ?? 'Position';
        final candidates = List<Map<String, dynamic>>.from(
            position['candidates'] ?? []);

        if (candidates.isEmpty) {
          return const Text("No candidates available for this position.");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                positionTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // List of candidates with votes and percentage
            _buildCandidateList(candidates),
            // const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: _buildPieChartForPosition(candidates),
            ),
            // Color Legend
            _buildColorLegend(candidates),
            const Divider(),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildCandidateList(List<Map<String, dynamic>> candidates) {
    int totalVotes = 0;

    // Calculate total votes for this position
    for (var candidate in candidates) {
      totalVotes += candidate['voteCount'] as int ?? 0;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: candidates.map((candidate) {
          final votes = candidate['voteCount'] ?? 0;
          final percentage = totalVotes == 0
              ? 0
              : (votes / totalVotes) * 100;
          return ListTile(
            title: Text(candidate['name'] ?? 'Unknown',style: TextStyle(
              fontSize: 18,             // Set font size
              fontWeight: FontWeight.bold,  // Make text bold
            )),
            subtitle: Text(
              "Votes: $votes, Percentage: ${percentage.toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 15),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPieChartForPosition(List<Map<String, dynamic>> candidates) {
    int totalVotes = 0;

    // Calculate total votes for this position
    for (var candidate in candidates) {
      totalVotes += candidate['voteCount'] as int ?? 0;
    }

    // Prepare PieChartSectionData for each candidate
    List<PieChartSectionData> sections = candidates.map((candidate) {
      final votes = candidate['voteCount'] ?? 0;
      final percentage = totalVotes == 0 ? 0.0 : (votes / totalVotes) * 100.0;

      return PieChartSectionData(
        value: percentage,  // Ensure 'value' is a double
        color: Colors.primaries[candidates.indexOf(candidate) % Colors.primaries.length],
        title: "${percentage.toStringAsFixed(2)}%",
        titleStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40, // Empty space at the center
        sectionsSpace: 2, // Space between sections
      ),
    );
  }

  Widget _buildColorLegend(List<Map<String, dynamic>> candidates) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: candidates.map((candidate) {
          final color = Colors.primaries[candidates.indexOf(candidate) % Colors.primaries.length];
          return Row(
            children: [
              Container(
                width: 20,
                height: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                candidate['name'] ?? 'Unknown',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}