import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/usecase/home_usecase.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/config/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GroupCard extends StatelessWidget {
  final GroupEntity group;
  GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
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
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 14),
        //padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Slidable(
          key: ValueKey(group.id!.toString()),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                padding: EdgeInsets.symmetric(horizontal: 0),
                onPressed: (context) {
                  context.read<HomeCubit>().changeShortCode(group);
                },
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                icon: Icons.code,
                label: 'Change Code',
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.groups_2_rounded, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      '${group.title.toString().toUpperCase()} by ${group.leader!.name} ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Stack of profile circles
                    // noMembers != "0"
                    //     ? SizedBox(
                    //         width: 30 * group.members!.length.toDouble(),
                    //         // 30 is the width of each profile circle
                    //         height: 30,
                    //         child: Stack(
                    //           children:
                    //               (group.members != null && group.members!.length > 3
                    //                       ? group.members!.sublist(0, 3)
                    //                       : group.members ?? [])
                    //                   .map((member) {
                    //             if (member != null) {
                    //               return Positioned(
                    //                 left: group.members!.indexOf(member) * 20.0,
                    //                 child: _buildProfileCircle(
                    //                   member.id == localApi.userModel.id
                    //                       ? Colors.teal
                    //                       : Colors.grey,
                    //                 ),
                    //               );
                    //             } else {
                    //               return const SizedBox.shrink();
                    //             }
                    //           }).toList(),
                    //         ),
                    //       )
                    //     : Container(),
                    Text(
                      'Group has $noMembers members ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Group has $noBeacons ${noBeacons == '1' ? 'beacon' : 'beacons'} ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Passkey: ${group.shortcode}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: group.shortcode!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Shortcode copied!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.copy,
                        size: 17,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
