import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_state.dart';
import 'package:beacon/presentation/group/widgets/create_join_dialog.dart';
import 'package:beacon/presentation/home/profile_screen.dart';
import 'package:beacon/presentation/widgets/shimmer.dart';
import 'package:beacon/presentation/home/widgets/group_card.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/widgets/loading_screen.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Future<bool?> _onPopHome(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 3.h,
        ),
        title: Text(
          'Confirm Exit',
          style: TextStyle(
            fontSize: 18.sp,
            color: kYellow,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Do you really want to exit?',
          style: TextStyle(
            fontSize: 16.sp,
            color: kBlack,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HikeButton(
                buttonHeight: 5.h,
                buttonWidth: 25.w,
                onTap: () => AutoRouter.of(context).maybePop(false),
                text: 'No',
                isDotted: true,
              ),
              HikeButton(
                buttonHeight: 5.h,
                buttonWidth: 25.w,
                onTap: () => AutoRouter.of(context).maybePop(true),
                text: 'Yes',
              ),
            ],
          ),
        ],
      ),
    );
  }

  late ScrollController _scrollController;
  late HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    locationService.getCurrentLocation();
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    _homeCubit.init();
    _homeCubit.fetchUserGroups();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _homeCubit.fetchUserGroups();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _homeCubit.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }

        bool? popped = await _onPopHome(context);
        if (popped == true) {
          await SystemNavigator.pop();
        }
      },
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is LoadedHomeState) {
            state.message != null
                ? utils.showSnackBar(state.message!, context)
                : null;
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: ModalProgressHUD(
                inAsyncCall: state is LoadingHomeState ? true : false,
                progressIndicator: LoadingScreen(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // App bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'images/beacon_logo.png',
                            height: 4.h,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.power_settings_new,
                              color: Colors.grey,
                              size: 6.w,
                            ),
                            onPressed: () => _showLogoutDialog(),
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      SizedBox(height: 2.h),

                      Expanded(
                          child: _currentIndex == 0
                              ? HomePage()
                              : _currentIndex == 1
                                  ? ProfileScreen(homeCubit: _homeCubit)
                                  : SettingsPage())
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 6.w),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_4, size: 6.w),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.hiking, size: 6.w),
                  label: 'Hike',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget HomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildList(),
      ],
    );
  }

  Widget SettingsPage() {
    return Center(
      child: Text(
        'Settings Page',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome message
        Row(
          children: [
            Flexible(
              child: Text(
                'Welcome back, ',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Flexible(
              child: Text(
                _getCapitalizedName(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // Ready to explore
        Text(
          'Ready to explore?',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xFF673AB7),
          ),
        ),

        SizedBox(height: 3.h),

        // Create and Join Group buttons
        Row(
          children: [
            Expanded(
              child: HikeButton(
                widget: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 5.w,
                ),
                buttonWidth: double.infinity,
                buttonHeight: 6.h,
                text: 'Create Group',
                textSize: 14.sp,
                onTap: () async {
                  CreateJoinGroupDialog.createGroupDialog(context);
                },
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: HikeButton(
                widget: Icon(
                  Icons.add,
                  color: Colors.teal,
                  size: 5.w,
                ),
                isDotted: true,
                buttonWidth: double.infinity,
                buttonHeight: 6.h,
                text: 'Join a Group',
                textSize: 14.sp,
                onTap: () async {
                  CreateJoinGroupDialog.joinGroupDialog(context);
                },
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        Text(
          'Your Groups',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return Expanded(
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) => true,
        builder: (context, state) {
          if (state is ShimmerHomeState) {
            return Center(
              child: ShimmerWidget.getPlaceholder(),
            );
          } else if (state is LoadedHomeState) {
            List<GroupEntity> groups = state.groups;
            if (groups.isEmpty) {
              return _buildEmptyState();
            } else {
              return _buildGroupsList(groups, state);
            }
          }

          return Center(
            child: Text(''),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'animations/empty.json',
              width: 50.w,
              height: 25.h,
            ),
            SizedBox(height: 3.h),
            Text(
              'You haven\'t joined or created any group yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 3.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
                children: [
                  TextSpan(
                    text: 'Join',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' a Group or '),
                  TextSpan(
                    text: 'Create',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' a new one!'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsList(List<GroupEntity> groups, LoadedHomeState state) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount:
          groups.length + (state.isLoadingmore && !state.hasReachedEnd ? 1 : 0),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      itemBuilder: (context, index) {
        if (index == groups.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Center(child: LinearProgressIndicator()),
          );
        } else {
          return GroupCard(
            group: groups[index],
          );
        }
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xffFAFAFA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 3.h,
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontSize: 14.sp,
            color: kBlack,
          ),
        ),
        actions: <Widget>[
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
                onTap: () async {
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

  String _getCapitalizedName() {
    final name = localApi.userModel.name.toString();
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }
}
