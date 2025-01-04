import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class VotingResultPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(electionName),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Election Date: $startingDate",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),Text(
              "Election Date: $endingDate",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Description: $electionDescription",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Text(
              "Status: $electionStatus",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color:
                    electionStatus == 'Running' ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Handle vote action here
              },
              icon: const Icon(Icons.thumb_up, color: Colors.white),
              // Icon added
              label: const Text("Vote Now"),
              // Text label
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1877F2),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Border radius added
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const Text(
              "Voting Results will appear here after voting ends.",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            // Pie chart to visualize vote results
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: Colors.blue,
                      title: "40%",
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.red,
                      title: "30%",
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.green,
                      title: "20%",
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    PieChartSectionData(
                      value: 10,
                      color: Colors.yellow,
                      title: "10%",
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Percentage details
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Option A: 40%", style: TextStyle(fontSize: 16, color: Colors.blue)),
                Text("Option B: 30%", style: TextStyle(fontSize: 16, color: Colors.red)),
                Text("Option C: 20%", style: TextStyle(fontSize: 16, color: Colors.green)),
                Text("Option D: 10%", style: TextStyle(fontSize: 16, color: Colors.yellow)),
               ],
              ),
            const SizedBox(height: 20),
            const Text(
              "Bar Chart View:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 50,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        getTitlesWidget: (context, value) => Text(
                          value.toString(),
                          style: const TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        reservedSize: 32,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                'Option A',
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              );
                            case 1:
                              return const Text(
                                'Option B',
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              );
                            case 2:
                              return const Text(
                                'Option C',
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              );
                            case 3:
                              return const Text(
                                'Option D',
                                style: TextStyle(color: Colors.black, fontSize: 12),
                              );
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: 40,
                        color: Colors.blue,
                        width: 15,
                      ),
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                        toY: 30,
                        color: Colors.red,
                        width: 15,
                      ),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(
                        toY: 20,
                        color: Colors.green,
                        width: 15,
                      ),
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(
                        toY: 10,
                        color: Colors.yellow,
                        width: 15,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}