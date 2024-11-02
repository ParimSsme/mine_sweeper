import 'package:flutter/material.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: revealed ? Colors.grey[800] : Colors.grey[400],
        ),
      ),
    );
  }
}
