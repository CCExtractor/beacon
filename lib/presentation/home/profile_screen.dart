import 'package:beacon/locator.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileScreen extends StatefulWidget {
  final HomeCubit homeCubit;
  const ProfileScreen({super.key, required this.homeCubit});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showSelectImage = false;
  int selectedImageIndex = -1;

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          showSelectImage == true
              ? SizedBox(
                  height: 45.h,
                  width: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate the number of columns based on screen width
                      int columns = (constraints.maxWidth / 100).floor();

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns, // Number of columns
                          crossAxisSpacing: 10, // Space between columns
                          mainAxisSpacing: 10, // Space between rows
                        ),
                        itemCount: imageOptions.length, // Total number of items
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImageIndex = index;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: selectedImageIndex == index
                                    ? Colors.deepPurple
                                    : Colors.transparent,
                                width: 2,
                              ),
                              color: Colors.grey.shade200,
                              image: DecorationImage(
                                image: NetworkImage(imageOptions[index]),
                                fit: BoxFit.cover,
                              ),
                            )),
                          );
                        },
                      );
                    },
                  ),
                )
              : Center(),

          SizedBox(height: 2.h),

          // -- IMAGE with ICON
          Stack(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Container(
                    decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.shade200,
                  image: DecorationImage(
                    image: selectedImageIndex != -1
                        ? NetworkImage(imageOptions[selectedImageIndex])
                        : NetworkImage(localApi.userModel.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                )),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    print("select image clicked");
                    print("showSelectImage: $showSelectImage");
                    setState(() {
                      showSelectImage = !showSelectImage;
                    });
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.deepPurple,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // -- Form Fields
          !showSelectImage
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: TextFormField(
                        readOnly: true,
                        initialValue: localApi.userModel.name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: TextFormField(
                        readOnly: true,
                        initialValue: localApi.userModel.email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                )
              : const SizedBox(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: HikeButton(
              buttonWidth: double.infinity,
              buttonHeight: 6.h,
              text: 'Update Profile Image',
              textSize: 14.sp,
              onTap: () {
                if (selectedImageIndex != -1) {
                  localApi.userModel.copyWithModel(
                    imageUrl: imageOptions[selectedImageIndex],
                  );
                  widget.homeCubit.updateUserImage(
                    localApi.userModel.id!,
                    imageOptions[selectedImageIndex],
                  );
                  setState(() {
                    showSelectImage = false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an image')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
