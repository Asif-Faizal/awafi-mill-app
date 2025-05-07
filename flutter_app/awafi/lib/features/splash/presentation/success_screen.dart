import 'package:flutter/material.dart';

class SucessLastScreen extends StatelessWidget {
  final String text;
  final String heading;
  final String buttonText;
  final VoidCallback onPressed;
  
  const SucessLastScreen(
      {super.key,
      required this.text,
      required this.buttonText,
      required this.onPressed, required this.heading});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center( // Wraps everything in the center
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensures content doesn't stretch the screen
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('lib/core/assets/success.png'),
              SizedBox(height: 30),
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenHeight * 0.028,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenHeight * 0.016,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF414851),
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
