import 'package:awafi/features/login/presentation/login_screen.dart';
import 'package:awafi/features/splash/presentation/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/forgot_password/forgot_password_bloc.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const SetNewPasswordScreen(
      {super.key, required this.email, required this.otp});

  @override
  _SetNewPasswordScreenState createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  TextEditingController confirmPasswordController = TextEditingController();
  String? passwordErrorMessage;
  String? confirmPasswordErrorMessage;

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
    _passwordFocusNode
        .addListener(() => _scrollToFocusedField(_passwordFocusNode));
    _confirmPasswordFocusNode
        .addListener(() => _scrollToFocusedField(_confirmPasswordFocusNode));
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'Password must be same';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
           if(state is ForgotPasswordSuccess){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SucessLastScreen(text: 'Password has been Changed Succefully', buttonText: 'LOGIN', onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            }, heading: 'Password Changed')));
           }
          },
          child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 400,
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
                                    'New Password',
                                    style: GoogleFonts.mulish(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 36,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  TextFormField(
                                    focusNode: _passwordFocusNode,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 3),
                                      ),
                                      errorText: passwordErrorMessage,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        passwordErrorMessage =
                                            _validatePassword(value);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    focusNode: _confirmPasswordFocusNode,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: confirmPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Confirm Password',
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 3),
                                      ),
                                      errorText: confirmPasswordErrorMessage,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        confirmPasswordErrorMessage =
                                            _validateConfirmPassword(value);
                                      });
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
                                      child: BlocBuilder<ForgotPasswordBloc,
                                          ForgotPasswordState>(
                                        builder: (context, state) {
                                          debugPrint(state.toString());
                                          if (state is ForgotPasswordLoading) {
                                            return SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              'SET PASSWORD',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            );
                                          }
                                        },
                                      ),
                                      onPressed: () {
                                        if (passwordController
                                                .text.isNotEmpty &&
                                            confirmPasswordController
                                                .text.isNotEmpty &&
                                            passwordController.text ==
                                                confirmPasswordController
                                                    .text &&
                                            confirmPasswordErrorMessage ==
                                                null &&
                                            passwordErrorMessage == null) {
                                          context
                                              .read<ForgotPasswordBloc>()
                                              .add(ChangePasswordRequested(
                                                  widget.email,
                                                  widget.otp,
                                                  passwordController.text));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                      'Enter proper credentials')));
                                        }
                                      },
                                    ),
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
              )),
        ),
      ),
    );
  }
}
