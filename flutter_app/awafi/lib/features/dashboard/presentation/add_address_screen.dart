import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:awafi/features/dashboard/domain/addAddress/add_address_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/addAddress/add_address_bloc.dart';
import '../bloc/address/address_bloc.dart';
import '../widgets/bottom_nav_bar.dart';

class AddAddressScreen extends StatefulWidget {

  AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController addressLine1Controller = TextEditingController();

  final TextEditingController addressLine2Controller = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController postalCodeController = TextEditingController();

  String selectedCountry = 'UAE';

  String selectedState = 'Abu Dhabi';

  String selectedCountryCode = '+971';  
  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      connectedPage: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,title: Text('Add Address')),
        body: BlocListener<AddAddressBloc, AddAddressState>(
          listener: (context, state) async {
            if (state is AddAddressUnauthorizedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Unauthorized. Please log in again.')),
              );
            } else if (state is AddAddressSuccessState) {
              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const BottomScreen(initialIndex: 1),
                ),
              );
            } else if (state is AddAddressErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: PopupMenuButton<String>(
                      initialValue: selectedCountryCode,
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(selectedCountryCode),
                        ],
                      ),
                      onSelected: (String value) {
                        setState(() {
                          selectedCountryCode = value;
                        });
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: '+971',
                          child: Text('+971'),
                        ),
                        PopupMenuItem(
                          value: '+91',
                          child: Text('+91'),
                        ),
                        PopupMenuItem(
                          value: '+966',
                          child: Text('+966'),
                        ),
                        PopupMenuItem(
                          value: '+44',
                          child: Text('+44'),
                        ),
                        PopupMenuItem(
                          value: '+1',
                          child: Text('+1'),
                        ),
                      ],
                    ),
                    hintText: 'Contact Number',
                    hintStyle: TextStyle(color: Colors.grey.shade800),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade800, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade800, width: 3),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: addressLine1Controller,
                  decoration: InputDecoration(
                    hintText: 'Address Line 1',
                    hintStyle: TextStyle(color: Colors.grey.shade800),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade800, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade800, width: 3),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: addressLine2Controller,
                  decoration: InputDecoration(
                    hintText: 'Address Line 2',
                    hintStyle: TextStyle(color: Colors.grey.shade800),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade800, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade800, width: 3),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: postalCodeController,
                  decoration: InputDecoration(
                    hintText: 'Pin Code',
                    hintStyle: TextStyle(color: Colors.grey.shade800),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade800, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade800, width: 3),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedCountry,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade800, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade800, width: 3),
                    ),
                  ),
                  items: ['UAE', 'Outside UAE'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedCountry = newValue;
                      if (newValue == 'Outside UAE') {
                        selectedState = 'Others';
                      }
                    }
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedState,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade800, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade800, width: 3),
                    ),
                  ),
                  items: [
                    'Abu Dhabi',
                    'Dubai',
                    'Sharjah',
                    'Ajman',
                    'Umm Al Quwain',
                    'Ras Al Khaimah',
                    'Fujairah',
                    'Others'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: selectedCountry == 'Outside UAE'
                      ? null
                      : (String? newValue) {
                          if (newValue != null) {
                            selectedState = newValue;
                          }
                        },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: BlocBuilder<AddAddressBloc, AddAddressState>(
            builder: (context, state) {
              if (state is AddAddressLoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF414851),
                ),
                onPressed: () async{
                  final address = AddAddressEntity(
                    addressLine1: addressLine1Controller.text,
                    addressLine2: addressLine2Controller.text,
                    city: selectedState,
                    postalCode: postalCodeController.text,
                    country: selectedCountry,
                  );
                  context
                      .read<AddAddressBloc>()
                      .add(AddAddressRequestEvent(address: address));
                      await Future.delayed(Duration(seconds: 2));
                     context
                      .read<GetAddressBloc>().add(FetchAddress());
                },
                child: Text(
                  'Add Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
