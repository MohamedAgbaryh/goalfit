import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Import for input formatting
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin
 {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isButtonActive = false;

  late AnimationController _animationController;
  late Animation<Offset> _textSlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late AnimationController _buttonRotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _buttonSlideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _buttonRotationController = AnimationController(
      duration: Duration(milliseconds: 500), // ✅ Fast rotation animation
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _buttonRotationController,
        curve: Curves.easeOutBack, // ✅ Smooth effect
      ),
    );

    Future.delayed(Duration(milliseconds: 300), () {
      _animationController.forward();
    });

    _usernameController.addListener(_validateInput);
    _passwordController.addListener(_validateInput);
  }

  void _validateInput() {
    bool wasActive = _isButtonActive;

    setState(() {
      String username = _usernameController.text;
      String password = _passwordController.text;

      bool isUsernameValid = RegExp(r"^[a-zA-Z]+$").hasMatch(username) &&
          username.length >= 3 &&
          username.length <= 12;

      bool isPasswordValid = RegExp(r"^[a-zA-Z0-9]+$").hasMatch(password) &&
          password.length >= 8 &&
          password.length <= 16;

      _isButtonActive = isUsernameValid && isPasswordValid;
    });

    // ✅ Trigger rotation only when button becomes active
    if (!wasActive && _isButtonActive) {
      _buttonRotationController.forward(from: 0);
    }
  }

  void _handleLogin() {
    if (!_isButtonActive) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      Navigator.pushNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Full-Screen Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Login Form Container
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Animated Welcome Text
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: Center(
                      child: Text(
                        "Welcome to GoalFit!",
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.7),
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // ✅ Username Field (Only Letters + Length Limit)
                  TextField(
                    controller: _usernameController,
                    style: GoogleFonts.poppins(fontSize: 20),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]")), // ✅ Only Letters (A-Z, a-z)
                      LengthLimitingTextInputFormatter(12), // ✅ Max Length: 12
                    ],
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.95),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.person, size: 28),
                    ),
                  ),
                  SizedBox(height: 15),

                  // ✅ Password Field (Min: 8, Max: 16, Letters & Numbers Only)
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: GoogleFonts.poppins(fontSize: 20),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]")), // ✅ Letters & Numbers Only
                      LengthLimitingTextInputFormatter(16), // ✅ Max Length: 16
                    ],
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.95),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.lock, size: 28),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          size: 26,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // ✅ Forgot Password Link
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password functionality
                      },
                      child: Text(
                        "Forgot your password?",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ✅ Animated Login Button (Rotates when Activated)
                  Center(
                    child: AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value * 2 * 3.1416, // ✅ 360° Rotation
                          child: ElevatedButton(
                            onPressed: _isButtonActive ? _handleLogin : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isButtonActive
                                  ? Colors.green.shade500 // ✅ Active (Green)
                                  : Colors.grey.shade700, // ❌ Inactive (Dark Grey)
                              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: _isButtonActive ? 8 : 2,
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
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
