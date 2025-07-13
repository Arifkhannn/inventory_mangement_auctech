import 'package:flutter/material.dart';
import 'package:self_bill/features/auth/logic/auth_fuction.dart';
import 'package:self_bill/features/auth/widget/sbackbar.dart';
import 'package:self_bill/features/home/presentation/home-screen.dart';
import 'package:self_bill/features/lincese/presentation/license_screen.dart';
import 'package:self_bill/util/colors.dart';

class ModernSignInScreen extends StatefulWidget {
  const ModernSignInScreen({super.key});

  @override
  _ModernSignInScreenState createState() => _ModernSignInScreenState();
}

class _ModernSignInScreenState extends State<ModernSignInScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _authService.loginWithEmail(
          _emailController.text, _passwordController.text);
      showTopSnackbar(context, 'logged in!');

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LicenseKeyScreen()),
          (Route<dynamic> route) => false);
    } catch (e, stack) {
      print(stack);
      showTopSnackbar(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _authService.signUpWithEmail(
          _emailController.text, _passwordController.text);
      showTopSnackbar(context, 'successfully signed-up!');
    } catch (e) {
      showTopSnackbar(context, 'Error:$e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _googleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _authService.signInWithGoogle();
      showTopSnackbar(context, 'Google sign-in successful!');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LicenseKeyScreen()),
          (Route<dynamic> route) => false);
    } catch (e) {
      showTopSnackbar(context, 'Google sign-In Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: appGradient),
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Welcome!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Login to continue',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildInputField(
                            _emailController, 'Email', Icons.email),
                        const SizedBox(height: 20),
                        _buildInputField(
                            _passwordController, 'Password', Icons.lock,
                            obscureText: true),
                        const SizedBox(height: 30),
                        _buildButton('Login', _login),
                        const SizedBox(height: 10),
                        _buildButton('Sign Up', _signUp, outlined: true),
                        const SizedBox(height: 20),
                        const Text('OR',
                            style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 10),
                        _buildGoogleButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String hint, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed,
      {bool outlined = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed, // disable when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: outlined ? Colors.transparent : Colors.white,
          foregroundColor: outlined ? Colors.white : Colors.deepPurple,
          side: outlined
              ? const BorderSide(color: Colors.white)
              : BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: outlined ? 0 : 4,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              )
            : Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _googleSignIn,
        icon: Image.asset('assets/google_icon.png',
            height: 24), // add your google icon asset
        label: const Text('Sign in with Google'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
