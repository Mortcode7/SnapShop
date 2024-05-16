import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/seller_homepage.dart';
import 'components/product_edit.dart';
class SellerScreen extends StatelessWidget {
  static String routeName = "/seller";
  const SellerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:kPrimaryColor,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.flight, color: kPrimaryLightColor)),
              Tab(icon: Icon(Icons.flight_class_sharp,color: kPrimaryLightColor)),
              Tab(icon: Icon(Icons.flight_class,color: kPrimaryLightColor)),
            ],
          ),
            title: const Text(
              'Store',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white,),

            ),
        ),
        body: const TabBarView(
          children:[
            SellerHomepageScreen(),
            Icon(Icons.flight,size: 220,color: kPrimaryColor),
            Icon(Icons.flight_class, size: 220,color: kPrimaryColor),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor:kPrimaryColor,
          child :const Icon(Icons.add,color:kPrimaryLightColor ,),
          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProductEditScreen()));},
        ),
      ),
    );
  }
}

