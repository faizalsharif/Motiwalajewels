import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motiwalajewels/global.dart';
import 'check_internet.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () => swithScreenReplacement(context, const InternetConnection()),
    );
    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/motiwalalogo.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Added alignment
                children: [
                  const SizedBox(height: 600),
                  Lottie.asset(
                    'assets/images/motiwalajewels.json',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  // Percentage Counter
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: 100,
                    ), // Changed end to 100 for a full percentage
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    },
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
