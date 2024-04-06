import 'package:flutter/material.dart';

class MyNumberBox extends StatelessWidget {
  final child;
  bool revealed;
  final function;
  MyNumberBox({super.key, this.child, required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: revealed ? Colors.grey[300] : Colors.grey[400],
          child: Center(
            child: Text(
              revealed ? (child == 0 ? '' : child.toString()) : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: child == 1
                    ? Colors.blue
                    : (child == 2 ? Colors.green : Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
