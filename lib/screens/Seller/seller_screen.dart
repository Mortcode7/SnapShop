import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/product_list_screen.dart';
import 'components/seller_homepage.dart';
import 'components/product_edit.dart';
import 'components/seller_drawer.dart'; // Import the drawer

class SellerScreen extends StatelessWidget {
  static String routeName = "/seller";
  const SellerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home, color: kPrimaryLightColor)),
              Tab(icon: Icon(Icons.shop, color: kPrimaryLightColor)),
              Tab(icon: Icon(Icons.notifications, color: kPrimaryLightColor)),
            ],
          ),
          title: const Text(
            'Store',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: const TabBarView(
          children: [
            
            ProductListScreen(),
            ProductListScreen(),
            Icon(Icons.notifications, size: 220, color: kPrimaryColor),
          ],
        ),
        drawer: const SellerDrawerScreen(), // Use the SellerDrawer here
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.add, color: kPrimaryLightColor),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductEditScreen()));
          },
        ),
      ),
    );
  }
}
