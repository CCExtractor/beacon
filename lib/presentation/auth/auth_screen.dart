import 'package:auto_route/auto_route.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_state.dart';
import 'package:beacon/presentation/widgets/text_field.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/widgets/loading_screen.dart';
import 'package:beacon/core/utils/validators.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  Future<bool?> onPopHome() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.all(25.0),
        title: Text(
          'Confirm Exit',
          style: TextStyle(fontSize: 25, color: kYellow),
        ),
        content: Text(
          'Do you really want to exit?',
          style: TextStyle(fontSize: 18, color: kBlack),
        ),
        actions: <Widget>[
          HikeButton(
            buttonHeight: 2.5.h,
            buttonWidth: 8.w,
            onTap: () => appRouter.maybePop(false),
            text: 'No',
          ),
          HikeButton(
            buttonHeight: 2.5.h,
            buttonWidth: 8.w,
            onTap: () => appRouter.maybePop(true),
            text: 'Yes',
          ),
        ],
      ),
    );
  }

  PageController _pageController = PageController();

  Color leftColor = Colors.white;
  Color rightColor = Colors.black;

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Adaptive padding
    double getHorizontalPadding() {
      if (screenWidth < 360) return screenWidth * 0.05; // 5% for small phones
      if (screenWidth < 400) return screenWidth * 0.06; // 6% for medium phones
      if (screenWidth < 600) return screenWidth * 0.08; // 8% for large phones
      return screenWidth * 0.12; // 12% for tablets
    }

    // Adaptive top spacing
    double getTopSpacing() {
      if (screenHeight < 600) return screenHeight * 0.08; // Small screens
      if (screenHeight < 700) return screenHeight * 0.10; // Medium screens
      if (screenHeight < 800) return screenHeight * 0.12; // Large screens
      return screenHeight * 0.15; // Very large screens
    }

    // Adaptive logo size
    double getLogoWidth() {
      if (screenWidth < 360)
        return screenWidth * 0.65; // Smaller logo for small phones
      if (screenWidth < 400) return screenWidth * 0.68; // Medium phones
      if (screenWidth < 600) return screenWidth * 0.70; // Large phones
      return screenWidth * 0.60; // Tablets (smaller relative size)
    }

    // Adaptive spacing after logo
    double getLogoBottomSpacing() {
      if (screenHeight < 600) return screenHeight * 0.04; // Small screens
      if (screenHeight < 700) return screenHeight * 0.06; // Medium screens
      if (screenHeight < 800) return screenHeight * 0.07; // Large screens
      return screenHeight * 0.08; // Very large screens
    }

    // Adaptive text size for welcome message
    TextStyle getWelcomeTextStyle() {
      final baseStyle = Theme.of(context).textTheme.headlineMedium;
      if (screenWidth < 360) {
        return baseStyle?.copyWith(fontSize: 20) ?? TextStyle(fontSize: 20);
      }
      if (screenWidth < 400) {
        return baseStyle?.copyWith(fontSize: 22) ?? TextStyle(fontSize: 22);
      }
      return baseStyle ?? TextStyle(fontSize: 24);
    }

    final horizontalPadding = getHorizontalPadding();
    final topSpacing = getTopSpacing();
    final logoWidth = getLogoWidth();
    final logoBottomSpacing = getLogoBottomSpacing();
    final welcomeTextStyle = getWelcomeTextStyle();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }

        bool? popped = await onPopHome();
        if (popped == true) {
          await SystemNavigator.pop();
        }
        return;
      },
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SuccessState) {
            appRouter.replaceNamed('/home');
            state.message != null
                ? utils.showSnackBar(state.message!, context)
                : null;
          } else if (state is AuthVerificationState) {
            context.read<AuthCubit>().navigate();
          } else if (state is AuthErrorState) {
            utils.showSnackBar(
              state.error!,
              context,
              duration: Duration(seconds: 2),
            );
          }
        },
        builder: (context, state) {
          return state is AuthLoadingState
              ? LoadingScreen()
              : Scaffold(
                  resizeToAvoidBottomInset: true,
                  body: SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: topSpacing),
                                  Text(
                                    'welcome to',
                                    style: welcomeTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 300, // Maximum logo width
                                      minWidth: 200, // Minimum logo width
                                    ),
                                    child: Image.asset(
                                      'images/beacon_logo.png',
                                      width: logoWidth,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(height: logoBottomSpacing),
                                  Expanded(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            500, // Maximum form width for tablets
                                      ),
                                      child: PageView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        controller: _pageController,
                                        children: <Widget>[
                                          _buildSignIn(context),
                                          _buildSignUp(context),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Add some bottom padding for very small screens
                                  if (screenHeight < 600) SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }

  GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signUpNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();

  final signUpNameFocus = FocusNode();
  final signUpEmailFocus = FocusNode();
  final signUpPasswordFocus = FocusNode();

  final loginEmailFocus = FocusNode();
  final loginPasswordFocus = FocusNode();
  Widget _buildSignIn(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;

    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Container(
      width: screensize.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Form(
              key: _signInFormKey,
              child: Container(
                width: screensize.width - 70,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      iconData: Icons.email,
                      hintText: 'Email Address',
                      controller: loginEmailController,
                      focusNode: loginEmailFocus,
                      nextFocusNode: loginPasswordFocus,
                      validator: Validator.validateEmail,
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    CustomTextField(
                        iconData: Icons.lock,
                        hintText: 'Password',
                        controller: loginPasswordController,
                        focusNode: loginPasswordFocus,
                        showTrailing: true,
                        validator: Validator.validatePassword),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.5.h,
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    if (_signInFormKey.currentState!.validate()) {
                      authCubit.login(
                        loginEmailController.text.trim(),
                        loginPasswordController.text.trim(),
                      );
                    } else {
                      utils.showSnackBar(
                          'Please complete all the fields', context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: Size(screensize.width - 70, 45)),
                  child: const Text(
                    'Continue with Email',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
            _switchPageHelper(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Adaptive padding based on screen size
    double getHorizontalPadding() {
      if (screenWidth < 360) return 20; // Small phones
      if (screenWidth < 400) return 35; // Medium phones
      if (screenWidth < 600) return 50; // Large phones
      return 70; // Tablets
    }

    // Adaptive spacing
    double getVerticalSpacing() {
      if (screenHeight < 600) return 0.8.h; // Small screens
      if (screenHeight < 800) return 1.2.h; // Medium screens
      return 1.5.h; // Large screens
    }

    // Adaptive button height
    double getButtonHeight() {
      if (screenHeight < 600) return 40; // Small screens
      if (screenHeight < 800) return 45; // Medium screens
      return 50; // Large screens
    }

    // Adaptive font size
    double getButtonFontSize() {
      if (screenWidth < 360) return 14;
      if (screenWidth < 400) return 15;
      return 16;
    }

    final horizontalPadding = getHorizontalPadding();
    final verticalSpacing = getVerticalSpacing();
    final buttonHeight = getButtonHeight();
    final buttonFontSize = getButtonFontSize();

    return Container(
      width: screenWidth,
      padding:
          EdgeInsets.symmetric(horizontal: 16), // Base padding for container
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _registerFormKey,
              child: Container(
                width: screenWidth - (horizontalPadding * 2),
                constraints: BoxConstraints(
                  maxWidth: 400, // Maximum width for tablets
                  minWidth: 280, // Minimum width for small phones
                ),
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      iconData: Icons.person_2_sharp,
                      hintText: 'Name',
                      controller: signUpNameController,
                      focusNode: signUpNameFocus,
                      nextFocusNode: signUpEmailFocus,
                      validator: Validator.validateName,
                    ),
                    SizedBox(height: verticalSpacing),
                    CustomTextField(
                      iconData: Icons.mail,
                      hintText: 'Email Address',
                      controller: signUpEmailController,
                      focusNode: signUpEmailFocus,
                      nextFocusNode: signUpPasswordFocus,
                      validator: Validator.validateEmail,
                    ),
                    SizedBox(height: verticalSpacing),
                    CustomTextField(
                      iconData: Icons.lock,
                      hintText: 'Password',
                      controller: signUpPasswordController,
                      focusNode: signUpPasswordFocus,
                      showTrailing: true,
                      validator: Validator.validatePassword,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: verticalSpacing),
            Container(
              width: screenWidth - (horizontalPadding * 2),
              constraints: BoxConstraints(
                maxWidth: 400, // Maximum width for tablets
                minWidth: 280, // Minimum width for small phones
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_registerFormKey.currentState!.validate()) {
                        authCubit.register(
                          signUpNameController.text.trim(),
                          signUpEmailController.text.trim(),
                          signUpPasswordController.text.trim(),
                        );
                      } else {
                        utils.showSnackBar(
                          'Please complete all the fields',
                          context,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: Size(double.infinity, buttonHeight),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Continue with Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: verticalSpacing),
            _switchPageHelper(),
          ],
        ),
      ),
    );
  }

  Widget _switchPageHelper() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentPage == 0
                  ? 'Don\'t have an account?'
                  : 'Already have an account?',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () {
                _pageController.animateToPage(
                  _currentPage == 0 ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );

                setState(() {
                  _currentPage == 0 ? _currentPage = 1 : _currentPage = 0;
                });
              },
              child: Text(
                _currentPage == 0 ? 'Sign up' : 'Sign in',
                style: TextStyle(
                  color: Color(0xFF6A1B9A),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SizedBox(
          width: 200,
          child: Row(
            children: const [
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'or',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        OutlinedButton(
          onPressed: () {
            context.read<AuthCubit>().googleSignIn();
          },
          style: OutlinedButton.styleFrom(
              minimumSize: const Size(56, 56),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              backgroundColor: Colors.black12,
              padding: EdgeInsets.zero,
              side: BorderSide.none),
          child: Image.asset(
            'images/google.png',
            height: 24,
            width: 24,
          ),
        ),
      ],
    );
  }
}
