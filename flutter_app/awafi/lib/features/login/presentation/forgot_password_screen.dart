import 'package:awafi/features/login/presentation/password_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../dashboard/widgets/bottom_nav_bar.dart';
import '../../signup/presentation/sign_up_screen.dart';
import '../bloc/forgot_password/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  String? emailErrorMessage;

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
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PasswordOtpScreen(email: emailController.text)));
          } else if (state is ForgotPasswordFailure) {
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
            child: ConstrainedBox(
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
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Forgot Password',
                                  style: GoogleFonts.mulish(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 36,
                                  ),
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                  // focusNode: _emailFocusNode,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
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
                                    errorText: emailErrorMessage,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      emailErrorMessage = _validateEmail(value);
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Color(0xFF414851),
                                    ),
                                    child:
                                        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                                      builder: (context, state) {
                                        if(state is ForgotPasswordLoading){
                                          return SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  );
                                        }else{
                                          return Text(
                                          'GET OTP',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        );
                                        }
                                      },
                                    ),
                                    onPressed: () {
                                      print(emailController.text);
                                      context.read<ForgotPasswordBloc>().add(
                                          ForgotPasswordRequested(
                                              emailController.text));
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                    BottomScreen()),(r) => false);
                                      },
                                      child: Text(
                                        'Guest',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline,
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
            )),
      ),
    );
  }
}
