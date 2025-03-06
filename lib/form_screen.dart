import 'package:flutter/material.dart';
import 'api_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key}); // Key parameter

  @override
  // ignore: library_private_types_in_public_api
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  final ApiService _apiService = ApiService();
  String? _responseMessage;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final response = await _apiService.submitData(_name!, _email!);
        setState(() {
          _responseMessage = 'Data submitted successfully: ${response['name']} - ${response['email']}';
        });
      } catch (e) {
        setState(() {
          _responseMessage = 'Error: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
          child: const Text(
            'Submit Form',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Colors.yellow[700], // A darker shade of yellow
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.yellow.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter Your Details',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) => _name = value,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.yellow[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ), // Match the AppBar color
                          ),
                          child: const Text('Submit'),
                        ),
                        if (_responseMessage != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            _responseMessage!,
                            style: TextStyle(
                              color: _responseMessage!.contains('Error') ? Colors.red : Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.yellow),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.yellow, width: 2),
        ),
        filled: true,
        fillColor: Colors.yellow.shade50, // Light yellow background
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}