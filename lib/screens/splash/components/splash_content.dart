import 'package:flutter/material.dart';

import '../../../constants.dart';

class SplashContent extends StatefulWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        ClipOval( // Wrap the Image.asset with ClipOval
          child: Image.asset(
            'assets/images/snapshop_logo.png', // Import the logo image
            height: 80, // Adjust the height of the logo as needed
            width: 80, // Adjust the width of the logo as needed
          ),
        ),
        const SizedBox(height: 20), // Add some space between logo and text
        const Text(
          "SnapShop",
          style: TextStyle(
            fontSize: 32,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.text!,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Image.asset(
          widget.image!,
          height: 265,
          width: 335,
        ),
      ],
    );
  }
}

