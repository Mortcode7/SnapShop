import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../globals.dart' as globals; // Import the globals.dart file

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../forgot_password/forgot_password_screen.dart';
import '../../login_success/login_success_screen.dart';
import '../../seller/seller_screen.dart'; // Import SellerScreen

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  bool _obscureText = true; // Variable to track password visibility
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: _obscureText, // Bind to obscureText property
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,color: kSecondaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Toggle password visibility
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);

                // Send sign-in request to PHP endpoint
                var response = await http.post(
                  Uri.parse('http://192.168.1.5/signin.php'), // Use your IP address
                  body: {
                    'email': email!,
                    'password': password!,
                  },
                );

                // Handle response
                if (response.statusCode == 200) {
                  String responseBody = response.body.trim(); // Trim any extra whitespace

                  if (responseBody.startsWith('error:')) {
                    // Sign-in failed, show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(responseBody.substring(6))),
                    );
                  } else {
                    List<String> parts = responseBody.split(',');
                    int userId = int.parse(parts[0]);
                    String acctype = parts[1];

                    globals.userId = userId;
                    globals.acctype = acctype;  // Use global variable if needed
                    print("User ID: $userId");
                    print("Account Type: $acctype");

                    if (acctype == 'store') {
                      Navigator.pushNamed(context, SellerScreen.routeName);
                    } else {
                      Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                    }
                  }
                } else {
                  // Error in connection to server
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to connect to server')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
