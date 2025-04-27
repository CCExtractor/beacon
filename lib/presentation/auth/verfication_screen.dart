import 'package:auto_route/auto_route.dart';
import 'package:beacon/config/router/router.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_cubit.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  String get _otpCode => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    // Add listeners to focus nodes to trigger rebuilds when focus changes
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.removeListener(() {});
      node.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              // Back button
              GestureDetector(
                onTap: () async {
                  await sp.deleteData('time');
                  await sp.deleteData('otp');
                  appRouter.replace(AuthScreenRoute());
                },
                child: Icon(Icons.arrow_back, color: Colors.black54),
              ),
              SizedBox(height: 10.h),
              // Verification code title
              Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 1.h),
              // Subtitle
              Text(
                'We have sent the verification\ncode to your email address',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 5.h),
              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _getBorderColor(index),
                        width: _getBorderWidth(index),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) => _onDigitChanged(index, value),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              // Confirm button
              BlocBuilder<VerificationCubit, OTPVerificationState>(
                builder: (context, state) {
                  return Container(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: state is OTPSentState
                          ? () async {
                              if (_otpCode == state.otp) {
                                await locator<VerificationCubit>()
                                    .completeVerification();
                                if (state is OTPVerifiedState) {
                                  appRouter.push(VerificationScreenRoute());
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter valid OTP'),
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to determine border color based on focus and content
  Color _getBorderColor(int index) {
    if (_focusNodes[index].hasFocus) {
      return Colors.teal; // Green color when focused
    } else if (_controllers[index].text.isNotEmpty) {
      return Colors.tealAccent; // Green color when filled
    } else {
      return Colors.grey.shade300; // Default grey border
    }
  }

  // Helper method to determine border width based on focus and content
  double _getBorderWidth(int index) {
    if (_focusNodes[index].hasFocus || _controllers[index].text.isNotEmpty) {
      return 2.0; // Thicker border when focused or filled
    } else {
      return 1.0; // Default border width
    }
  }
}
