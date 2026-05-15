import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import '../../../globals.dart' as globals;

class ProductEditScreen extends StatefulWidget {
  static const String routeName = "/product_edit";
  final Map<String, dynamic> product;

  const ProductEditScreen({super.key, required this.product});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  List<File> _imageFiles = [];
  String? productName;
  String? brand;
  String? description;
  String? gender;
  String? price;
  List<String> _existingImages = []; // Store existing image URLs
  List<File> _newImages = []; // Store newly added images

  @override
  void initState() {
    super.initState();
    productName = widget.product['name'];
    brand = widget.product['brand'];
    description = widget.product['description'];
    gender = widget.product['gender'];
    price = widget.product['price'].toString();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      if (pickedFiles != null) {
        _imageFiles
            .addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
      }
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int userId = globals.userId ?? 0;

      var uri = Uri.parse("http://192.168.1.5/update_product.php");
      var request = http.MultipartRequest("POST", uri);

      request.fields['id'] = widget.product['id'].toString();
      request.fields['name'] = productName!;
      request.fields['brand'] = brand!;
      request.fields['description'] = description!;
      request.fields['gender'] = gender!;
      request.fields['price'] = price!;
      request.fields['user_id'] = userId.toString();

      for (var image in _imageFiles) {
        request.files.add(await http.MultipartFile.fromPath(
          'images[]',
          image.path,
          filename: basename(image.path),
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
            SnackBar(content: Text('Product updated successfully!')));
      } else {
        ScaffoldMessenger.of(_formKey.currentContext!)
            .showSnackBar(SnackBar(content: Text('Failed to update product.')));
      }
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: productName,
                  onSaved: (newValue) => productName = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {});
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Product name is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    hintText: "Enter product's name",
                    suffixIcon:
                        Icon(Icons.local_grocery_store, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: brand,
                  onSaved: (newValue) => brand = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {});
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Brand name is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Brand',
                    hintText: "Enter brand",
                    suffixIcon: Icon(Icons.business, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: description,
                  onSaved: (newValue) => description = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {});
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Description is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: "Enter description",
                    suffixIcon: Icon(Icons.description, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: gender,
                  onSaved: (newValue) => gender = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {});
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Gender is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    hintText: "male or female",
                    suffixIcon: Icon(Icons.directions_walk, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: price,
                  onSaved: (newValue) => price = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {});
                    }
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The Price is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: "The price should be in DA",
                    suffixIcon: Icon(Icons.monetization_on, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Images:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _imageFiles.isNotEmpty
                          ? Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: _imageFiles.map((imageFile) {
                                return Stack(
                                  children: [
                                    Image.file(
                                      imageFile,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            _imageFiles.remove(imageFile);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            )
                          : ElevatedButton(
                              onPressed: _pickImages,
                              child: const Text('Add Images'),
                            ),
                      const SizedBox(height: 10),
                      if (_imageFiles.isNotEmpty)
                        ElevatedButton(
                          onPressed: _pickImages,
                          child: const Text('Add More Images'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
