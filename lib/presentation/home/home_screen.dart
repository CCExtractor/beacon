import 'package:auto_route/auto_route.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_state.dart';
import 'package:beacon/presentation/group/widgets/create_join_dialog.dart';
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
  Future<bool?> _onPopHome(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // actionsAlignment: MainAxisAlignment.spaceEvenly,
        contentPadding: EdgeInsets.all(25.0),
        title: Text(
          'Confirm Exit',
          style: TextStyle(fontSize: 25, color: kYellow),
        ),
        content: Text(
          'Do you really want to exit?',
          style: TextStyle(fontSize: 18, color: kBlack),
        ),
        actions: [
          HikeButton(
            buttonHeight: 2.5.h,
            buttonWidth: 8.w,
            onTap: () => AutoRouter.of(context).maybePop(false),
            text: 'No',
          ),
          SizedBox(
            height: 5,
          ),
          HikeButton(
            buttonHeight: 2.5.h,
            buttonWidth: 8.w,
            onTap: () => AutoRouter.of(context).maybePop(true),
            text: 'Yes',
          ),
        ],
      ),
    );
  }

  late ScrollController _scrollController;
  late HomeCubit _homeCubit;

  @override
  void initState() {
    _scrollController = ScrollController();
    if (localApi.userModel.isGuest == false) {
      locationService.getCurrentLocation();
      _homeCubit = BlocProvider.of<HomeCubit>(context);
      _homeCubit.init();
      _homeCubit.fetchUserGroups();
      _scrollController.addListener(_onScroll);
    }
    super.initState();
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
    if (localApi.userModel.isGuest == false) {
      _homeCubit.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: screensize.width * 0.04,
                          right: screensize.width * 0.04,
                          top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'images/beacon_logo.png',
                                height: 28,
                              ),
                              IconButton(
                                  icon: const Icon(Icons.power_settings_new,
                                      color: Colors.grey),
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            backgroundColor: Color(0xffFAFAFA),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            title: Text('Logout',
                                                style: Style.heading),
                                            content: Text(
                                              'Are you sure you want to logout?',
                                              style: TextStyle(
                                                  fontSize: 16, color: kBlack),
                                            ),
                                            actions: <Widget>[
                                              HikeButton(
                                                buttonWidth: 80,
                                                buttonHeight: 40,
                                                isDotted: true,
                                                onTap: () =>
                                                    AutoRouter.of(context)
                                                        .maybePop(false),
                                                text: 'No',
                                                textSize: 18.0,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              HikeButton(
                                                buttonWidth: 80,
                                                buttonHeight: 40,
                                                onTap: () async {
                                                  appRouter
                                                      .replaceNamed('/auth');
                                                  localApi.deleteUser();
                                                  context
                                                      .read<AuthCubit>()
                                                      .googleSignOut();
                                                },
                                                text: 'Yes',
                                                textSize: 18.0,
                                              ),
                                            ],
                                          ))),
                            ],
                          ),

                          // welcome message
                          const SizedBox(height: 20),

                          // Welcome message
                          Row(
                            children: [
                              Text(
                                'Welcome back, ',
                                style: Style.subHeading
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                  localApi.userModel.name
                                          .toString()
                                          .toUpperCase()[0] +
                                      localApi.userModel.name
                                          .toString()
                                          .substring(1),
                                  style: Style.heading
                                      .copyWith(color: Colors.teal)),
                            ],
                          ),

                          // Ready to explore
                          Text(
                            'Ready to explore?',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF673AB7),
                            ),
                            textAlign: TextAlign.start,
                          ),

                          SizedBox(height: 2.h),

                          // Create and Join Group

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HikeButton(
                                widget: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                buttonWidth: screensize.width * 0.44,
                                buttonHeight: 45,
                                text: 'Create Group',
                                onTap: () async {
                                  CreateJoinGroupDialog.createGroupDialog(
                                      context);
                                },
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              HikeButton(
                                widget: Icon(
                                  Icons.add,
                                  color: Colors.teal,
                                  size: 18,
                                ),
                                isDotted: true,
                                buttonWidth: screensize.width * 0.44,
                                buttonHeight: 45,
                                text: 'Join a Group',
                                onTap: () async {
                                  CreateJoinGroupDialog.joinGroupDialog(
                                      context);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Your Groups',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),

                    // Your Groups
                    _buildList()
                  ],
                ),
              )),
            );
          },
        ));
  }

  Widget _buildList() {
    return Expanded(
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) {
          return true;
        },
        builder: (context, state) {
          if (state is ShimmerHomeState) {
            return Center(
              child: ShimmerWidget.getPlaceholder(),
            );
          } else if (state is LoadedHomeState) {
            List<GroupEntity> groups = state.groups;
            if (groups.isEmpty) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('animations/empty.json',
                          width: 200, height: 200),
                      const SizedBox(height: 20),
                      Text(
                        'You haven\'t joined or created any group yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 20),
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
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: groups.length +
                    (state.isLoadingmore && !state.hasReachedEnd ? 1 : 0),
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  if (index == groups.length) {
                    return Center(child: LinearProgressIndicator());
                  } else {
                    return GroupCard(
                      group: groups[index],
                    );
                    // return GroupCustomWidgets.getGroupCard(
                    //     context, groups[index]);
                  }
                },
              );
            }
          }

          return Center(
            child: Text(''),
          );
        },
      ),
    );
  }
}
