import 'package:auto_route/auto_route.dart';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/usecase/home_usecase.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:beacon/config/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

class GroupCustomWidgets {
  static final Color textColor = Color(0xFFAFAFAF);

  static Widget getGroupCard(BuildContext context, GroupEntity group) {
    String noMembers = group.members!.length.toString();
    String noBeacons = group.beacons!.length.toString();
    return GestureDetector(
      onTap: () async {
        bool isMember = false;
        for (var member in group.members!) {
          if (member!.id == localApi.userModel.id) {
            isMember = true;
          }
        }
        if (group.leader!.id == localApi.userModel.id || isMember) {
          var homeCubit = locator<HomeCubit>();
          homeCubit.updateCurrentGroupId(group.id!);
          appRouter.push(GroupScreenRoute(group: group)).then((value) {
            homeCubit.resetGroupActivity(groupId: group.id!);
            homeCubit.updateCurrentGroupId(null);
          });
        } else {
          HomeUseCase _homeUseCase = locator<HomeUseCase>();
          DataState<GroupEntity> state =
              await _homeUseCase.joinGroup(group.shortcode!);
          if (state is DataSuccess && state.data != null) {
            var homeCubit = locator<HomeCubit>();
            homeCubit.updateCurrentGroupId(group.id!);
            appRouter.push(GroupScreenRoute(group: state.data!)).then((value) {
              homeCubit.resetGroupActivity(groupId: group.id);
              homeCubit.updateCurrentGroupId(null);
            });
          }
        }
      },
      child: Slidable(
        key: ValueKey(group.id!.toString()),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: (context) {
                context.read<HomeCubit>().changeShortCode(group);
              },
              backgroundColor: kCupertinoModalBarrierColor,
              foregroundColor: kDefaultIconDarkColor,
              icon: Icons.code,
              label: 'Change Code',
            ),
          ],
        ),
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
                  Row(
                    children: [
                      Container(
                        width: 70.w,
                        child: Text(
                          '${group.title} by ${group.leader!.name} ',
                          style: Style.titleTextStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        'Group has $noMembers members ',
                        style: Style.commonTextStyle,
                      ),
                      group.hasMemberActivity
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.circle,
                                color: kYellow,
                                size: 10,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        'Group has $noBeacons beacons ',
                        style: Style.commonTextStyle,
                      ),
                      Gap(5),
                      group.hasBeaconActivity
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.circle,
                                color: kYellow,
                                size: 10,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('Passkey: ${group.shortcode}',
                          style: Style.commonTextStyle),
                      Gap(10),
                      InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: group.shortcode.toString()));
                            utils.showSnackBar('Shortcode copied!', context);
                          },
                          child: Icon(
                            Icons.copy,
                            size: 17,
                            color: Colors.white,
                          ))
                    ],
                  )
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: (group.hasMemberActivity == true ||
                    group.hasBeaconActivity == true)
                ? Color(0xFF141546)
                : kBlue,
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
