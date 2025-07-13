import 'package:flutter/material.dart';
import 'package:self_bill/features/auth/presentation/auth_screen.dart';
import 'package:self_bill/util/colors.dart';

import 'package:self_bill/features/home/presentation/home-screen.dart';
import 'package:self_bill/util/onboard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToNext() async{
    if (currentIndex < onboardingPages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
     
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcome_shown', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ModernSignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        decoration: const BoxDecoration(gradient: appGradient ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingPages.length,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final page = onboardingPages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity:
                              0.8, // Set between 0.0 (fully transparent) and 1.0 (fully visible)
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              page.image,
                              width: 350,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                            
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            page.description,
                            style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white70,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            page.description2 ?? '',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              color: Colors.yellow,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingPages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: currentIndex == index ? 12 : 8,
                    height: currentIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color:
                          currentIndex == index ? Colors.white : Colors.white54,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: goToNext,
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: const Color.fromARGB(255, 255, 247, 29),
                    foregroundColor: appGradient.colors.first,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    currentIndex == onboardingPages.length - 1
                        ? "Get Started"
                        : "Next",
                    style:
                        const TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
