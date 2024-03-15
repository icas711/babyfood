import 'package:flutter/material.dart';

class LoginTextFieldDecoration extends StatelessWidget {
  final Widget child;

  const LoginTextFieldDecoration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: child,
        ),
      ),
    );
  }
}
