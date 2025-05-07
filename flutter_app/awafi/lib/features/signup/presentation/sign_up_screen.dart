import 'package:awafi/features/login/presentation/login_screen.dart';
import 'package:awafi/features/signup/presentation/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../login/bloc/login_input/login_input_bloc.dart';
import '../bloc/register/register_bloc.dart';
import '../bloc/signup_input/signup_input_bloc.dart';
import '../cubit/password_visibility_cubit.dart';
import '../domain/sign_in_entity.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
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
    _nameFocusNode.addListener(() => _scrollToFocusedField(_nameFocusNode));
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
    } if (value.length > 11) {
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
          body: SingleChildScrollView(
            controller: _scrollController,
            child: BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if(state is UserRegistered){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OtpScreen(email: emailController.text,)));
                }else if(state is UserError){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    content: Text(state.message)));
                }
              },
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
                            height: 280,
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
                                        'Sign Up',
                                        style: GoogleFonts.mulish(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 36,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      TextFormField(
                                        focusNode: _nameFocusNode,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        keyboardType: TextInputType.emailAddress,
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          hintText: 'Name',
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 3),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      TextFormField(
                                        focusNode: _emailFocusNode,
                                        onChanged: (value) {
                                          setState(() {
                                            emailErrorMessage =
                                                _validateEmail(value);
                                          });
                                        },
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        keyboardType: TextInputType.emailAddress,
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          errorText: emailErrorMessage,
                                          hintText: 'Email',
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 3),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BlocBuilder<CountryCodeBloc,
                                              CountryCodeState>(
                                            builder: (context, state) {
                                              return Container(
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
                                                  underline: SizedBox(),
                                                  value: state.selectedCode,
                                                  onChanged: (String? newValue) {
                                                    if (newValue != null) {
                                                      context
                                                          .read<CountryCodeBloc>()
                                                          .add(CountryCodeChanged(
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
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  dropdownColor:
                                                      Color(0xFF161A1E),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: TextFormField(
                                              focusNode: _numberFocusNode,
                                              onChanged: (value) {
                                                setState(() {
                                                  numberErrorMessage =
                                                      _validateNumber(value);
                                                });
                                              },
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                              keyboardType: TextInputType.phone,
                                              controller: phoneNumberController,
                                              decoration: InputDecoration(
                                                errorText: numberErrorMessage,
                                                hintText: 'Phone Number',
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
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      BlocBuilder<PasswordVisibilityCubit, bool>(
                                        builder: (context, isObscured) {
                                          return TextFormField(
                                            focusNode: _passwordFocusNode,
                                            onChanged: (value) {
                                              setState(() {
                                                passwordErrorMessage =
                                                    _validatePassword(value);
                                              });
                                            },
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                            keyboardType: TextInputType.text,
                                            controller: passwordController,
                                            obscureText: isObscured,
                                            decoration: InputDecoration(
                                              errorText: passwordErrorMessage,
                                              hintText: 'Password',
                                              hintStyle:
                                                  TextStyle(color: Colors.white),
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
                                            ),
                                          );
                                        },
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
                                          child: BlocBuilder<UserBloc, UserState>(
                                            builder: (context, state) {
                                              if (state is UserLoading) {
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
                                                  'REGISTER',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                );
                                              }
                                            },
                                          ),
                                          onPressed: () {
                                            if (emailErrorMessage == null &&
                                                passwordErrorMessage == null &&
                                                numberErrorMessage == null &&
                                                emailController.text.isNotEmpty &&
                                                passwordController
                                                    .text.isNotEmpty &&
                                                nameController.text.isNotEmpty) {
                                              final String email =
                                                  emailController.text;
                                              final String name =
                                                  nameController.text;
                                              final int phone = int.parse(
                                                  phoneNumberController.text);
                                              final String password =
                                                  passwordController.text;

                                              final user = UserEntity(
                                                email: email,
                                                name: name,
                                                phone: phone,
                                                password: password,
                                              );

                                              // Trigger the RegisterUserEvent with the UserEntity
                                              context
                                                  .read<UserBloc>()
                                                  .add(RegisterUserEvent(user));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor: Colors.red,
                                                      content: Text(
                                                          'Enter proper data')));
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
                                            'Already have an Account?',
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
                                                          LoginScreen()));
                                            },
                                            child: Text(
                                              'Login',
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
}
