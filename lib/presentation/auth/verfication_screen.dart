import 'package:auto_route/auto_route.dart';
import 'package:beacon/config/router/router.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_cubit.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_state.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/widgets/shape_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h >= 775.0 ? 100.h : 775.0,
        child: Stack(
          children: <Widget>[
            CustomPaint(
              size: Size(100.w, 100.h),
              painter: ShapePainter(),
            ),
            Align(
              alignment: Alignment(-0.9, -0.9),
              child: FloatingActionButton(
                  backgroundColor: kYellow,
                  onPressed: () async {
                    await sp.deleteData('time');
                    await sp.deleteData('otp');
                    appRouter.replace(AuthScreenRoute());
                  },
                  child: Icon(CupertinoIcons.back)),
            ),
            Container(
              width: 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'A verification code is sent to your email',
                    style: TextStyle(color: kBlack, fontSize: 16),
                  ),
                  Gap(10),
                  Pinput(
                    controller: _controller,
                    onCompleted: (pin) => print(pin),
                  ),
                  Gap(20),
                  BlocBuilder<VerificationCubit, OTPVerificationState>(
                    builder: (context, state) {
                      return HikeButton(
                        onTap: state is OTPSentState
                            ? () async {
                                if (_controller.text == state.otp) {
                                  await locator<VerificationCubit>()
                                      .completeVerification();
                                  if (state is OTPVerifiedState) {
                                    appRouter.push(VerificationScreenRoute());
                                  }
                                } else {
                                  utils.showSnackBar(
                                      'Please enter valid otp', context);
                                }
                              }
                            : null,
                        buttonColor:
                            state is OTPSendingState ? kBlack : kYellow,
                        text: ' Verify ',
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
