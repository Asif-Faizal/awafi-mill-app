// address_screen.dart
import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:awafi/features/dashboard/presentation/add_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/presentation/login_screen.dart';
import '../bloc/address/address_bloc.dart';
import '../domain/address/address_entity.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

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
        body: const AddressContent(),
      ),
    );
  }
}

class AddressContent extends StatelessWidget {
  const AddressContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAddressBloc, GetAddressState>(
      builder: (context, state) {
        print(state);
        if (state is AddressLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AddressLoaded) {
          return AddressDetails(address: state.address);
        }else if(state is AddressUnauthorized){
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
                          'You are not logged in. Please log in to continue.',
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
                                    builder: (context) => LoginScreen()),
                                (r) => false,
                              );
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        }
         else if (state is AddressNotFound) {
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
    );
  }
}

class AddressDetails extends StatelessWidget {
  final Address address;

  const AddressDetails({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: IntrinsicHeight(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Address Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Add your edit action here
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Add your delete action here
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Text('Address Line 1: ${address.addressLine1}',
                      style: _detailTextStyle),
                  const SizedBox(height: 8),
                  Text('Address Line 2: ${address.addressLine2}',
                      style: _detailTextStyle),
                  const SizedBox(height: 8),
                  Text('City: ${address.city}', style: _detailTextStyle),
                  const SizedBox(height: 8),
                  Text('Postal Code: ${address.postalCode}',
                      style: _detailTextStyle),
                  const SizedBox(height: 8),
                  Text('Country: ${address.country}', style: _detailTextStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle get _detailTextStyle =>
      const TextStyle(fontSize: 16, color: Colors.black);
}
