import 'package:auto_route/auto_route.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_state.dart';
import 'package:beacon/presentation/group/cubit/members_cubit/members_cubit.dart';
import 'package:beacon/presentation/group/widgets/create_join_dialog.dart';
import 'package:beacon/presentation/group/widgets/beacon_card.dart';
import 'package:beacon/presentation/group/widgets/group_widgets.dart';
import 'package:beacon/presentation/widgets/screen_template.dart';
import 'package:beacon/presentation/widgets/shimmer.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/widgets/loading_screen.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class GroupScreen extends StatefulWidget {
  final GroupEntity group;
  const GroupScreen(this.group, {super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  late GroupCubit _groupCubit;
  late MembersCubit _membersCubit;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _groupCubit = context.read<GroupCubit>();
    _membersCubit = context.read<MembersCubit>();
    _initializeData();
  }

  void _initializeData() {
    _groupCubit.init(widget.group);
    _groupCubit.allHikes(widget.group.id!);
    _membersCubit.init(widget.group);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = _groupCubit.state;
      if (state is AllBeaconGroupState && !state.isCompletelyFetched) {
        _groupCubit.allHikes(widget.group.id!);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _groupCubit.clear();
    _membersCubit.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeaconScreenTemplate(
      body: BlocConsumer<GroupCubit, GroupState>(
        listener: (context, state) {
          if (state is AllBeaconGroupState && state.message != null) {
            utils.showSnackBar(state.message!, context);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is LoadingGroupState,
            progressIndicator: const LoadingScreen(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Column(
                children: [
                  _buildGroupHeader(),
                  SizedBox(height: 2.h),
                  _buildMembersSection(),
                  SizedBox(height: 3.h),
                  _buildActionButtons(),
                  SizedBox(height: 3.h),
                  _buildBeaconsHeader(),
                  SizedBox(height: 1.h),
                  Expanded(child: _buildBeaconsList(state)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => context.router.maybePop(),
        ),
        Image.asset('images/beacon_logo.png', height: 4.h),
        IconButton(
          icon: const Icon(Icons.power_settings_new, color: Colors.grey),
          onPressed: _showLogoutDialog,
        ),
      ],
    );
  }

  Widget _buildGroupHeader() {
    return Row(
      children: [
        Text(
          'Welcome to Group ',
          style: TextStyle(fontSize: 18.sp),
        ),
        SizedBox(width: 2.w),
        Text(
          widget.group.title ?? '',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection() {
    final memberCount = (widget.group.members?.length ?? 0) + 1;
    print("leaders image: ${widget.group.leader?.imageUrl}");
    return Row(
      children: [
        if (widget.group.members?.isNotEmpty ?? false)
          SizedBox(
            width: 10.w *
                (widget.group.members!.length > 3
                    ? 3
                    : widget.group.members!.length),
            height: 5.h,
            child: Stack(
              children: (widget.group.members!.length > 3
                      ? widget.group.members!.sublist(0, 3)
                      : widget.group.members!)
                  .map((member) => Positioned(
                        left: widget.group.members!.indexOf(member) * 8.w,
                        child: _buildProfileCircle(member?.imageUrl),
                      ))
                  .toList(),
            ),
          ),
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group has $memberCount ${memberCount == 1 ? 'member' : 'members'}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            SizedBox(height: 0.5.h),
            GestureDetector(
              onTap: () => GroupWidgetUtils.showMembers(context),
              child: Text(
                "View all members",
                style: TextStyle(
                  fontSize: 14.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: HikeButton(
            text: 'Create Hike',
            widget: Icon(
              Icons.add,
              size: 18.sp,
              color: Colors.white,
            ),
            buttonWidth: double.infinity,
            buttonHeight: 6.h,
            onTap: () => CreateJoinBeaconDialog.createHikeDialog(
                context, widget.group.id!),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: HikeButton(
            text: 'Join a Hike',
            widget: Icon(Icons.add, size: 18.sp),
            buttonWidth: double.infinity,
            buttonHeight: 6.h,
            isDotted: true,
            onTap: () => CreateJoinBeaconDialog.joinBeaconDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBeaconsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'All Beacons',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        IconButton(
          icon: Icon(Icons.filter_alt_outlined, color: Colors.purple),
          onPressed: () => GroupWidgetUtils.showFilterBeaconAlertBox(
              context, widget.group.id!, _groupCubit),
        ),
      ],
    );
  }

  Widget _buildBeaconsList(GroupState state) {
    if (state is ShrimmerGroupState) {
      return Center(child: ShimmerWidget.getPlaceholder());
    } else if (state is AllBeaconGroupState) {
      return _buildBeaconListView(
        state.beacons,
        state.isLoadingMore,
        state.isCompletelyFetched,
        'You haven\'t joined or created any beacon yet',
      );
    } else if (state is NearbyBeaconGroupState) {
      return _buildBeaconListView(
        state.beacons,
        false,
        false,
        'No beacons found under ${state.radius.toStringAsFixed(2)} m radius',
      );
    } else if (state is StatusFilterBeaconGroupState) {
      final type = state.type!.name;
      return _buildBeaconListView(
        state.beacons,
        false,
        false,
        'No ${type[0].toUpperCase() + type.substring(1).toLowerCase()} beacons found',
      );
    } else if (state is ErrorGroupState) {
      return _buildErrorWidget(state.message);
    }
    return _buildErrorWidget('Something went wrong!');
  }

  Widget _buildBeaconListView(
    List<BeaconEntity> beacons,
    bool isLoadingMore,
    bool isCompletelyFetched,
    String emptyMessage,
  ) {
    return beacons.isEmpty
        ? _buildEmptyState(emptyMessage)
        : ListView.builder(
            controller: _scrollController,
            itemCount: beacons.length +
                (isLoadingMore && !isCompletelyFetched ? 1 : 0),
            padding: EdgeInsets.only(top: 1.h),
            itemBuilder: (context, index) {
              if (index == beacons.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: const Center(child: LinearProgressIndicator()),
                );
              }
              return BeaconCard(
                beacon: beacons[index],
                onDelete: () => _handleDeleteBeacon(beacons[index]),
                onReschedule: () => GroupWidgetUtils.reScheduleHikeDialog(
                    context, beacons[index]),
              );
            },
          );
  }

  Future<void> _handleDeleteBeacon(BeaconEntity beacon) async {
    final shouldDelete = await GroupWidgetUtils.deleteDialog(context);
    if (shouldDelete == true) {
      await _groupCubit.deleteBeacon(beacon);
      _groupCubit.reloadState(message: 'Beacon deleted');
    }
  }

  Widget _buildEmptyState(String message) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('animations/empty.json', width: 50.w, height: 25.h),
          SizedBox(height: 3.h),
          Text(message, style: TextStyle(fontSize: 16.sp)),
          SizedBox(height: 3.h),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16.sp),
              children: [
                const TextSpan(
                    text: 'Join',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ' a Hike or '),
                const TextSpan(
                    text: 'Create',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ' a new one!'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(message, style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 2.h),
            FloatingActionButton(
              onPressed: () => locationService.openSettings(),
              child: const Icon(Icons.settings),
              backgroundColor: kYellow,
            ),
            SizedBox(height: 2.h),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16.sp),
                children: [
                  const TextSpan(
                      text: 'Join',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' a Hike or '),
                  const TextSpan(
                      text: 'Create',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' a new one!'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCircle(String? imageUrl) {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
        border: Border.all(color: Colors.white, width: 1.w),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Logout', style: TextStyle(fontSize: 18.sp)),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HikeButton(
                buttonWidth: 25.w,
                buttonHeight: 5.h,
                isDotted: true,
                onTap: () => context.router.maybePop(false),
                text: 'No',
                textSize: 14.sp,
              ),
              HikeButton(
                buttonWidth: 25.w,
                buttonHeight: 5.h,
                onTap: () {
                  context.router.replaceNamed('/auth');
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
}
