import 'package:flutter/material.dart';
import 'package:self_bill/features/lincese/logic/getDeviceInfo.dart';
import 'package:self_bill/util/colors.dart';

class LicenseKeyScreen extends StatefulWidget {
  const LicenseKeyScreen({super.key});

  @override
  State<LicenseKeyScreen> createState() => _LicenseKeyScreenState();
}

class _LicenseKeyScreenState extends State<LicenseKeyScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _licenseKeyController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Future<void> _initLicenseKey() async {
    await generateLicenseKey(); // Await here to ensure execution
  }

  @override
  void initState() {
    super.initState();
    _initLicenseKey() ;

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
    // Await here to ensure execution
  }

  

  @override
  void dispose() {
    _fadeController.dispose();
    _licenseKeyController.dispose();
    super.dispose();
  }

  void _submitLicenseKey() {
    final key = _licenseKeyController.text.trim();
    verifyLicenseKey(context, key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: appGradient),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -80,
              child: CircleAvatar(
                  radius: 100, backgroundColor: Colors.white.withOpacity(0.2)),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: CircleAvatar(
                  radius: 120, backgroundColor: Colors.white.withOpacity(0.1)),
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter License Key',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _licenseKeyController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'License Key',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _submitLicenseKey,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Verify'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
