import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapshop/constants.dart';
import 'package:snapshop/screens/favorite/favorite_screen.dart';
import 'package:snapshop/screens/home/home_screen.dart';
import 'package:snapshop/screens/profile/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }


  final pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const Center(
      child: Text("Chat"),
    ),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        onTap: updateCurrentIndex,
        index: currentSelectedIndex,
        color: kOrangeColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          SvgPicture.asset(
            "assets/icons/Shop Icon.svg",
            color: Colors.white,

          ),
          SvgPicture.asset(
            "assets/icons/Heart Icon.svg",
            color: Colors.white,
          ),
          SvgPicture.asset(
            "assets/icons/Chat bubble Icon.svg",
            color: Colors.white,
          ),
          SvgPicture.asset(
            "assets/icons/User Icon.svg",
            color: kPrimaryLightColor,
          ),
        ],
      ),
    );
  }
}
