import 'package:beacon/components/hike_button.dart';
import 'package:beacon/components/shape_painter.dart';
import 'package:beacon/services/validators.dart';
import 'package:beacon/utilities/indication_painter.dart';
import 'package:beacon/view_model/auth_screen_model.dart';
import 'package:beacon/views/base_view.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(builder: (context, model, child) {
      return (model.isBusy)
          ? Scaffold(body: Center(child: CircularProgressIndicator()))
          : new Scaffold(
              key: model.scaffoldKey,
              // resizeToAvoidBottomInset: false,
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,
                child: Stack(
                  children: <Widget>[
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                      painter: ShapePainter(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3.5),
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
                                  Future.delayed(Duration(milliseconds: 500),
                                      () {
                                    model.requestFocusForFocusNode(
                                        model.emailLogin);
                                  });
                                } else if (i == 1) {
                                  setState(() {
                                    model.right = Colors.white;
                                    model.left = Colors.black;
                                  });
                                  Future.delayed(Duration(milliseconds: 500),
                                      () {
                                    model.requestFocusForFocusNode(model.name);
                                  });
                                }
                              },
                              children: <Widget>[
                                new ConstrainedBox(
                                  constraints: const BoxConstraints.expand(),
                                  child: _buildSignIn(context, model),
                                ),
                                new ConstrainedBox(
                                  constraints: const BoxConstraints.expand(),
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
    });
  }

  Widget _buildMenuBar(BuildContext context, AuthViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      width: MediaQuery.of(context).size.width,
      height: 50.0,
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
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                //splashColor: Colors.transparent,
                //highlightColor: Colors.transparent,
                onPressed: model.onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                    color: model.right,
                    fontSize: 16.0,
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
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 23.0, left: 35, right: 35),
        width: MediaQuery.of(context).size.width,
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
                  // width: MediaQuery.of(context).size.width - 35,
                  // height: MediaQuery.of(context).size.height / 4.3,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                              size: 22.0,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(fontSize: 17.0),
                            suffixIcon: IconButton(
                              onPressed: () => model.displayPasswordLogin(),
                              icon: Icon(
                                model.obscureTextLogin
                                    ? Icons.remove_red_eye_sharp
                                    : Icons.remove_red_eye_outlined,
                                size: 15.0,
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
              height: 20,
            ),
            HikeButton(
              onTap: model.nextLogin,
              text: 'LOGIN',
              buttonWidth: 90,
              buttonHeight: 15,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 20, bottom: 20),
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
              buttonHeight: 15,
              buttonWidth: 35,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context, AuthViewModel model) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 23.0),
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
                    width: MediaQuery.of(context).size.width - 70,
                    // height: 280.0,
                    child: Column(children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 20),
                        child: TextFormField(
                          autovalidateMode: model.signupValidate,
                          focusNode: model.name,
                          textInputAction: TextInputAction.next,
                          controller: model.signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.account_box,
                              color: Colors.black,
                            ),
                            hintText: "Name",
                            hintStyle: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => model.displayPasswordSignup(),
                              icon: Icon(
                                model.obscureTextSignup
                                    ? Icons.remove_red_eye_sharp
                                    : Icons.remove_red_eye_outlined,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ])),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                // margin: EdgeInsets.only(top: 300.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: HikeButton(
                  onTap: () => model.nextSignup(),
                  text: 'SIGNIN',
                  buttonHeight: 18,
                  buttonWidth: 55,
                )),
          ],
        ),
      ),
    );
  }
}
