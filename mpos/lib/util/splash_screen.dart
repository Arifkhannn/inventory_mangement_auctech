import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:self_bill/features/auth/logic/auth_fuction.dart';
import 'package:self_bill/features/auth/presentation/auth_screen.dart';
import 'package:self_bill/features/home/presentation/home-screen.dart';
import 'package:self_bill/features/lincese/presentation/license_screen.dart';
import 'package:self_bill/util/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:self_bill/util/colors.dart';
import 'package:self_bill/util/animation_route.dart';
// Your next screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();

    // Animate background gradient
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _color1 = ColorTween(
      begin: Colors.white,
      end: appGradient.colors[0],
    ).animate(_controller);

    _color2 = ColorTween(
      begin: Colors.white,
      end: appGradient.colors[1],
    ).animate(_controller);

    _controller.forward();

    _navigateBasedOnPrefs();
  }

  Future<void> _navigateBasedOnPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool welcomeShown = prefs.getBool('welcome_shown') ?? false;
    bool licVerify = prefs.getBool('licValid') ?? false;
    await Future.delayed(const Duration(seconds: 4));
    User? user = FirebaseAuth.instance.currentUser;

    if (welcomeShown && user != null && licVerify) {
      
      Navigator.of(context).pushReplacement(
        createBookToFadeRoute(MyWidget()),
      );
    } else if (!welcomeShown) {
      
      Navigator.of(context).pushReplacement(
        createBookToFadeRoute(WelcomeScreen()),
      );
    } else if (user == null) {
     
      Navigator.of(context).pushReplacement(
        createBookToFadeRoute(ModernSignInScreen()),
      );
    } else {
      
      Navigator.of(context).pushReplacement(
        createBookToFadeRoute(LicenseKeyScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _color1.value ?? Colors.white,
                  _color2.value ?? Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.yellowAccent,
                period: const Duration(milliseconds: 1200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 160,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/indiagate2.png',
                        width: 180,
                      ),
                    ),
                    const SizedBox(height: 300),
                    const Text(
                      "Developed by AUCTECH",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
