import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Image.asset("assets/images/logo.png", width: 40, height: 40),
        ),
      ),
    );
  }
}
