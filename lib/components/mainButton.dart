import 'package:flutter/material.dart';

class mainButton extends StatelessWidget {
  final String text;
  final onPressed;
  const mainButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      color: Colors.amber,
      padding: EdgeInsets.all(15),
      // border
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      onPressed: () => onPressed(),
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}
