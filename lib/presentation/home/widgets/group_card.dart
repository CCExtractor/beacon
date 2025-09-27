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
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupCard extends StatelessWidget {
  final GroupEntity group;
  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final memberCount = group.members?.length ?? 0;
    final beaconCount = group.beacons?.length ?? 0;
    final isMember =
        group.members?.any((m) => m?.id == localApi.userModel.id) ?? false;
    final isLeader = group.leader?.id == localApi.userModel.id;

    return GestureDetector(
      onTap: () => _handleGroupTap(context, isLeader || isMember),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Slidable(
          key: ValueKey(group.id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                padding: EdgeInsets.zero,
                onPressed: (context) =>
                    context.read<HomeCubit>().changeShortCode(group),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                icon: Icons.code,
                label: 'Change Code',
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGroupHeader(context),
                SizedBox(height: 1.h),
                _buildMemberInfo(context, memberCount),
                SizedBox(height: 0.5.h),
                _buildBeaconInfo(context, beaconCount),
                SizedBox(height: 0.5.h),
                _buildShortcodeRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.groups_rounded, color: Colors.grey, size: 20.sp),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            '${group.title?.toUpperCase() ?? ''} by ${group.leader?.name ?? ''}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberInfo(BuildContext context, int count) {
    return Row(
      children: [
        Text(
          'Group has $count ${count == 1 ? 'member' : 'members'}',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildBeaconInfo(BuildContext context, int count) {
    return Text(
      'Group has $count ${count == 1 ? 'beacon' : 'beacons'}',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildShortcodeRow(BuildContext context) {
    return Row(
      children: [
        Text(
          'Passkey: ${group.shortcode ?? ''}',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(width: 2.w),
        GestureDetector(
          onTap: () => _copyShortcode(context),
          child: Icon(
            Icons.copy,
            size: 16.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Future<void> _handleGroupTap(BuildContext context, bool hasAccess) async {
    if (hasAccess) {
      await _navigateToGroupScreen(context, group);
    } else {
      await _joinAndNavigateToGroup(context);
    }
  }

  Future<void> _navigateToGroupScreen(
      BuildContext context, GroupEntity group) async {
    final homeCubit = locator<HomeCubit>();
    homeCubit.updateCurrentGroupId(group.id!);
    await appRouter.push(GroupScreenRoute(group: group));
    homeCubit.resetGroupActivity(groupId: group.id!);
    homeCubit.updateCurrentGroupId(null);
  }

  Future<void> _joinAndNavigateToGroup(BuildContext context) async {
    final homeUseCase = locator<HomeUseCase>();
    final state = await homeUseCase.joinGroup(group.shortcode!);

    if (state is DataSuccess && state.data != null) {
      await _navigateToGroupScreen(context, state.data!);
    }
  }

  void _copyShortcode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: group.shortcode!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shortcode copied!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
