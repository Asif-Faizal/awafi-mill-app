import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/userData/user_data_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.phone});
  final String name;
  final String email;
  final int phone;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
          body: BlocConsumer<UserProfileBloc, UserProfileState>(
            listener: (context, state) {
              if (state is UserEditSuccess) {
                BlocProvider.of<UserProfileBloc>(context).add(FetchUserProfile());
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(5)),
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 2,
                            child: Center(
                              child: Icon(
                                Icons.person_outlined,
                                size: 100,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Color(0xFF161A1E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x26161A1E),
                        labelText: 'Name',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x26161A1E),
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x26161A1E),
                        labelText: 'Phone',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 40),
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
                          BlocProvider.of<UserProfileBloc>(context)
                              .add(EditUserDataEvent(
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: int.parse(_phoneController.text),
                          ));
                        },
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          )),
    );
  }
}
