import 'package:auto_route/auto_route.dart';
import 'package:beacon/config/router/router.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'hike_button.dart';

class BeaconScreenTemplate extends StatelessWidget {
  final Widget body;
  final bool showAppBar;
  final bool showLogout;
  final bool showBottomNav;

  const BeaconScreenTemplate({
    super.key,
    required this.body,
    this.showAppBar = true,
    this.showBottomNav = false,
    this.showLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            if (showAppBar) _buildAppBar(context),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: showBottomNav ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey, size: 20.sp),
            onPressed: () => AutoRouter.of(context).maybePop(),
          ),
          Image.asset('images/beacon_logo.png', height: 4.h),
          showLogout
              ? IconButton(
                  icon: Icon(Icons.power_settings_new,
                      color: Colors.grey, size: 20.sp),
                  onPressed: () => _showLogoutDialog(context),
                )
              : // profile icon
              IconButton(
                  icon: SizedBox(
                    width: 34,
                    height: 34,
                    child: Container(
                        decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.purple, width: 1),
                      color: Colors.grey.shade200,
                      image: DecorationImage(
                        image: NetworkImage(localApi.userModel.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    )),
                  ),
                  onPressed: () {
                    AutoRouter.of(context).push(ProfileScreenRoute());
                  },
                ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        title: Text(
          'Logout',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HikeButton(
                buttonWidth: 25.w,
                buttonHeight: 5.h,
                isDotted: true,
                onTap: () => AutoRouter.of(context).maybePop(false),
                text: 'No',
                textSize: 14.sp,
              ),
              HikeButton(
                buttonWidth: 25.w,
                buttonHeight: 5.h,
                onTap: () {
                  appRouter.replaceNamed('/auth');
                  localApi.deleteUser();
                  context.read<AuthCubit>().googleSignOut();
                },
                text: 'Yes',
                textSize: 14.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.hiking), label: 'Hike'),
      ],
    );
  }
}
