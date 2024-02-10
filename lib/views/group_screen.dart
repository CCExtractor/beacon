import 'package:beacon/components/beacon_card.dart';
import 'package:beacon/components/create_join_dialog.dart';
import 'package:beacon/components/hike_button.dart';
import 'package:beacon/components/loading_screen.dart';
import 'package:beacon/components/shape_painter.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/group_screen_view_model.dart';
import 'package:beacon/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  var fetchingUserBeacons;
  var fetchingNearbyBeacons;

  @override
  void initState() {
    fetchingUserBeacons = databaseFunctions.fetchUserBeacons(widget.group.id);
    fetchingNearbyBeacons =
        databaseFunctions.fetchNearbyBeacon(widget.group.id);
    super.initState();
  }

  void reloadList() {
    setState(() {
      fetchingUserBeacons = databaseFunctions.fetchUserBeacons(widget.group.id);
      fetchingNearbyBeacons =
          databaseFunctions.fetchNearbyBeacon(widget.group.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GroupViewModel>(builder: (context, model, child) {
      TabController tabController = new TabController(length: 2, vsync: this);
      return model.isBusy
          ? LoadingScreen()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: ModalProgressHUD(
                  inAsyncCall: model.isCreatingHike,
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
                            'Welcome to Group ' + widget.group.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.9, -0.8),
                        child: FloatingActionButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    title: Text(
                                      (userConfig.currentUser.isGuest)
                                          ? 'Create Account'
                                          : 'Logout',
                                      style: TextStyle(
                                          fontSize: 25, color: kYellow),
                                    ),
                                    content: Text(
                                      (userConfig.currentUser.isGuest)
                                          ? 'Would you like to create an account?'
                                          : 'Are you sure you wanna logout?',
                                      style: TextStyle(
                                          fontSize: 16, color: kBlack),
                                    ),
                                    actions: <Widget>[
                                      HikeButton(
                                        buttonHeight: 2.5.h,
                                        buttonWidth: 8.w,
                                        onTap: () =>
                                            Navigator.of(context).pop(false),
                                        text: 'No',
                                        textSize: 18.0,
                                      ),
                                      HikeButton(
                                        buttonHeight: 2.5.h,
                                        buttonWidth: 8.w,
                                        onTap: () {
                                          navigationService.pop();
                                          model.logout();
                                        },
                                        text: 'Yes',
                                        textSize: 18.0,
                                      ),
                                    ],
                                  )),
                          backgroundColor: kYellow,
                          child: (userConfig.currentUser.isGuest)
                              ? Icon(Icons.person)
                              : Icon(Icons.logout),
                        ),
                      ),
                      Padding(
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
                                  if (userConfig.currentUser.isGuest) {
                                    navigationService.showSnackBar(
                                        'You need to login with credentials to start a hike');
                                  } else {
                                    CreateJoinBeaconDialog.createHikeDialog(
                                        context,
                                        model,
                                        reloadList,
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
                                      context, model, reloadList);
                                },
                              ),
                            ),
                          ],
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
                                        child: FutureBuilder(
                                          future: fetchingUserBeacons,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    snapshot.error.toString(),
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: 1.3,
                                                  ),
                                                );
                                              }
                                              final List<Beacon> posts =
                                                  snapshot.data;
                                              return Container(
                                                  alignment: Alignment.center,
                                                  child: posts.length == 0
                                                      ? SingleChildScrollView(
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
                                                        )
                                                      : ListView.builder(
                                                          physics:
                                                              AlwaysScrollableScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              posts?.length,
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return BeaconCustomWidgets
                                                                .getBeaconCard(
                                                                    context,
                                                                    posts[
                                                                        index]);
                                                          },
                                                        ));
                                            } else {
                                              return Center(
                                                child: BeaconCustomWidgets
                                                    .getPlaceholder(),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: FutureBuilder(
                                            future: fetchingNearbyBeacons,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting)
                                                return Center(
                                                  child: BeaconCustomWidgets
                                                      .getPlaceholder(),
                                                );
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                      snapshot.error.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      textScaleFactor: 1.3,
                                                    ),
                                                  );
                                                }

                                                final posts = snapshot.data;
                                                if (posts == null ||
                                                    posts.length == 0) {
                                                  return SingleChildScrollView(
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
                                                  );
                                                }
                                                return ListView.builder(
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: posts.length,
                                                  padding: EdgeInsets.all(8),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return BeaconCustomWidgets
                                                        .getBeaconCard(context,
                                                            posts[index]);
                                                  },
                                                );
                                              } else {
                                                return SingleChildScrollView(
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  child: Center(
                                                      child: Text(
                                                          'No nearby beacons found :(',
                                                          style: TextStyle(
                                                              color: kBlack,
                                                              fontSize: 18))),
                                                );
                                              }
                                            },
                                          ),
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
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
