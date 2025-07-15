import 'package:auto_route/auto_route.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_state.dart';
import 'package:beacon/presentation/group/widgets/create_join_dialog.dart';
import 'package:beacon/presentation/home/profile_screen.dart';
import 'package:beacon/presentation/widgets/screen_template.dart';
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

  Future<bool?> _onPopHome(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 2.h,
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        bool? popped = await _onPopHome(context);
        if (popped == true) await SystemNavigator.pop();
      },
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is LoadedHomeState && state.message != null) {
            utils.showSnackBar(state.message!, context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: BeaconScreenTemplate(
              body: ModalProgressHUD(
                inAsyncCall: state is LoadingHomeState,
                progressIndicator: const LoadingScreen(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Expanded(
                        child: _currentIndex == 0
                            ? _buildHomePage()
                            : _currentIndex == 1
                                ? ProfileScreen()
                                : _buildSettingsPage(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomePage() {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 2.h),
        Expanded(child: _buildGroupList()),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Welcome back, ',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
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
        Text(
          'Ready to explore?',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xFF673AB7),
          ),
        ),
        SizedBox(height: 3.h),
        _buildActionButtons(),
        SizedBox(height: 3.h),
        Text(
          'Your Groups',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: HikeButton(
            widget: Icon(Icons.add, color: Colors.white, size: 20.sp),
            buttonHeight: 6.h,
            buttonWidth: double.infinity,
            text: 'Create Group',
            textSize: 14.sp,
            onTap: () => CreateJoinGroupDialog.createGroupDialog(context),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: HikeButton(
            widget: Icon(Icons.add, color: Colors.teal, size: 20.sp),
            isDotted: true,
            buttonHeight: 6.h,
            buttonWidth: double.infinity,
            text: 'Join a Group',
            textSize: 14.sp,
            onTap: () => CreateJoinGroupDialog.joinGroupDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupList() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is ShimmerHomeState) {
          return Center(child: ShimmerWidget.getPlaceholder());
        } else if (state is LoadedHomeState) {
          if (state.groups.isEmpty) {
            return _buildEmptyState();
          }
          return _buildGroupsList(state.groups, state);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          children: [
            Lottie.asset('animations/empty.json', width: 50.w, height: 25.h),
            SizedBox(height: 3.h),
            Text(
              'You haven\'t joined or created any group yet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 3.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
                children: [
                  TextSpan(
                      text: 'Join',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' a Group or '),
                  TextSpan(
                      text: 'Create',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' a new one!'),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            IconButton(
              icon: Icon(Icons.refresh, size: 20.sp, color: Colors.teal),
              onPressed: () => _homeCubit.fetchUserGroups(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsList(List<GroupEntity> groups, LoadedHomeState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(top: 1.h),
      itemCount:
          groups.length + (state.isLoadingmore && !state.hasReachedEnd ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == groups.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: const Center(child: LinearProgressIndicator()),
          );
        }
        return GroupCard(group: groups[index]);
      },
    );
  }

  Widget _buildSettingsPage() {
    return Center(
      child: Text(
        'Settings Page',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getCapitalizedName() {
    final name = localApi.userModel.name.toString();
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }
}
