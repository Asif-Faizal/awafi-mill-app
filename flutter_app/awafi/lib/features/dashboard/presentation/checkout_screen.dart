import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:awafi/features/dashboard/data/stripe/stripe_service.dart';
import 'package:awafi/features/dashboard/domain/checkout/checkout_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/address/address_bloc.dart';
import '../bloc/checkout/checkout_bloc.dart';
import 'add_address_screen.dart';
import 'address_screen.dart';
import '../bloc/payment_intent/payment_intent_event.dart';
import '../bloc/payment_intent/payment_intent_state.dart';
import '../bloc/payment_intent/payment_intent_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen(
      {super.key, required this.amount, required this.cartItems});
  final double amount;
  final List<Map<String, dynamic>> cartItems;

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      connectedPage: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          leading: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Color(0xFF161A1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),
        body: BlocBuilder<GetAddressBloc, GetAddressState>(
          builder: (context, state) {
            if (state is AddressLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AddressLoaded) {
              return AddressDetails(address: state.address);
            } else if (state is AddressNotFound) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Image.asset('lib/core/assets/error.png'),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'No Address Found!!',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFF414851),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddAddressScreen()),
                              (r) => false,
                            );
                          },
                          child: Text(
                            'ADD ADDRESS',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is AddressError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            } else {
              return const Center(
                child: Text('Unexpected state. Please try again later.'),
              );
            }
          },
        ),
        bottomNavigationBar: BlocBuilder<GetAddressBloc, GetAddressState>(
          builder: (context, state) {
            if (state is AddressLoaded) {
              return BottomAppBar(
                color: Colors.transparent,
                child: BlocListener<PaymentIntentBloc, PaymentIntentState>(
                  listener: (context, paymentState) {
                    if (paymentState is PaymentIntentLoaded) {
                      StripeService.stripeService.makePayment(
                        context, 
                        amount.toInt(),
                        paymentState.secretKey,
                      );
                    } else if (paymentState is PaymentIntentError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(paymentState.message)),
                      );
                      print(paymentState.message);
                    }
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF414851),
                    ),
                    onPressed: () async {
                      // First get payment intent
                      context.read<PaymentIntentBloc>().add(GetPaymentIntent(
                          context: context, amount: amount.toInt()));

                      // Prepare checkout data
                      List<CheckoutProductEntity> checkoutProducts = cartItems
                          .map((item) => CheckoutProductEntity(
                                productId: item['product'],
                                variantId: item['variant'],
                                quantity: item['quantity'],
                              ))
                          .toList();
                      final address = (state).address;
                      
                      BlocProvider.of<CheckoutBloc>(context).add(
                        CheckoutInitiated(
                          CheckoutEntity(
                            amount: amount,
                            currency: 'AED',
                            paymentMethod: 'Stripe',
                            time: DateTime.now(),
                            products: checkoutProducts,
                            shippingAddress: CheckoutShippingAddress(
                              fullName: address.addressLine2,
                              addressLine1: address.addressLine1,
                              city: address.city,
                              postalCode: address.postalCode,
                              country: address.country,
                              phone: '7559913631',
                              addressLine2: address.addressLine2,
                            ),
                            transactionId: 'transactionId',
                            paymentStatus: "completed",
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'PAY AED $amount',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              );
            }
            // No bottom navigation bar if the address is not loaded.
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
