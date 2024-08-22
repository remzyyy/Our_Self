import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(ContactFormApp());
}

class ContactFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactFormScreen(),
    );
  }
}

class ContactFormScreen extends StatefulWidget {
  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  String _selectedGender = 'Male';
  final _ageController = TextEditingController();
  XFile? _selfieImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Form'),
      ),
      body: Container(
        color: Color.fromARGB(255, 12, 234, 145), // Set the background color here
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gender Selection
            Text('Select your gender:'),
            DropdownButton<String>(
              value: _selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              items: <String>['Male', 'Female', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),

            // Age Input
            Text('Enter your age:'),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Age',
              ),
            ),
            SizedBox(height: 16.0),

            // Upload Selfie Button
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Selfie'),
            ),

            // Display the uploaded selfie
            if (_selfieImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.file(
                  File(_selfieImage!.path),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

            SizedBox(height: 24.0),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selfieImage = pickedFile;
    });
  }

  // Method to handle form submission
  void _submitForm() {
    String age = _ageController.text;
    if (age.isEmpty || _selfieImage == null) {
      _showDialog('Please fill all the fields and upload a selfie.');
      return;
    }

    // Handle form data (e.g., send it to a server)
    print('Gender: $_selectedGender');
    print('Age: $age');
    print('Selfie path: ${_selfieImage!.path}');

    // Show confirmation
    _showDialog('Form submitted successfully!');
  }

  // Method to show a dialog with a message
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
