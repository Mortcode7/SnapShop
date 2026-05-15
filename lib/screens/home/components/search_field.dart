import 'dart:ui';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final Function(String) onSearch;

  const SearchField({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Form(
            child: TextFormField(
              onFieldSubmitted: (value) => onSearch(value),
              style: const TextStyle(color: Color(0xFF0D1B2A)),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // reduced vertical padding to make it thinner
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Search products...",
                hintStyle: TextStyle(color: Color(0xFF778DA9)),
                prefixIcon: Icon(Icons.search, color: Colors.orange, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
