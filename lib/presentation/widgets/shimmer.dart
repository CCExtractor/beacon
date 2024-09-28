import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ShimmerWidget {
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
