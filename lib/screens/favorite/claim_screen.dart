import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../globals.dart' as globals;

class ClaimScreen extends StatefulWidget {
  static String routeName = "/claim";

  @override
  _ClaimScreenState createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> {
  final _formKey = GlobalKey<FormState>();
  String? storeName;
  String? message;

  void _submitClaim() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        var response = await http.post(
          Uri.parse('http://192.168.1.5/create_claim.php'),
          body: {
            'user_id': globals.userId.toString(),
            'store_name': storeName!,
            'message': message!,
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final result = response.body;
          if (result == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Claim sent successfully')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to send claim')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Claim'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Store Name'),
                onSaved: (newValue) => storeName = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter store name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Message'),
                onSaved: (newValue) => message = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitClaim,
                child: const Text('Submit Claim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
