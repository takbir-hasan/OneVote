import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _iconSize = 100;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Icon Animation Timer
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _iconSize = 150; // Animate the size of the icon
      });
    });

    // Navigation Timer
    Timer(const Duration(seconds: 7), () {
      Navigator.pushReplacementNamed(context, "/home");
    });

    // Background Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlue.shade300,
                  Colors.lightBlue.shade700,
                  Colors.lightBlue.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.3 + (_controller.value * 0.2),
                  0.6,
                  1.0 - (_controller.value * 0.2)
                ],
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.bounceOut,
                height: _iconSize,
                width: _iconSize,
                child: ClipOval(
                  child: Image.network(
                    "https://t4.ftcdn.net/jpg/00/98/13/07/240_F_98130729_qrnp9xLPOz10pV9H8zA3EygX0OoCrV2Y.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const AnimatedOpacity(
                opacity: 1,
                duration: Duration(seconds: 2),
                child: Column(
                  children: [
                    Text(
                      "OneVote",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Simplifying Elections",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
