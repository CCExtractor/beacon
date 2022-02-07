import 'package:beacon/components/hike_button.dart';
import 'package:beacon/components/shape_painter.dart';
import 'package:beacon/services/validators.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/utilities/indication_painter.dart';
import 'package:beacon/view_model/auth_screen_model.dart';
import 'package:beacon/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  Future<bool> _onPopHome() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
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
            onTap: () => Navigator.of(context).pop(false),
            text: 'No',
          ),
          HikeButton(
            buttonHeight: 2.5.h,
            buttonWidth: 8.w,
            onTap: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            text: 'Yes',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onPopHome,
      child: BaseView<AuthViewModel>(
        builder: (context, model, child) {
          return (model.isBusy)
              ? Scaffold(body: Center(child: CircularProgressIndicator()))
              : new Scaffold(
                  key: model.scaffoldKey,
                  resizeToAvoidBottomInset: true,
                  body: Container(
                    width: screensize.width,
                    height:
                        screensize.height >= 775.0 ? screensize.height : 775.0,
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
                                child: _buildMenuBar(context, model),
                              ),
                              Expanded(
                                flex: 2,
                                child: PageView(
                                  controller: model.pageController,
                                  onPageChanged: (i) {
                                    if (i == 0) {
                                      setState(() {
                                        model.right = Colors.black;
                                        model.left = Colors.white;
                                      });
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        model.requestFocusForFocusNode(
                                            model.emailLogin);
                                      });
                                    } else if (i == 1) {
                                      setState(() {
                                        model.right = Colors.white;
                                        model.left = Colors.black;
                                      });
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        model.requestFocusForFocusNode(
                                            model.name);
                                      });
                                    }
                                  },
                                  children: <Widget>[
                                    new ConstrainedBox(
                                      constraints:
                                          const BoxConstraints.expand(),
                                      child: _buildSignIn(context, model),
                                    ),
                                    new ConstrainedBox(
                                      constraints:
                                          const BoxConstraints.expand(),
                                      child: _buildSignUp(context, model),
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
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context, AuthViewModel model) {
    Size screensize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.5.w),
      width: screensize.width,
      height: screensize.height < 800 ? 7.5.h : 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: model.pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                //highlightColor: Colors.white,
                onPressed: model.onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                    color: model.left,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: model.onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                    color: model.right,
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

  Widget _buildSignIn(BuildContext context, AuthViewModel model) {
    Size screensize = MediaQuery.of(context).size;
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
                key: model.formKeyLogin,
                autovalidateMode: model.loginValidate,
                child: Container(
                  width: screensize.width - 70,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: TextFormField(
                          autovalidateMode: model.loginValidate,
                          focusNode: model.emailLogin,
                          controller: model.loginEmailController,
                          validator: (value) => Validator.validateEmail(value),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.mail_outline,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontSize: hintsize - 2, color: hintColor),
                          ),
                        ),
                      ),
                      Container(
                        width: 62.w,
                        height: 0.2.h,
                        color: Colors.grey[400],
                      ),
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: TextFormField(
                          autovalidateMode: model.loginValidate,
                          focusNode: model.passwordLogin,
                          controller: model.loginPasswordController,
                          obscureText: model.obscureTextLogin,
                          validator: (value) =>
                              Validator.validatePassword(value),
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              size: 24.0,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontSize: hintsize - 2, color: hintColor),
                            suffixIcon: IconButton(
                              onPressed: () => model.displayPasswordLogin(),
                              icon: Icon(
                                model.obscureTextLogin
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3.5.h,
            ),
            HikeButton(
              onTap: model.nextLogin,
              text: 'LOGIN',
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
              onTap: () => model.loginAsGuest(),
              text: 'LOGIN AS GUEST',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context, AuthViewModel model) {
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
                key: model.formKeySignup,
                autovalidateMode: model.signupValidate,
                child: Container(
                    width: screensize.width - 70,
                    // height: 280.0,
                    child: Column(children: <Widget>[
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: TextFormField(
                          autovalidateMode: model.signupValidate,
                          validator: (value) => Validator.validateName(value),
                          focusNode: model.name,
                          textInputAction: TextInputAction.next,
                          controller: model.signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.account_box,
                              color: Colors.black,
                              size: 24,
                            ),
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontSize: hintsize - 2, color: hintColor),
                          ),
                        ),
                      ),
                      Container(
                        width: 62.w,
                        height: 0.2.h,
                        color: Colors.grey[400],
                      ),
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: TextFormField(
                          autovalidateMode: model.signupValidate,
                          validator: (value) => Validator.validateEmail(value),
                          focusNode: model.email,
                          textInputAction: TextInputAction.next,
                          controller: model.signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.mail,
                              color: Colors.black,
                              size: 24,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontSize: hintsize - 2, color: hintColor),
                          ),
                        ),
                      ),
                      Container(
                        width: 62.w,
                        height: 0.2.h,
                        color: Colors.grey[400],
                      ),
                      Container(
                        height: 13.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: TextFormField(
                          autovalidateMode: model.signupValidate,
                          focusNode: model.password,
                          textInputAction: TextInputAction.done,
                          validator: (value) =>
                              Validator.validatePassword(value),
                          controller: model.signupPasswordController,
                          obscureText: model.obscureTextSignup,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                              size: 24,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => model.displayPasswordSignup(),
                              icon: Icon(
                                model.obscureTextSignup
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20.0,
                                color: Colors.black,
                              ),
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontSize: hintsize - 2, color: hintColor),
                          ),
                        ),
                      ),
                    ])),
              ),
            ),
            SizedBox(
              height: 3.5.h,
            ),
            Container(
              // margin: EdgeInsets.only(top: 300.0),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: HikeButton(
                onTap: () => model.nextSignup(),
                text: 'SIGN UP',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
