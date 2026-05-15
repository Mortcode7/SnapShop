import 'dart:ui';
import 'package:flutter/material.dart';

import 'components/categories.dart';
import 'components/discount_banner.dart';
import 'components/topbar.dart';
import 'components/popular_product.dart';
import 'components/Gender.dart';
import 'components/search_field.dart';
import 'package:snapshop/screens/search/search_results_screen.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  void _handleSearch(BuildContext context, String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(query: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient for the glassy effect to be visible
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0E1DD), Color(0xFFF4F5F7), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Abstract shapes for extra glassmorphism feel
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF415A77).withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withOpacity(0.08),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const TopBar(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SearchField(
                        onSearch: (query) => _handleSearch(context, query)),
                  ),
                  const SizedBox(height: 20),
                  const DiscountBanner(),
                  const Categories(),
                  const Gender(),
                  const SizedBox(height: 20),
                  const PopularProducts(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
