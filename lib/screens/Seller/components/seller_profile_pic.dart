import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class SellerProfilePic extends StatefulWidget {
  const SellerProfilePic({Key? key}) : super(key: key);

  @override
  _SellerProfilePicState createState() => _SellerProfilePicState();
}

class _SellerProfilePicState extends State<SellerProfilePic> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!)
                : const AssetImage("assets/images/snapshop_logo.png") as ImageProvider,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 36,
              width: 36,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: _pickImage,
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
