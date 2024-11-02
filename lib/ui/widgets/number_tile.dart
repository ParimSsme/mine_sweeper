import 'package:flutter/material.dart';

class NumberTile extends StatelessWidget {
  final number;
  bool revealed;
  final onPressed;
  NumberTile({super.key, this.number, required this.revealed, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: revealed ? Colors.grey[300] : Colors.grey[400],
          child: Center(
            child: Text(
              revealed ? (number == 0 ? '' : number.toString()) : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                  color: _getNumberColor(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getNumberColor() {
    switch (number) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.orange;
      case 6:
        return Colors.teal;
      case 7:
        return Colors.brown;
      case 8:
        return Colors.black;
      default:
        return Colors.black;
    }
  }
}
