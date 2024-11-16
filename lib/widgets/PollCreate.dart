import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; 
import 'package:csv/csv.dart'; 

class PollCreatePage extends StatefulWidget {
  const PollCreatePage({super.key});

  @override
  _PollCreatePageState createState() => _PollCreatePageState();
}

class _PollCreatePageState extends State<PollCreatePage> {
  final TextEditingController pollTitleController = TextEditingController();
  final TextEditingController votingDescriptionController =
      TextEditingController();
  final TextEditingController voterListController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> positions = [];
  int emailCount = 0;

   // Add controllers for Start Time and End Time
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  
  DateTime? startTime;
  DateTime? endTime;


  String? uploadedFileName; // Variable to store the uploaded file name

  void addPosition() {
    setState(() {
      positions.add({
        "positionTitle": "", // Store position title here
        "candidates": [
          {"name": "", "image": null}
        ]
      });
    });
  }

  void deletePosition(int positionIndex) {
    setState(() {
      positions.removeAt(positionIndex);
    });
  }

  void addCandidate(int positionIndex) {
    setState(() {
      positions[positionIndex]["candidates"].add({"name": "", "image": null});
    });
  }

  void deleteCandidate(int positionIndex, int candidateIndex) {
    setState(() {
      positions[positionIndex]["candidates"].removeAt(candidateIndex);
    });
  }

  Future<void> pickImage(int positionIndex, int candidateIndex) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() {
                      positions[positionIndex]["candidates"][candidateIndex]
                          ["image"] = File(image.path);
                    });
                  }
                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      positions[positionIndex]["candidates"][candidateIndex]
                          ["image"] = File(image.path);
                    });
                  }
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void calculateEmailCount() {
    final emails = voterListController.text.split(',');
    setState(() {
      emailCount = emails.where((email) => email.trim().isNotEmpty).length;
    });
  }

   Future<void> uploadCSVFile() async {
    // Open file picker to select the CSV file
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    
    if (result != null) {
      File file = File(result.files.single.path!);

      // Read the file and parse the CSV
      String fileContent = await file.readAsString();
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(fileContent);

      // Assuming emails are in the first column
      List<String> emails = csvTable.map((row) => row[0].toString()).toList();

      setState(() {
        emailCount = emails.where((email) => email.trim().isNotEmpty).length;
        uploadedFileName = result.files.single.name; // Update file name
      });
    } else {
      // User canceled the file picker
      print("No file selected");
    }
  }

  
  // Function to show Date and Time Picker
  Future<void> pickDateTime(TextEditingController controller, DateTime? selectedTime) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedTime ?? DateTime.now()),
      );
      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        controller.text = "${selectedDateTime.toLocal()}".split(' ')[0];
       
        setState(() {
          if (controller == startTimeController) {
            startTime = selectedDateTime;
          } else {
            endTime = selectedDateTime;
          }
        });
      }
    }
  }

  Widget facebookStyledButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1877F2), // Facebook blue color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Smaller border radius
        ),
      ),
      icon: Icon(icon, size: 20, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Poll"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poll Title
                const Text("Poll Title",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: pollTitleController,
                  decoration: const InputDecoration(hintText: "Enter Poll Title"),
                ),
                const SizedBox(height: 16.0),

                // Positions
                const Text("Positions",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: positions.length,
                  itemBuilder: (context, positionIndex) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Position Title Input
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      positions[positionIndex]["positionTitle"] =
                                          value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Enter Position Name",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add_circle,
                                          color: Colors.blue),
                                      onPressed: () =>
                                          addCandidate(positionIndex),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          deletePosition(positionIndex),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  positions[positionIndex]["candidates"].length,
                              itemBuilder: (context, candidateIndex) {
                                return Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.image),
                                      onPressed: () => pickImage(
                                          positionIndex, candidateIndex),
                                    ),
                                    positions[positionIndex]["candidates"]
                                                [candidateIndex]["image"] !=
                                            null
                                        ? Image.file(
                                            positions[positionIndex]
                                                    ["candidates"][candidateIndex]
                                                ["image"],
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          )
                                        : const SizedBox.shrink(),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                          positions[positionIndex]
                                                  ["candidates"][candidateIndex]
                                              ["name"] = value;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Candidate Name"),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          color: Colors.red),
                                      onPressed: () => deleteCandidate(
                                          positionIndex, candidateIndex),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                facebookStyledButton(
                  label: "Add Position",
                  icon: Icons.add,
                  onPressed: addPosition,
                ),
                const SizedBox(height: 16.0),

                // Voting Description
                const Text("Voting Description",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: votingDescriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Enter Voting Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Voter List
                const Text("Voter List",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: voterListController,
                  decoration: const InputDecoration(
                    hintText: "Enter emails separated by commas",
                  ),
                  onChanged: (_) => calculateEmailCount(),
                ),
                const SizedBox(height: 8.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "OR",
                    style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 3.0),

                facebookStyledButton(
                  label: "Upload CSV File",
                  icon: Icons.upload_file,
                  onPressed: uploadCSVFile,
                ),
                // Display the file name if a file has been selected
                if (uploadedFileName != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '**Selected file: $uploadedFileName',
                      style: const TextStyle(fontSize: 16.0, color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 8.0),

               // Add the Start Time input field
                const Text("Start Time", style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: startTimeController,
                  readOnly: true,
                  decoration: const InputDecoration(hintText: "Select Start Time", suffixIcon: Icon(Icons.access_time),),
                  onTap: () => pickDateTime(startTimeController, startTime),
                ),
                const SizedBox(height: 16.0),

                // Add the End Time input field
                const Text("End Time", style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: endTimeController,
                  readOnly: true,
                  decoration: const InputDecoration(hintText: "Select End Time", suffixIcon: Icon(Icons.access_time),),
                  onTap: () => pickDateTime(endTimeController, endTime),
                ),
                const SizedBox(height: 16.0),

               Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Selected Voters: $emailCount",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10.0),

                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Per Email 10 Dollars",
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 12.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 1.0),

                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.attach_money, // Money icon
                        color: Colors.red, // Set the icon color to white
                      ),
                      const SizedBox(width: 8.0), // Add space between the icon and text
                      Text(
                        "Total Cost: \$${emailCount * 10}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red, // Set the text color to white
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6.0),


                // Submit Button
                Center(
                  child: facebookStyledButton(
                    label: "Submit",
                    icon: Icons.send,
                    onPressed: () {
                      // Submit logic
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
