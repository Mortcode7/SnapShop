import 'package:flutter/material.dart';

import 'package:snapshop/screens/seller/components/seller_homepage.dart';
class SellerHomepageScreen extends StatelessWidget {
  static String routeName = "/SellerHomepageScreen";
  const SellerHomepageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.flight)),
              Tab(icon: Icon(Icons.flight_class_sharp)),
              Tab(icon: Icon(Icons.flight_class)),
            ],
          ),
          title: const Text('Store'), // Wrap text in quotes to make it a string
        ),
        body: const TabBarView(
          children:[
            Icon(Icons.flight,size: 220,),
            Icon(Icons.flight_class_sharp,size: 220,),
            Icon(Icons.flight_class, size: 220,),
          ],
        ),
      ),
    );
  }
}
