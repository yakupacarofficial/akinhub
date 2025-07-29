import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class TopBar extends StatefulWidget {
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSettingsTap;
  final String title;

  const TopBar({
    super.key,
    this.onNotificationsTap,
    this.onSettingsTap,
    this.title = AppConstants.appName,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late Timer _timer;
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Time Display
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.smallPadding,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  _currentTime,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // App Title
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          
          const Spacer(),
          
          // Action Buttons
          Row(
            children: [
              // Notifications Button
              IconButton(
                onPressed: widget.onNotificationsTap,
                icon: Stack(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.textSecondaryColor,
                      size: 24,
                    ),
                    // Notification badge
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                tooltip: 'Notifications',
              ),
              
              const SizedBox(width: AppConstants.smallPadding),
              
              // Settings Button
              IconButton(
                onPressed: widget.onSettingsTap,
                icon: Icon(
                  Icons.settings_outlined,
                  color: AppTheme.textSecondaryColor,
                  size: 24,
                ),
                tooltip: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
} 