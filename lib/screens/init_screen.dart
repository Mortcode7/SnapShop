import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapshop/constants.dart';
import 'package:snapshop/screens/favorite/claim_screen.dart';
import 'package:snapshop/screens/home/home_screen.dart';
import 'package:snapshop/screens/profile/profile_screen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  double _getAlignmentX(int index) {
    switch (index) {
      case 0: return -0.75;
      case 1: return -0.25;
      case 2: return 0.25;
      case 3: return 0.75;
      default: return -0.75;
    }
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  final pages = [
    const HomeScreen(),
    ClaimScreen(),
    const Center(
      child: Text("Chat"),
    ),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial for floating nav bar to blur content behind it
      body: pages[currentSelectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final segmentWidth = constraints.maxWidth / 4;
                  final dropWidth = 64.0;
                  final dropHeight = 48.0;
                  final targetLeft = (segmentWidth * currentSelectedIndex) + (segmentWidth / 2) - (dropWidth / 2);
                  final targetTop = (64.0 - dropHeight) / 2;

                  return SizedBox(
                    height: 64,
                    child: Stack(
                      children: [
                        // The animated water drop indicator
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.fastOutSlowIn, // Smooth fluid movement
                          left: targetLeft,
                          top: targetTop,
                          child: Container(
                            width: dropWidth,
                            height: dropHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24), // Pill shape
                              color: Colors.white.withOpacity(0.4), // Watery glass effect
                              border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                )
                              ]
                            ),
                          ),
                        ),
                        
                        // The actual icons
                        Row(
                          children: [
                            Expanded(
                              child: _NavBarItem(
                                icon: "assets/icons/Shop Icon.svg",
                                isSelected: currentSelectedIndex == 0,
                                onTap: () => updateCurrentIndex(0),
                              ),
                            ),
                            Expanded(
                              child: _NavBarItem(
                                icon: "assets/icons/Chat bubble Icon.svg",
                                isSelected: currentSelectedIndex == 1,
                                onTap: () => updateCurrentIndex(1),
                              ),
                            ),
                            Expanded(
                              child: _NavBarItem(
                                icon: "assets/icons/Heart Icon.svg",
                                isSelected: currentSelectedIndex == 2,
                                onTap: () => updateCurrentIndex(2),
                              ),
                            ),
                            Expanded(
                              child: _NavBarItem(
                                icon: "assets/icons/User Icon.svg",
                                isSelected: currentSelectedIndex == 3,
                                onTap: () => updateCurrentIndex(3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: SvgPicture.asset(
              icon,
              key: ValueKey<bool>(isSelected),
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.orange : const Color(0xFF778DA9),
                BlendMode.srcIn,
              ),
              height: 24,
              width: 24,
            ),
          ),
        ),
      ),
    );
  }
}
