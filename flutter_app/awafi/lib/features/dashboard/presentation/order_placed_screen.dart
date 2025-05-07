import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:awafi/features/dashboard/bloc/cart/cart_bloc.dart';
import 'package:awafi/features/dashboard/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      connectedPage: Scaffold(backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your order has been placed successfully!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF414851),
                ),
                onPressed: () {
                  BlocProvider.of<CartBloc>(context).add(FetchCartItems());
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomScreen(initialIndex: 0,)),(_) => false);// For example, navigate back
                },
                child: const Text(
                  'GO TO HOME',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
