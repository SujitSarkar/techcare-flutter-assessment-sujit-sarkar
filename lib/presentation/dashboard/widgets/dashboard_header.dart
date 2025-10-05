import 'package:flutter/material.dart';
import 'package:take_home/core/constants/app_assets.dart';
import 'package:take_home/core/constants/app_strings.dart';

class DashboardHeader extends StatelessWidget {
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const DashboardHeader({super.key, this.notificationCount = 0, this.onNotificationTap, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.appName,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Welcome back!',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary.withValues(alpha: 0.8)),
          ),
        ],
      ),
      actions: [
        // Notification Icon
        Badge(
          offset: const Offset(-10, 10),
          label: Text('$notificationCount'),
          child: IconButton(
            onPressed: onNotificationTap,
            icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onPrimary, size: 28),
          ),
        ),

        // Profile Avatar
        IconButton(
          onPressed: onProfileTap,
          icon: Icon(Icons.person, color: theme.colorScheme.onPrimary, size: 28),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(Assets.assetsImagesHeader), fit: BoxFit.cover),
          ),
          child: Container(color: Colors.black54, height: double.infinity, width: double.infinity),
        ),
      ),
    );
  }
}
