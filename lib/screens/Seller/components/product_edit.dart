import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductEditScreen extends StatefulWidget {
  static const String routeName = "/product_edit";

  const ProductEditScreen({super.key});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 10,),
              const TextField(
                decoration: InputDecoration(labelText: 'Brand'),
              ),
              const SizedBox(height: 10,),
              const TextField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 10,),
              const TextField(
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 10,),
              const TextField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Image:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _imageFile != null
                        ? Image.file(
                      _imageFile!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                        : ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Add Image'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}