import 'package:awafi/features/login/presentation/set_new_password_screen.dart';
import 'package:awafi/features/splash/presentation/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/forgot_password/forgot_password_bloc.dart';

class PasswordOtpScreen extends StatefulWidget {
  const PasswordOtpScreen({super.key, required this.email});
  final String email;

  @override
  _PasswordOtpScreenState createState() => _PasswordOtpScreenState();
}

class _PasswordOtpScreenState extends State<PasswordOtpScreen> {
  // Create FocusNodes for each text field
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  // Controllers for OTP input
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  // Method to check if all fields are filled
  bool _isOtpValid() {
    return _otpController1.text.isNotEmpty &&
        _otpController2.text.isNotEmpty &&
        _otpController3.text.isNotEmpty &&
        _otpController4.text.isNotEmpty;
  }

  String _getOtp() {
    return _otpController1.text +
        _otpController2.text +
        _otpController3.text +
        _otpController4.text;
  }

  @override
  void dispose() {
    // Dispose the focus nodes and controllers
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    super.dispose();
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
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if(state is ForgotPasswordSuccess){
            final otp = _getOtp();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SucessLastScreen(heading: 'Verified',text: 'OTP verified for password Change', buttonText: 'SET NEW PASSWORD', onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SetNewPasswordScreen(email: widget.email,otp: otp,)));
            })));
          }else if(state is ForgotPasswordFailure){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter OTP",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Enter the verification code we just sent you on your Email id",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOtpTextField(
                      _otpController1, _focusNode1, _focusNode2, _focusNode1),
                  SizedBox(width: 10),
                  _buildOtpTextField(
                      _otpController2, _focusNode2, _focusNode3, _focusNode1),
                  SizedBox(width: 10),
                  _buildOtpTextField(
                      _otpController3, _focusNode3, _focusNode4, _focusNode2),
                  SizedBox(width: 10),
                  _buildOtpTextField(
                      _otpController4, _focusNode4, null, _focusNode3),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF414851),
          ),
          onPressed: _isOtpValid()
              ? () {
                  final otp = _getOtp();
                  context.read<ForgotPasswordBloc>().add(
                                          VerifyOtpRequested(widget.email, otp));
                }
              : null, // Disable button if OTP is invalid
          child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
            builder: (context, state) {
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
                  'VERIFY',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // Function to build each OTP TextField
  Widget _buildOtpTextField(
    TextEditingController controller,
    FocusNode focusNode,
    FocusNode? nextFocusNode,
    FocusNode? previousFocusNode,
  ) {
    return SizedBox(
      width: 50,
      child: TextField(
        style: GoogleFonts.mulish(fontWeight: FontWeight.bold),
        cursorColor: Color(0xFF161A1E),
        textAlign: TextAlign.center,
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textInputAction:
            nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF161A1E), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF161A1E), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF161A1E), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          setState(() {}); // Rebuild the UI to check OTP validity

          // Move to the next field if this field is filled
          if (value.isNotEmpty && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
          // Go back to the previous field if this field is cleared
          else if (value.isEmpty && previousFocusNode != null) {
            FocusScope.of(context).requestFocus(previousFocusNode);
          }
        },
      ),
    );
  }
}
