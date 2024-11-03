import 'package:flutter/material.dart';
import 'package:mine_sweeper/core/assets/app_image_assets.dart';

class NumberTile extends StatelessWidget {
  final int adjacentBombCount; // Number of adjacent bombs

  const NumberTile({
    super.key,
    required this.adjacentBombCount,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        _getImage(adjacentBombCount),
    );
  }

  // Helper function to determine the color based on bomb count
  String _getImage(int? count) {
    switch (count) {
      case 1:
        return AppImageAssets.one;
      case 2:
        return AppImageAssets.two;
      case 3:
        return AppImageAssets.three;
      case 4:
        return AppImageAssets.four;
      case 5:
        return AppImageAssets.five;
      case 6:
        return AppImageAssets.six;
      case 7:
        return AppImageAssets.seven;
      case 8:
        return AppImageAssets.eight;
      default:
        return AppImageAssets.none;
    }
  }
}
