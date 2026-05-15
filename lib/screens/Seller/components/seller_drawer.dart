import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'product_edit.dart';
import '../seller_screen.dart';
import 'seller_profile_pic.dart';
class SellerDrawerScreen extends StatelessWidget {
  const SellerDrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),


            ),
             SellerProfilePic(),
            ]
          ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, SellerScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Product'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductEditScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle settings navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
