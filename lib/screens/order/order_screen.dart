import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../globals.dart';

class OrderScreen extends StatefulWidget {
  static String routeName = "/order";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? firstname;
  String? lastname;
  String? address;
  String? phonenumber;
  List<int> productIds = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as List<int>;
    productIds = args;
  }

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        var response = await http.post(
          Uri.parse('http://192.168.1.5/create_order.php'),
          body: jsonEncode({
            'name': name,
            'firstname': firstname,
            'lastname': lastname,
            'address': address,
            'phonenumber': phonenumber,
            'client_id': userId,
            'product_ids': productIds
          }),
          headers: {'Content-Type': 'application/json'},
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order placed successfully')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'Failed to place order')),
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
        title: Text('Place Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Name'),
              //   onSaved: (newValue) => name = newValue,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter your name';
              //     }
              //     return null;
              //   },
              // ),
              // const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (newValue) => firstname = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (newValue) => lastname = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (newValue) => address = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                onSaved: (newValue) => phonenumber = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOrder,
                child: Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../globals.dart';

// class OrderScreen extends StatefulWidget {
//   static String routeName = "/order";

//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? name;
//   String? firstname;
//   String? lastname;
//   String? address;
//   String? phonenumber;
//   List<int> productIds = [];

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args = ModalRoute.of(context)!.settings.arguments as List<int>;
//     productIds = args;
//   }

//   void _submitOrder() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       try {
//         var response = await http.post(
//           Uri.parse('http://192.168.1.5/create_order.php'),
//           body: jsonEncode({
//             'name': name,
//             'firstname': firstname,
//             'lastname': lastname,
//             'address': address,
//             'phonenumber': phonenumber,
//             'client_id': userId,
//             'product_ids': productIds
//           }),
//           headers: {'Content-Type': 'application/json'},
//         );

//         print('Response status: ${response.statusCode}');
//         print('Response body: ${response.body}');

//         if (response.statusCode == 200) {
//           final result = jsonDecode(response.body);
//           if (result['status'] == 'success') {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Order placed successfully')),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                   content: Text(result['message'] ?? 'Failed to place order')),
//             );
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Server error: ${response.statusCode}')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Place Order'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Name'),
//                 onSaved: (newValue) => name = newValue,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'First Name'),
//                 onSaved: (newValue) => firstname = newValue,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your first name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Last Name'),
//                 onSaved: (newValue) => lastname = newValue,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your last name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Address'),
//                 onSaved: (newValue) => address = newValue,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your address';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//                 onSaved: (newValue) => phonenumber = newValue,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitOrder,
//                 child: Text('Place Order'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
