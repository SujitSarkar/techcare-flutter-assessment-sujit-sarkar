import 'package:flutter/material.dart';

class LoadingMask extends StatelessWidget {
  const LoadingMask({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1)),
      child: const CircularProgressIndicator(),
    );
  }
}
