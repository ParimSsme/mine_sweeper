import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BombTile extends StatelessWidget {
  bool revealed;
  final function;
  BombTile({
    super.key,
    required this.revealed,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: revealed
          ? Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                color: revealed ? Colors.grey[800] : Colors.grey[400],
              ),
            )
          : SvgPicture.asset('assets/svgs/inset_box.svg'),
    );
  }
}
