import 'package:auto_route/auto_route.dart';
import 'package:beacon/Bloc/domain/entities/group/group_entity.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/old/components/utilities/constants.dart';
import 'package:beacon/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'models/group/group.dart';

class GroupCustomWidgets {
  static final Color textColor = Color(0xFFAFAFAF);

  static Widget getGroupCard(BuildContext context, GroupEntity group) {
    String noMembers = group.members!.length.toString();
    String noBeacons = group.beacons!.length.toString();
    return GestureDetector(
      onTap: () async {
        bool isMember = false;
        for (var i in group.members!) {
          if (i!.id == userConfig!.currentUser!.id) {
            isMember = true;
          }
        }
        if (group.leader!.id == localApi.userModel.id || isMember) {
          // navigationService!.pushScreen('/groupScreen',
          //     arguments: GroupScreen(
          //       group,
          //     ));

          // AutoRouter.of(context).pushNamed('/group');

          AutoRouter.of(context).push(GroupScreenRoute(group: group));
        } else {
          await databaseFunctions!.init();
          final Group? _group =
              await databaseFunctions!.joinGroup(group.shortcode);
          if (_group != null) {
            // navigationService!
            //     .pushScreen('/groupScreen', arguments: GroupScreen(group));
            // AutoRouter.of(context).pushNamed('/group');
            AutoRouter.of(context).push(GroupScreenRoute(group: group));
          }
          //Snackbar is displayed by joinBeacon itself on any error or trying to join expired beacon.
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8, top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70.w,
                  child: Text(
                    '${group.title} by ${group.leader!.name} ',
                    style: Style.titleTextStyle,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  'Group has $noMembers members ',
                  style: Style.commonTextStyle,
                ),
                SizedBox(height: 4.0),
                Text(
                  'Group has $noBeacons beacons ',
                  style: Style.commonTextStyle,
                ),
                // SizedBox(height: 4.0),
                Row(
                  children: [
                    Text('Passkey: ${group.shortcode}',
                        style: Style.commonTextStyle),
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: group.shortcode.toString()));
                          utils.showSnackBar('Shortcode copied!', context);
                        },
                        icon: Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 15,
                        ))
                  ],
                )
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: kBlue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
      ),
    );
  }

  static ListView getPlaceholder() {
    final BorderRadius borderRadius = BorderRadius.circular(10.0);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: 3,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            height: 110,
            decoration: BoxDecoration(
              color: kBlue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, bottom: 10.0, right: 15.0),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: SkeletonAnimation(
                      child: Container(
                        height: 15.0,
                        decoration: BoxDecoration(color: shimmerSkeletonColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 30.0, bottom: 10.0),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: SkeletonAnimation(
                      child: Container(
                        height: 10.0,
                        decoration: BoxDecoration(color: shimmerSkeletonColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 45.0, bottom: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SkeletonAnimation(
                      child: Container(
                        height: 10.0,
                        decoration: BoxDecoration(color: shimmerSkeletonColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 60.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SkeletonAnimation(
                      child: Container(
                        height: 10.0,
                        decoration: BoxDecoration(color: shimmerSkeletonColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
