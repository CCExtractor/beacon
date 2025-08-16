import 'package:auto_route/annotations.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/widgets/screen_template.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showSelectImage = false;
  int selectedImageIndex = -1;
  int selectedBadgeCategory = 0;

  final List<String> badgeCategories = [
    'All',
    'Exploration',
    'Social',
    'Achievements',
    'Milestones'
  ];

  final List<String> imageOptions = [
    "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_2.png",
    "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_3.png",
    "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_5.png",
    "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_35.png",
    "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_34.png",
    "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_8.png",
    "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_10.png",
    "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_16.png",
    "https://cdn.jsdelivr.net/gh/alohe/avatars/png/memo_24.png",
  ];

  @override
  void initState() {
    super.initState();
    selectedImageIndex =
        imageOptions.indexOf(localApi.userModel.imageUrl ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return BeaconScreenTemplate(
      showLogout: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              if (showSelectImage) _buildImageSelectionGrid(),
              _buildProfilePicture(),
              SizedBox(height: 3.h),
              if (!showSelectImage) ...[
                _buildProfileInfoCard(),
                SizedBox(height: 3.h),
                _buildGamificationSection(),
              ],
              if (showSelectImage) _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelectionGrid() {
    return Container(
      height: 45.h,
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int columns = (constraints.maxWidth / 100).floor();
          return GridView.builder(
            padding: EdgeInsets.all(2.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 2.w,
              childAspectRatio: 1,
            ),
            itemCount: imageOptions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() => selectedImageIndex = index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: selectedImageIndex == index
                          ? Colors.deepPurple
                          : Colors.transparent,
                      width: 2,
                    ),
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage(imageOptions[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.deepPurple, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              selectedImageIndex != -1
                  ? imageOptions[selectedImageIndex]
                  : localApi.userModel.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.person,
                size: 20.w,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => setState(() => showSelectImage = !showSelectImage),
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                showSelectImage ? Icons.close : Icons.camera_alt,
                color: Colors.white,
                size: 4.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.deepPurple),
              title: Text(
                'Name',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              subtitle: Text(
                localApi.userModel.name ?? 'Not provided',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
            Divider(height: 1, color: Colors.grey[200]),
            ListTile(
              leading: Icon(Icons.email, color: Colors.deepPurple),
              title: Text(
                'Email',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              subtitle: Text(
                localApi.userModel.email ?? 'Not provided',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamificationSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Adventure Progress',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF673AB7),
            ),
          ),
          SizedBox(height: 2.h),
          _buildProgressBar(),
          SizedBox(height: 3.h),
          Text(
            'Earned Badges',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildBadgesGrid(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Explorer Level 2',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              '65%',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: 0.65,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          minHeight: 1.5.h,
          borderRadius: BorderRadius.circular(10),
        ),
        SizedBox(height: 1.h),
        Text(
          'Complete 3 more hikes to reach next level',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildBadgesGrid() {
    final achievements = [
      {'title': 'Trailblazer', 'earned': true, 'icon': Icons.flag},
      {'title': 'Nature Lover', 'earned': true, 'icon': Icons.forest},
      {'title': 'Pathfinder', 'earned': false, 'icon': Icons.directions},
      {'title': 'Marathoner', 'earned': false, 'icon': Icons.timer},
      {'title': 'Social Hiker', 'earned': true, 'icon': Icons.group},
      {'title': 'Peak Conqueror', 'earned': false, 'icon': Icons.star},
    ];

    if (achievements.isEmpty) {
      return _buildEmptyBadgesState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
        childAspectRatio: 0.9,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return Column(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: achievement['earned'] as bool
                    ? Colors.deepPurple
                    : Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: (achievement['earned'] as bool
                            ? Colors.deepPurple
                            : Colors.grey[300]!)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  achievement['icon'] as IconData,
                  size: 10.w,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              achievement['title'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp),
              maxLines: 2,
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyBadgesState() {
    return Column(
      children: [
        Lottie.asset(
          'animations/empty_badges.json',
          width: 50.w,
          height: 20.h,
        ),
        SizedBox(height: 2.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
            children: [
              TextSpan(text: 'No achievements yet. '),
              TextSpan(
                text: 'Start exploring and engaging to earn badges!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF673AB7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(height: 3.h),
        HikeButton(
          buttonWidth: double.infinity,
          buttonHeight: 6.h,
          text: 'Update Profile Image',
          textSize: 14.sp,
          onTap: _updateProfileImage,
        ),
        SizedBox(height: 1.h),
        HikeButton(
          buttonWidth: double.infinity,
          buttonHeight: 6.h,
          text: 'Cancel',
          textSize: 14.sp,
          isDotted: true,
          onTap: () => setState(() => showSelectImage = false),
        ),
      ],
    );
  }

  void _updateProfileImage() {
    if (selectedImageIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    HomeCubit homeCubit = locator<HomeCubit>();
    localApi.userModel.copyWithModel(
      imageUrl: imageOptions[selectedImageIndex],
    );
    homeCubit.updateUserImage(
      localApi.userModel.id!,
      imageOptions[selectedImageIndex],
    );
    setState(() => showSelectImage = false);
  }
}
