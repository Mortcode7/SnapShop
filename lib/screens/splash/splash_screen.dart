import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../components/default_button.dart';
import '../sign_in/sign_in_screen.dart';
import 'components/splash_content.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "title": "SNAPSHOP",
      "text": "Welcome to Snapshop\nYour Premium Shopping Experience",
      "image": "assets/images/BlueSplash1.png"
    },
    {
      "title": "CONNECT",
      "text": "Connecting You to Local Stores\nAcross Algeria",
      "image": "assets/images/BlueSplash2.png"
    },
    {
      "title": "CONVENIENCE",
      "text": "The Easiest Way to Shop\nFrom the Comfort of Your Home",
      "image": "assets/images/BlueSplash3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      itemCount: splashData.length,
                      itemBuilder: (context, index) => SplashContent(
                        image: splashData[index]["image"],
                        text: splashData[index]['text'],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              splashData.length,
                              (index) => AnimatedContainer(
                                duration: kAnimationDuration,
                                margin: const EdgeInsets.only(right: 5),
                                height: 8,
                                width: currentPage == index ? 24 : 8,
                                decoration: BoxDecoration(
                                  gradient: currentPage == index 
                                    ? kPrimaryGradientColor 
                                    : null,
                                  color: currentPage == index
                                      ? null
                                      : const Color(0xFFD8D8D8),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: currentPage == index ? [
                                    BoxShadow(
                                      color: kPrimaryColor.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ] : [],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 2),
                          DefaultButton(
                            text: "Continue",
                            press: () {
                              Navigator.pushNamed(
                                  context, SignInScreen.routeName);
                            },
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
