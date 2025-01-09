import 'package:auto_route/auto_route.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_state.dart';
import 'package:beacon/presentation/group/widgets/create_join_dialog.dart';
import 'package:beacon/presentation/widgets/shimmer.dart';
import 'package:beacon/presentation/home/widgets/group_card.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/widgets/loading_screen.dart';
import 'package:beacon/presentation/widgets/shape_painter.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
                child: Stack(
                  children: <Widget>[
                    CustomPaint(
                      size: Size(100.w, 100.h - 200),
                      painter: ShapePainter(),
                    ),
                    // CustomPaint(
                    //   size: Size(100.w, 100.h),
                    //   painter: DrawCircle(),
                    // ),
                    Align(
                      alignment: Alignment(0.9, -0.8),
                      child: FloatingActionButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    title: Text(
                                      localApi.userModel.isGuest == true
                                          ? 'Create Account'
                                          : 'Logout',
                                      style: TextStyle(
                                          fontSize: 25, color: kYellow),
                                    ),
                                    content: Text(
                                      localApi.userModel.isGuest == true
                                          ? 'Would you like to create an account?'
                                          : 'Are you sure you want to logout?',
                                      style: TextStyle(
                                          fontSize: 16, color: kBlack),
                                    ),
                                    actions: <Widget>[
                                      HikeButton(
                                        buttonHeight: 2.5.h,
                                        buttonWidth: 8.w,
                                        onTap: () => AutoRouter.of(context)
                                            .maybePop(false),
                                        text: 'No',
                                        textSize: 18.0,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      HikeButton(
                                        buttonHeight: 2.5.h,
                                        buttonWidth: 8.w,
                                        onTap: () async {
                                          appRouter.replaceNamed('/auth');
                                          localApi.deleteUser();
                                        },
                                        text: 'Yes',
                                        textSize: 18.0,
                                      ),
                                    ],
                                  )),
                          backgroundColor: kYellow,
                          child: localApi.userModel.isGuest == true
                              ? Icon(Icons.person)
                              : Icon(Icons.logout)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(4.w, 23.h, 4.w, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 45.w,
                            child: HikeButton(
                              buttonWidth: homebwidth - 10,
                              buttonHeight: homebheight - 2,
                              text: 'Create Group',
                              textColor: Colors.white,
                              borderColor: Colors.white,
                              buttonColor: kYellow,
                              onTap: () async {
                                CreateJoinGroupDialog.createGroupDialog(
                                    context);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Container(
                            width: 45.w,
                            child: HikeButton(
                              buttonWidth: homebwidth,
                              buttonHeight: homebheight - 2,
                              text: 'Join a Group',
                              textColor: kYellow,
                              borderColor: kYellow,
                              buttonColor: Colors.white,
                              onTap: () async {
                                CreateJoinGroupDialog.joinGroupDialog(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        child: Container(
                            decoration: BoxDecoration(
                                color: kLightBlue,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            height: 56.h,
                            width: 100.w,
                            child: Column(
                              children: [
                                Tab(text: 'Your Groups'),
                                Container(
                                  height: 0.2.h,
                                  color: kBlack,
                                ),
                                localApi.userModel.isGuest == true
                                    ? Expanded(
                                        child: Center(
                                            child: SingleChildScrollView(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          child: Column(
                                            children: [
                                              Text(
                                                'You haven\'t joined or created any group yet',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                  children: [
                                                    TextSpan(
                                                        text: 'Join',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    TextSpan(
                                                        text: ' a Group or '),
                                                    TextSpan(
                                                        text: 'Create',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    TextSpan(
                                                        text: ' a new one!'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                      )
                                    : _buildList()
                              ],
                            )))
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
              return Center(
                  child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Text(
                      'You haven\'t joined or created any group yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
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
              ));
            } else {
              return ListView.builder(
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
                    return GroupCustomWidgets.getGroupCard(
                        context, groups[index]);
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
