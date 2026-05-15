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
        Image.asset(
          widget.image!,
          height: 334,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.text!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: kSecondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

