import 'package:flutter/material.dart';

class NetworkErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: Image.asset('lib/core/assets/no-internet.png'),
            ),
            SizedBox(height: 20,),
            Text(
                        'Oops!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),SizedBox(height: 10,),
            Text(
                        'No internet connection found.\nCheck your connections and start again',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
          ],
        ),
      ),
    );
  }
}