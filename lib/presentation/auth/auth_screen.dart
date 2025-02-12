import 'package:auto_route/auto_route.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_state.dart';
import 'package:beacon/presentation/widgets/text_field.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/widgets/loading_screen.dart';
import 'package:beacon/presentation/widgets/shape_painter.dart';
import 'package:beacon/core/utils/validators.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:beacon/presentation/widgets/indication_painter.dart';
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

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    final authCubit = BlocProvider.of<AuthCubit>(context);
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
              utils.showSnackBar(state.error!, context,
                  duration: Duration(seconds: 2));
            }
          },
          builder: (context, state) {
            return state is AuthLoadingState
                ? LoadingScreen()
                : Scaffold(
                    resizeToAvoidBottomInset: true,
                    body: Container(
                      width: screensize.width,
                      height: screensize.height >= 775.0
                          ? screensize.height
                          : 775.0,
                      child: Stack(
                        children: <Widget>[
                          CustomPaint(
                            size: Size(screensize.width, screensize.height),
                            painter: ShapePainter(),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding:
                                EdgeInsets.only(top: screensize.height / 3.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child:
                                      _buildMenuBar(context, _pageController),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: PageView(
                                    controller: _pageController,
                                    onPageChanged: (i) {
                                      if (i == 0) {
                                        setState(() {
                                          rightColor = Colors.black;
                                          leftColor = Colors.white;
                                        });
                                        Future.delayed(
                                            Duration(milliseconds: 500), () {
                                          authCubit.requestFocus(
                                              loginEmailFocus, context);
                                        });
                                      } else if (i == 1) {
                                        setState(() {
                                          rightColor = Colors.white;
                                          leftColor = Colors.black;
                                        });
                                        Future.delayed(
                                            Duration(milliseconds: 500), () {
                                          authCubit.requestFocus(
                                              signUpNameFocus, context);
                                        });
                                      }
                                    },
                                    children: <Widget>[
                                      new ConstrainedBox(
                                        constraints:
                                            const BoxConstraints.expand(),
                                        child: _buildSignIn(context),
                                      ),
                                      new ConstrainedBox(
                                        constraints:
                                            const BoxConstraints.expand(),
                                        child: _buildSignUp(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ));
  }

  Widget _buildMenuBar(BuildContext context, PageController pageController) {
    Size screensize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.5.w),
      width: screensize.width,
      height: screensize.height < 800 ? 7.5.h : 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                //highlightColor: Colors.white,
                onPressed: () {
                  pageController.animateToPage(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate);
                  leftColor = Colors.white;
                  rightColor = Colors.black;
                  setState(() {});
                },
                child: Text(
                  "Existing",
                  style: TextStyle(
                    color: leftColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate);
                  rightColor = Colors.white;
                  leftColor = Colors.black;
                  setState(() {});
                },
                child: Text(
                  "New",
                  style: TextStyle(
                    color: rightColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
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
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 3.h, left: 8.5.w, right: 8.5.w),
        width: screensize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Form(
                key: _signInFormKey,
                child: Container(
                  width: screensize.width - 70,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: CustomTextField(
                          iconData: Icons.email,
                          hintText: 'Email Address',
                          controller: loginEmailController,
                          focusNode: loginEmailFocus,
                          nextFocusNode: loginPasswordFocus,
                          validator: Validator.validateEmail,
                        ),
                      ),
                      separator(),
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: CustomTextField(
                            iconData: Icons.lock,
                            hintText: 'Password',
                            controller: loginPasswordController,
                            focusNode: loginPasswordFocus,
                            showTrailing: true,
                            validator: Validator.validatePassword),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3.5.h,
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return HikeButton(
                  onTap: () {
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
                  text: 'LOGIN',
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
              child: Text(
                "Or",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            HikeButton(
              onTap: () {
                context.read<AuthCubit>().googleSignIn();
              },
              text: '',
              widget: Container(
                width: 110,
                child: Row(
                  children: [
                    Image(
                      image: AssetImage(
                        'images/google.png',
                      ),
                      height: 30,
                    ),
                    Spacer(),
                    Text(
                      'Sign In',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    )
                  ],
                ),
              ),
              buttonColor: kYellow,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    Size screensize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 3.h, left: 8.5.w, right: 8.5.w),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Form(
                key: _registerFormKey,
                child: Container(
                    width: screensize.width - 70,
                    // height: 280.0,
                    child: Column(children: <Widget>[
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: CustomTextField(
                          iconData: Icons.person_2_sharp,
                          hintText: 'Name',
                          controller: signUpNameController,
                          focusNode: signUpNameFocus,
                          nextFocusNode: signUpEmailFocus,
                          validator: Validator.validateName,
                        ),
                      ),
                      separator(),
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: CustomTextField(
                          iconData: Icons.mail,
                          hintText: 'Email Address',
                          controller: signUpEmailController,
                          focusNode: signUpEmailFocus,
                          nextFocusNode: signUpPasswordFocus,
                          validator: Validator.validateEmail,
                        ),
                      ),
                      separator(),
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: CustomTextField(
                            iconData: Icons.lock,
                            hintText: 'Password',
                            controller: signUpPasswordController,
                            focusNode: signUpPasswordFocus,
                            showTrailing: true,
                            validator: Validator.validatePassword),
                      ),
                    ])),
              ),
            ),
            SizedBox(
              height: 3.5.h,
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: HikeButton(
                        onTap: () {
                          if (_registerFormKey.currentState!.validate()) {
                            authCubit.register(
                                signUpNameController.text.trim(),
                                signUpEmailController.text.trim(),
                                signUpPasswordController.text.trim());
                          } else {
                            utils.showSnackBar(
                                'Please complete all the fields', context);
                          }
                        },
                        text: 'SIGN UP',
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }

  Widget separator() {
    return Container(
      width: 62.w,
      height: 0.2.h,
      color: Colors.grey[400],
    );
  }
}
