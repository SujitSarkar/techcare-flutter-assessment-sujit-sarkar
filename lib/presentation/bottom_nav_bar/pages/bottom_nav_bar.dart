import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/presentation/analytics/pages/analytics_page.dart';
import 'package:take_home/presentation/bottom_nav_bar/bloc/bottom_nav_bar_bloc.dart';
import 'package:take_home/presentation/dashboard/pages/dashboard_page.dart';
import 'package:take_home/presentation/transactions/pages/transactions_page.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
      builder: (context, state) {
        final currentIndex = state is BottomNavBarChangedState ? state.selectedIndex : 0;

        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: const [DashboardPage(), AnalyticsPage(), TransactionsPage()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (int index) {
              context.read<BottomNavBarBloc>().add(BottomNavBarTabChangedEvent(index));
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: AppStrings.home),
              BottomNavigationBarItem(icon: Icon(Icons.analytics), label: AppStrings.analytics),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: AppStrings.transactions),
            ],
          ),
        );
      },
    );
  }
}
