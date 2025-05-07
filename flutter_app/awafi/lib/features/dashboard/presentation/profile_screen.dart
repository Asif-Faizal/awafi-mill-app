import 'package:awafi/features/connection/widgets/connectivity_wrapper.dart';
import 'package:awafi/features/dashboard/presentation/edit_profile_screen.dart';
import 'package:awafi/features/login/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/userData/user_data_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserProfileBloc _userProfileBloc;

  @override
  void initState() {
    super.initState();
    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    _userProfileBloc.add(FetchUserProfile());
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
          ),),
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          bloc: _userProfileBloc,
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserProfileLoaded) {
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
                      controller: TextEditingController(text: state.userProfile.name),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x26161A1E),
                        labelText: 'Name',enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),focusedBorder:  OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                      
                      ), readOnly: true, 
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: TextEditingController(text: state.userProfile.email),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x26161A1E),
                        labelText: 'Email',enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),focusedBorder:  OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                      
                      ),
                      readOnly: true, // Read-only field
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: TextEditingController(text: state.userProfile.phone.toString()),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x26161A1E),
                        labelText: 'Phone',enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),focusedBorder:  OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                      
                      ), readOnly: true, 
                    ),SizedBox(height: 40,),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen(name: state.userProfile.name,email: state.userProfile.email,phone: state.userProfile.phone,)));
                          },
                          child: Text(
                            'EDIT PROFILE',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),SizedBox(height: 20,),
                    SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),side: BorderSide(
          color: Color(0xFF414851), // Border color
          width: 2, // Border width
        ),
                            ),
                            foregroundColor:  Color(0xFF414851),
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                          },
                          child: Text(
                            'DELETE PROFILE',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is UserProfileUnauthorized) {
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
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'You are not logged in. Please log in to continue.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
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
                              MaterialPageRoute(builder: (context) => LoginScreen()),
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
            } else if (state is UserProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Center(
                child: Column(
                  children: [
                    Text('No data available.'),
                    ElevatedButton(
                      onPressed: () {
                        _userProfileBloc.add(FetchUserProfile());
                      },
                      child: Text('Fetch Data'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
