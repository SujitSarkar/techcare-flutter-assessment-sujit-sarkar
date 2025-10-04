import 'package:flutter/material.dart';
import 'package:take_home/core/constants/app_strings.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text(AppStrings.dashboard)));
  }
}
