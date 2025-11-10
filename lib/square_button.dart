import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({super.key, required this.icon});

  final Icon icon;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
          ),
          child: icon,
        ),
      ),
    );
  }
}



