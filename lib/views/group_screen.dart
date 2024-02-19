import 'package:beacon/components/beacon_card.dart';
import 'package:beacon/components/create_join_dialog.dart';
import 'package:beacon/components/hike_button.dart';
import 'package:beacon/components/loading_screen.dart';
import 'package:beacon/components/shape_painter.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/group_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../models/group/group.dart';

class GroupScreen extends StatefulWidget {
  final Group group;
  GroupScreen(this.group);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen>
    with TickerProviderStateMixin {
  late List<Beacon?> fetchingUserBeacons;
  late List<Beacon?> fetchingNearbyBeacons;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GroupViewModel>(context, listen: false)
          .fetchGroupDetails(widget.group.id!);
    });
  }

  fetchUserBeacons() async {
    return await databaseFunctions!.fetchUserBeacons(widget.group.id);
  }

  fetchNearByBeacons() async {
    return await databaseFunctions!.fetchNearbyBeacon(widget.group.id);
  }

  reloadList() async {
    fetchingUserBeacons =
        await databaseFunctions!.fetchUserBeacons(widget.group.id);
    fetchingNearbyBeacons = await databaseFunctions!
        .fetchNearbyBeacon(widget.group.id) as List<Beacon?>;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = new TabController(length: 2, vsync: this);
    return PopScope(onPopInvoked: (didPop) {
      if (didPop == true) {
        Provider.of<GroupViewModel>(context, listen: false).clearGroupInfo();
      }
    }, child:
        Consumer<GroupViewModel>(builder: (context, groupviewmodel, child) {
      return groupviewmodel.isBusy
          ? LoadingScreen()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: ModalProgressHUD(
                  inAsyncCall: groupviewmodel.isCreatingHike,
                  child: Stack(
                    children: <Widget>[
                      CustomPaint(
                        size: Size(MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height - 200),
                        painter: ShapePainter(),
                      ),
                      // Creating a back button
                      // Align(
                      //   alignment: Alignment(-0.9, -0.8),
                      //   child: FloatingActionButton(
                      //     onPressed: () => navigationService.pop(),
                      //     backgroundColor: kYellow,
                      //     child: Icon(Icons.arrow_back_rounded),
                      //   ),
                      // ),
                      Align(
                        alignment: Alignment(-0.7, -0.95),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            'Welcome to Group ' + widget.group.title!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.8, -0.8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              heroTag: 'list button',
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        // actionsAlignment:
                                        //     MainAxisAlignment.spaceEvenly,
                                        title: Text(
                                          'Group members',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 25, color: kYellow),
                                        ),
                                        content: Container(
                                          height: 250,
                                          width: 250,
                                          child: Builder(
                                            builder: (context) {
                                              if (groupviewmodel
                                                  .loadingGroupMembers) {
                                                return Center(
                                                  child: BeaconCustomWidgets
                                                      .getPlaceholder(),
                                                );
                                              } else {
                                                return groupviewmodel
                                                        .groupMembers.isEmpty
                                                    ? Container(
                                                        child: Text('emplty'),
                                                      )
                                                    : ListView.builder(
                                                        itemCount:
                                                            groupviewmodel
                                                                .groupMembers
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5),
                                                            height: 7.h,
                                                            width: 50.w,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color:
                                                                        kLightBlue),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(groupviewmodel
                                                                    .groupMembers[
                                                                        index]
                                                                    .name
                                                                    .toString()),
                                                                Text(index == 0
                                                                    ? '(leader)'
                                                                    : '(member)')
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                              }
                                            },
                                          ),
                                        ),
                                      )),
                              backgroundColor: kYellow,
                              child: Icon(Icons.list),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            FloatingActionButton(
                              heroTag: 'log out ',
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        // actionsAlignment:
                                        //     MainAxisAlignment.spaceEvenly,
                                        title: Text(
                                          userConfig!.currentUser!.isGuest!
                                              ? 'Create Account'
                                              : 'Logout',
                                          style: TextStyle(
                                              fontSize: 25, color: kYellow),
                                        ),
                                        content: Text(
                                          userConfig!.currentUser!.isGuest!
                                              ? 'Would you like to create an account?'
                                              : 'Are you sure you wanna logout?',
                                          style: TextStyle(
                                              fontSize: 16, color: kBlack),
                                        ),
                                        actions: <Widget>[
                                          HikeButton(
                                            buttonHeight: 2.5.h,
                                            buttonWidth: 8.w,
                                            onTap: () => Navigator.of(context)
                                                .pop(false),
                                            text: 'No',
                                            textSize: 18.0,
                                          ),
                                          HikeButton(
                                            buttonHeight: 2.5.h,
                                            buttonWidth: 8.w,
                                            onTap: () {
                                              navigationService!.pop();
                                              groupviewmodel.logout();
                                            },
                                            text: 'Yes',
                                            textSize: 18.0,
                                          ),
                                        ],
                                      )),
                              backgroundColor: kYellow,
                              child: userConfig!.currentUser!.isGuest!
                                  ? Icon(Icons.person)
                                  : Icon(Icons.logout),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 58.h,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4.w, 25.h, 4.w, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 45.w,
                                child: HikeButton(
                                  buttonWidth: homebwidth,
                                  buttonHeight: homebheight - 2,
                                  text: 'Create Hike',
                                  textColor: Colors.white,
                                  borderColor: Colors.white,
                                  buttonColor: kYellow,
                                  onTap: () {
                                    if (userConfig!.currentUser!.isGuest!) {
                                      navigationService!.showSnackBar(
                                          'You need to login with credentials to start a hike');
                                    } else {
                                      CreateJoinBeaconDialog.createHikeDialog(
                                          context,
                                          groupviewmodel,
                                          widget.group.id);
                                    }
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
                                  text: 'Join a Hike',
                                  textColor: kYellow,
                                  borderColor: kYellow,
                                  buttonColor: Colors.white,
                                  onTap: () async {
                                    CreateJoinBeaconDialog.joinBeaconDialog(
                                        context, groupviewmodel, reloadList);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.565,
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              color: kLightBlue,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(50.0),
                                topRight: const Radius.circular(50.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                TabBar(
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorColor: kBlue,
                                  labelColor: kBlack,
                                  tabs: [
                                    Tab(text: 'Your Beacons'),
                                    Tab(text: 'Nearby Beacons'),
                                  ],
                                  controller: tabController,
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: tabController,
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Builder(
                                            builder: (context) {
                                              if (groupviewmodel
                                                  .loadingUserBeacons) {
                                                return Center(
                                                  child: BeaconCustomWidgets
                                                      .getPlaceholder(),
                                                );
                                              } else {
                                                return groupviewmodel
                                                        .userBeacons.isEmpty
                                                    ? Center(
                                                        child:
                                                            SingleChildScrollView(
                                                          physics:
                                                              AlwaysScrollableScrollPhysics(),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'You haven\'t joined or created any beacon yet',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color:
                                                                        kBlack,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              SizedBox(
                                                                height: 2.h,
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  // textAlign:
                                                                  //   TextAlign
                                                                  //       .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          kBlack,
                                                                      fontSize:
                                                                          20),
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            'Join',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                    TextSpan(
                                                                        text:
                                                                            ' a Hike or '),
                                                                    TextSpan(
                                                                        text:
                                                                            'Create',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                    TextSpan(
                                                                        text:
                                                                            '  a new one! '),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : ListView.builder(
                                                        itemCount:
                                                            groupviewmodel
                                                                .userBeacons
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return BeaconCustomWidgets
                                                              .getBeaconCard(
                                                                  context,
                                                                  groupviewmodel
                                                                          .userBeacons[
                                                                      index]);
                                                        },
                                                      );
                                              }
                                            },
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Builder(
                                              builder: (context) {
                                                if (groupviewmodel
                                                    .loadingNearbyBeacons) {
                                                  return Center(
                                                    child: BeaconCustomWidgets
                                                        .getPlaceholder(),
                                                  );
                                                } else {
                                                  return groupviewmodel
                                                          .nearByBeacons.isEmpty
                                                      ? SingleChildScrollView(
                                                          physics:
                                                              AlwaysScrollableScrollPhysics(),
                                                          child: Center(
                                                            child: Text(
                                                              'No nearby beacons found :(',
                                                              style: TextStyle(
                                                                  color: kBlack,
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                        )
                                                      : ListView.builder(
                                                          itemCount:
                                                              groupviewmodel
                                                                  .nearByBeacons
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return BeaconCustomWidgets
                                                                .getBeaconCard(
                                                                    context,
                                                                    groupviewmodel
                                                                            .nearByBeacons[
                                                                        index]);
                                                          },
                                                        );
                                                }
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
    }));
  }
}
