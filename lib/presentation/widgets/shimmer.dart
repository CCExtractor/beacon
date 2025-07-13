import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget {
  static ListView getPlaceholder() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        return _ShimmerCard();
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: index == 3 ? 0 : 8.0),
                      child: Container(
                        height: 10,
                        width: _getLineWidth(index, context),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  double _getLineWidth(int index, BuildContext context) {
    switch (index) {
      case 0:
        return MediaQuery.of(context).size.width * 0.5;
      case 1:
        return MediaQuery.of(context).size.width * 0.4;
      case 2:
        return MediaQuery.of(context).size.width * 0.3;
      default:
        return MediaQuery.of(context).size.width * 0.2;
    }
  }
}
