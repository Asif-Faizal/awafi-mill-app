import 'package:awafi/features/dashboard/widgets/bottom_nav_bar.dart';
import 'package:awafi/features/login/presentation/forgot_password_screen.dart';
import 'package:awafi/features/signup/presentation/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard/bloc/address/address_bloc.dart';
import '../../notification/bloc/notification_bloc.dart';
import '../../signup/cubit/password_visibility_cubit.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login_input/login_input_bloc.dart';
import '../data/input_type/input_type_model.dart';
import '../data/login/login_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? emailErrorMessage;
  String? passwordErrorMessage;
  String? numberErrorMessage;

  void _scrollToFocusedField(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      // Delay to wait for the keyboard to open
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.pixels +
              MediaQuery.of(context).size.height / 4,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(() => _scrollToFocusedField(_emailFocusNode));
    _numberFocusNode.addListener(() => _scrollToFocusedField(_numberFocusNode));
    _passwordFocusNode
        .addListener(() => _scrollToFocusedField(_passwordFocusNode));
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _numberFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateNumber(String value) {
    if (value.isEmpty) {
      return 'Number is required';
    }
    if (value.length < 10) {
      return 'Mobile Number must be 10 digits';
    }
    if (value.length > 10) {
      return 'Mobile Number is too long';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile Number must contain only digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordVisibilityCubit(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) async {
              if (state is LoginSuccessState) {
                // Store the email in SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                if (state.inputType == InputType.email) {
                  await prefs.setString('last_login_email', emailController.text);
                } else {
                  await prefs.setString('last_login_email', phoneNumberController.text);
                }
                
                context.read<GetAddressBloc>().add(FetchAddress());
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BottomScreen()),
                    (r) => false);
                context.read<NotificationBloc>().add(InitializeNotifications());
                getCountryOfResidence();
              } else if (state is LoginErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    content: Text(state.message)));
              }
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: BlocBuilder<LoginInputBloc, LoginInputState>(
                builder: (context, state) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 320,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Image.asset(
                                  'lib/core/assets/logo.png',
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(height: 20),
                                Image.asset(
                                  'lib/core/assets/app_name.png',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                color: Color(0xFF161A1E),
                              ),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22, vertical: 25),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Login',
                                        style: GoogleFonts.mulish(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 36,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      BlocBuilder<LoginInputBloc,
                                          LoginInputState>(
                                        builder: (context, state) {
                                          if (state.inputType ==
                                              InputType.email) {
                                            return TextFormField(
                                              focusNode: _emailFocusNode,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                hintText: 'Email',
                                                hintStyle: TextStyle(
                                                    color: Colors.white),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 3),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 3),
                                                ),
                                                errorText: emailErrorMessage,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (state.inputType ==
                                                      InputType.email) {
                                                    emailErrorMessage =
                                                        _validateEmail(value);
                                                  } else {
                                                    numberErrorMessage =
                                                        _validateNumber(value);
                                                  }
                                                });
                                              },
                                            );
                                          } else if (state.inputType ==
                                              InputType.phone) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 90,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                  ),
                                                  child: DropdownButton<String>(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerStart,
                                                    underline: SizedBox(),
                                                    value: state.countryCode,
                                                    onChanged:
                                                        (String? newValue) {
                                                      if (newValue != null) {
                                                        context
                                                            .read<
                                                                LoginInputBloc>()
                                                            .add(
                                                                ChangeCountryCode(
                                                                    newValue));
                                                      }
                                                    },
                                                    items: <String>[
                                                      '+1',
                                                      '+44',
                                                      '+91',
                                                    '+971',
                                                    '+966',
                                                    ]
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                          (String value) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    dropdownColor:
                                                        Color(0xFF161A1E),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: TextFormField(
                                                    focusNode: _numberFocusNode,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        numberErrorMessage =
                                                            _validateNumber(
                                                                value);
                                                      });
                                                    },
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    controller:
                                                        phoneNumberController,
                                                    decoration: InputDecoration(
                                                      errorText:
                                                          numberErrorMessage,
                                                      hintText: 'Phone Number',
                                                      hintStyle: TextStyle(
                                                          color: Colors.white),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        borderSide: BorderSide(
                                                            color: Colors.white,
                                                            width: 2),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        borderSide: BorderSide(
                                                            color: Colors.white,
                                                            width: 2),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        borderSide: BorderSide(
                                                            color: Colors.white,
                                                            width: 3),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 3),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'or use ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                context
                                                    .read<LoginInputBloc>()
                                                    .add(ToggleInputTypeEvent());
                                              });
                                            },
                                            child: Text(
                                              state.inputType == InputType.email
                                                  ? 'Number'
                                                  : 'Email',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                      BlocBuilder<PasswordVisibilityCubit, bool>(
                                        builder: (context, isObscured) {
                                          return TextFormField(
                                            focusNode: _passwordFocusNode,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                            keyboardType: TextInputType.text,
                                            controller: passwordController,
                                            obscureText: isObscured,
                                            decoration: InputDecoration(
                                              hintText: 'Password',
                                              hintStyle: TextStyle(
                                                  color: Colors.white),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  isObscured ? Icons.visibility_off : Icons.visibility,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  context.read<PasswordVisibilityCubit>().togglePasswordVisibility();
                                                },
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 2),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 2),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 3),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 2),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 3),
                                              ),
                                              errorText: passwordErrorMessage,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                passwordErrorMessage =
                                                    _validatePassword(value);
                                              });
                                            },
                                          );
                                        },
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ForgotPasswordScreen()));
                                            },
                                            child: Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.white,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 60),
                                      SizedBox(
                                        height: 60,
                                        width: MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            foregroundColor: Colors.white,
                                            backgroundColor: Color(0xFF414851),
                                          ),
                                          child: BlocBuilder<LoginInputBloc,
                                              LoginInputState>(
                                            builder: (context, state) {
                                              return BlocBuilder<LoginBloc,
                                                  LoginState>(
                                                builder: (context, state) {
                                                  debugPrint(state.toString());
                                                  if (state
                                                      is LoginLoadingState) {
                                                    return SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  } else {
                                                    return Text(
                                                      'LOGIN',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          onPressed: () async {
                                            // Check if the account was previously deleted
                                            final prefs = await SharedPreferences.getInstance();
                                            final deletedEmails = prefs.getStringList('deleted_emails') ?? [];
                                            final currentEmail = state.inputType == InputType.email 
                                                ? emailController.text 
                                                : phoneNumberController.text;
                                            
                                            if (deletedEmails.contains(currentEmail)) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  backgroundColor: Colors.red,
                                                  behavior: SnackBarBehavior.floating,
                                                  content: Text('This account has been deleted. Please create a new account.'),
                                                ),
                                              );
                                              return;
                                            }

                                            if (emailErrorMessage == null &&
                                                passwordErrorMessage == null &&
                                                emailController.text.isNotEmpty &&
                                                passwordController
                                                    .text.isNotEmpty) {
                                              if (state.inputType ==
                                                  InputType.email) {
                                                final loginRequest = LoginRequest(
                                                    email: emailController.text,
                                                    password:
                                                        passwordController.text);
                                                context.read<LoginBloc>().add(
                                                    LoginWithEmailEvent(
                                                        loginRequest));
                                              } else if (state.inputType ==
                                                  InputType.phone) {
                                                final mobileNumber = state
                                                        .countryCode +
                                                    phoneNumberController.text;
                                                final loginRequest = LoginRequest(
                                                    number: mobileNumber,
                                                    password:
                                                        passwordController.text);
                                                context.read<LoginBloc>().add(
                                                    LoginWithNumberEvent(
                                                        loginRequest));
                                              }
                                            } else if (numberErrorMessage ==
                                                    null &&
                                                passwordErrorMessage == null &&
                                                phoneNumberController
                                                    .text.isNotEmpty &&
                                                passwordController
                                                    .text.isNotEmpty) {
                                              if (state.inputType ==
                                                  InputType.email) {
                                                final loginRequest = LoginRequest(
                                                    email: emailController.text,
                                                    password:
                                                        passwordController.text);
                                                context.read<LoginBloc>().add(
                                                    LoginWithEmailEvent(
                                                        loginRequest));
                                              } else if (state.inputType ==
                                                  InputType.phone) {
                                                final loginRequest = LoginRequest(
                                                    number: phoneNumberController
                                                        .text,
                                                    password:
                                                        passwordController.text);
                                                context.read<LoginBloc>().add(
                                                    LoginWithNumberEvent(
                                                        loginRequest));
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor: Colors.red,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      content: Text(
                                                          'Enter proper credentials')));
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Don\'t have an Account?',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignUpScreen()));
                                            },
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Login as ',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BottomScreen()),
                                                  (r) => false);
                                            },
                                            child: Text(
                                              'Guest',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getCountryOfResidence() async {
    try {
      // Request permission for location access
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are denied");
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode to get address details
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      print(placemarks);
      print(position);

      // Extract the country name from the placemark
      if (placemarks.isNotEmpty) {
        print(placemarks[0].country);

        // Use SharedPreferences to save the country
        final prefs = await SharedPreferences.getInstance(); // Await here
        await prefs.setString('country',
            placemarks[0].country ?? "Unknown Country"); // Save the value

        return placemarks[0].country ?? "Unknown Country";
      } else {
        throw Exception("Unable to determine country from coordinates");
      }
    } catch (e) {
      print("Error: $e");
      return "Error: Unable to fetch location";
    }
  }
}
