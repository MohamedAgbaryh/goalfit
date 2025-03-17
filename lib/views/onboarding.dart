import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  double _opacity = 0.0;
  double _progress = 0.0;

  late AnimationController _animationController;
  late Animation<Offset> _textSlideAnimation;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/onboarding1.jpg",
      "title": "Track Your Progress",
      "description": "Monitor your fitness journey with GoalFit and stay motivated."
    },
    {
      "image": "assets/images/onboarding2.jpg",
      "title": "Set & Achieve Goals",
      "description": "Create personalized fitness goals and crush them step by step!"
    },
    {
      "image": "assets/images/onboarding3.jpg",
      "title": "Join the Community",
      "description": "Connect with like-minded individuals and get inspired daily."
    }
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        _opacity = 1.0;
      });
      _animationController.forward();
    });
  }

  void _goToNextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      setState(() {
        _opacity = 0.0;
      });

      Future.delayed(Duration(milliseconds: 300), () {
        _pageController.nextPage(duration: Duration(milliseconds: 130), curve: Curves.ease);
        setState(() {
          _opacity = 1.0;
        });

        _animationController.reset();
        _animationController.forward();
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ PageView with Progress Bar + Zoom
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _progress = index / (_onboardingData.length - 1/3); // ✅ Fixed Progress Bar Calculation
                _opacity = 0.0;
              });

              Future.delayed(Duration(milliseconds: 150), () {
                setState(() {
                  _opacity = 1.0;
                });

                _animationController.reset();
                _animationController.forward();
              });
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double zoom = 1.0;

                  if (_pageController.position.haveDimensions) {
                    double pageOffset = _pageController.page! - index;
                    zoom = (1 - (pageOffset.abs() * 0.2)).clamp(0.8, 1.3); // ✅ Fixed Zoom Effect
                  }

                  return Stack(
                    children: [
                      // ✅ Background Image with Zoom Effect
                      Positioned.fill(
                        child: Center(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 180),
                            curve: Curves.fastOutSlowIn,
                            width: MediaQuery.of(context).size.width * zoom,
                            height: MediaQuery.of(context).size.height * zoom,
                            child: Image.asset(
                              _onboardingData[index]["image"]!,
                              fit: BoxFit.cover,
                              alignment: index == 0 || index == 2 ? Alignment(0.0, -0.6) : Alignment.center,
                            ),
                          ),
                        ),
                      ),

                      // ✅ Dark Overlay for Readability
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),

                      // ✅ Animated Text (Slide-Up + Fade-In)
                      Positioned(
                        bottom: 150,
                        left: 30,
                        right: 30,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: _opacity,
                          child: SlideTransition(
                            position: _textSlideAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _onboardingData[index]["title"]!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(blurRadius: 10.0, color: Colors.black.withOpacity(0.7), offset: Offset(2, 2)),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _onboardingData[index]["description"]!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(blurRadius: 5.0, color: Colors.black.withOpacity(0.5), offset: Offset(1, 1)),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // ✅ Smooth Progress Bar
          Positioned(
            bottom: 100,
            left: 30,
            right: 30,
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey.shade700,
              color: Colors.green.shade600,
              minHeight: 5,
            ),
          ),

          // ✅ Animated Buttons
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _opacity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      "Skip",
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white.withOpacity(0.8)),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: _goToNextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _currentIndex == _onboardingData.length - 1 ? "Get Started" : "Next",
                      style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
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
