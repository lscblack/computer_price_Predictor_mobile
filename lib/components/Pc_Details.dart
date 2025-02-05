import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode

class PcDetails extends StatefulWidget {
  const PcDetails({super.key});

  @override
  State<PcDetails> createState() => _PcDetailsState();
}

class _PcDetailsState extends State<PcDetails> {
  final List<Map<String, dynamic>> inputs = [
    {'label': 'Company', 'value': '', 'type': 'string', 'controller': TextEditingController()},
    {'label': 'Product', 'value': '', 'type': 'string', 'controller': TextEditingController()},
    {'label': 'Type Name', 'value': '', 'type': 'string', 'controller': TextEditingController()},
    {'label': 'Inches', 'value': '', 'type': 'number', 'controller': TextEditingController()},
    {'label': 'CPU', 'value': '', 'type': 'string', 'controller': TextEditingController()},
    {'label': 'RAM', 'value': '', 'type': 'string', 'controller': TextEditingController()},
    {'label': 'Memory', 'value': '', 'type': 'string', 'controller': TextEditingController()},
    {'label': 'GPU', 'value': '', 'type': 'string', 'controller': TextEditingController()},
    {'label': 'Operating System', 'value': '', 'type': 'string', 'controller': TextEditingController()},
    {'label': 'Weight', 'value': '', 'type': 'number', 'controller': TextEditingController()},
    {'label': 'Screen Width', 'value': '', 'type': 'number', 'controller': TextEditingController()},
    {'label': 'Screen Height', 'value': '', 'type': 'number', 'controller': TextEditingController()},
    {'label': 'Touch Screen', 'value': 'false', 'type': 'bool'}, // No controller needed for radio buttons
  ];

  int currentPage = 0;
  static const int itemsPerPage = 5;

  // Dispose controllers when the widget is disposed
  @override
  void dispose() {
    for (var input in inputs) {
      if (input['controller'] != null) {
        input['controller'].dispose();
      }
    }
    super.dispose();
  }

  // Method to validate the current page's inputs
  bool validateForm() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage) > inputs.length
        ? inputs.length
        : startIndex + itemsPerPage;
    List<Map<String, dynamic>> currentInputs =
        inputs.sublist(startIndex, endIndex);

    // Check if all fields on current page are filled
    for (var input in currentInputs) {
      if (input['value'] == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all the fields'),
          ),
        );
        return false;
      }
    }
    return true;
  }

    var Pprice = null;
  // Method to send data to the API
  Future<void> sendData() async {
    final url = Uri.parse('http://172.16.17.126:8000/predict/'); // Replace with your API endpoint
    // Prepare the JSON data
    final jsonData = {
      "Company": inputs[0]['value'],
      "Product": inputs[1]['value'],
      "TypeName": inputs[2]['value'],
      "Inches": int.tryParse(inputs[3]['value']) ?? 0, // Convert to int
      "Cpu": inputs[4]['value'],
      "Ram": inputs[5]['value'],
      "Memory": inputs[6]['value'],
      "Gpu": inputs[7]['value'],
      "OpSys": inputs[8]['value'],
      "Weight": double.tryParse(inputs[9]['value']) ?? 0.0, // Convert to double
      "screen_width": int.tryParse(inputs[10]['value']) ?? 0, // Convert to int
      "screen_height": int.tryParse(inputs[11]['value']) ?? 0, // Convert to int
      "touch_screen": inputs[12]['value'] == 'true', // Convert to bool
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData), // Encode the data to JSON
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success: ${response.body}'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                // Action to perform when the user presses the action button
              },
            ),
          ),
        );
        print('Response: ${response.body}'); 
        setState(() {
          Pprice = response.body;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send data: ${response.statusCode}'),
            duration: Duration(seconds: 3),
          ),
        );
        print('Failed to send data to API, status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errors: $e'),
          duration: Duration(seconds: 3),
        ),
      );
      print('ErrorLast: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get inputs for the current page
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage) > inputs.length
        ? inputs.length
        : startIndex + itemsPerPage;
    List<Map<String, dynamic>> currentInputs =
        inputs.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Render input fields for the current page
        ...currentInputs.map(
          (input) {
            if (input['type'] == 'bool') {
              // Render radio buttons for touch_screen
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    input['label'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'true',
                        groupValue: input['value'],
                        onChanged: (value) {
                          setState(() {
                            input['value'] = value;
                          });
                        },
                      ),
                      Text('True'),
                      Radio(
                        value: 'false',
                        groupValue: input['value'],
                        onChanged: (value) {
                          setState(() {
                            input['value'] = value;
                          });
                        },
                      ),
                      Text('False'),
                    ],
                  ),
                ],
              );
            } else {
              // Render TextField for other inputs
              return Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: input['label'],
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 235, 244, 247),
                        width: 1.7,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      input['value'] = value; // Update value of input
                    });
                  },
                  controller: input['controller']..text = input['value'], // Set initial value
                ),
              );
            }
          },
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentPage > 0) // Show previous button if not on the first page
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 11, 147, 189)),
                ),
                onPressed: () {
                  setState(() {
                    currentPage--;
                  });
                },
                child: const Text(
                  "Previous",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            const SizedBox(width: 20),
            // Show next button if not on the last page
            if (endIndex < inputs.length)
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 11, 147, 189)),
                ),
                onPressed: () {
                  if (validateForm()) {
                    setState(() {
                      currentPage++;
                    });
                  }
                },
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            // Show submit button if on the last page
            if (endIndex >= inputs.length)
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  if (validateForm()) {
                    sendData(); // Handle form submission
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
        const SizedBox(height: 30),

          Text(
            'Predicted Price: $Pprice',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}