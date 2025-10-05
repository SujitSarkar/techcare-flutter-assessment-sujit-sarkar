import 'package:flutter/material.dart';
import 'package:take_home/core/constants/app_strings.dart';

class DashboardHeader extends StatelessWidget {
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const DashboardHeader({super.key, this.notificationCount = 0, this.onNotificationTap, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Status bar spacing
            const SizedBox(height: 8),

            // Main content row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome back!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right side - Notifications and Profile
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Notification Icon
                    Stack(
                      children: [
                        IconButton(
                          onPressed: onNotificationTap,
                          icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onPrimary, size: 28),
                        ),
                        if (notificationCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                              child: Text(
                                '$notificationCount',
                                style: TextStyle(
                                  color: theme.colorScheme.onError,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 8),

                    // Profile Avatar
                    GestureDetector(
                      onTap: onProfileTap,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: theme.colorScheme.onPrimary.withValues(alpha: 0.3), width: 2),
                        ),
                        child: Icon(Icons.person, color: theme.colorScheme.onPrimary, size: 24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
