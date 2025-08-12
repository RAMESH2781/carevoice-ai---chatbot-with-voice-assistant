import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onPlayAudio;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    this.onTap,
    this.onLongPress,
    this.onPlayAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUser = (message['isUser'] as bool?) ?? false;
    final String content = (message['content'] as String?) ?? '';
    final String timestamp = (message['timestamp'] as String?) ?? '';
    final bool hasAudio = (message['hasAudio'] as bool?) ?? false;
    final String? mode = message['mode'] as String?;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              _buildAvatarWidget(mode),
              SizedBox(width: 2.w),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 75.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _getBubbleColor(isUser, mode),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isUser ? 16 : 4),
                    topRight: Radius.circular(isUser ? 4 : 16),
                    bottomLeft: const Radius.circular(16),
                    bottomRight: const Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser && mode != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 1.h),
                        child: Text(
                          _getModeDisplayName(mode),
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: _getModeColor(mode).withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Text(
                      content,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: isUser
                            ? AppTheme.darkTheme.colorScheme.onSurface
                            : AppTheme.darkTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasAudio)
                          GestureDetector(
                            onTap: onPlayAudio,
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomIconWidget(
                                iconName: 'play_arrow',
                                size: 16,
                                color: isUser
                                    ? AppTheme.darkTheme.colorScheme.onSurface
                                    : AppTheme.darkTheme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        if (hasAudio) SizedBox(width: 2.w),
                        Text(
                          timestamp,
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: (isUser
                                    ? AppTheme.darkTheme.colorScheme.onSurface
                                    : AppTheme.darkTheme.colorScheme.onSurface)
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isUser) ...[
              SizedBox(width: 2.w),
              _buildUserAvatar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWidget(String? mode) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            _getModeColor(mode ?? 'friendly'),
            _getModeColor(mode ?? 'friendly').withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _getModeColor(mode ?? 'friendly').withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomIconWidget(
        iconName: _getModeIcon(mode ?? 'friendly'),
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.darkTheme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.darkTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomIconWidget(
        iconName: 'person',
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Color _getBubbleColor(bool isUser, String? mode) {
    if (isUser) {
      return AppTheme.darkTheme.colorScheme.primary.withValues(alpha: 0.9);
    }
    return AppTheme.darkTheme.colorScheme.surface;
  }

  Color _getModeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'professional':
        return AppTheme.darkTheme.colorScheme.tertiary;
      case 'fitness':
        return const Color(0xFF10B981);
      case 'wellness':
        return AppTheme.darkTheme.colorScheme.secondary;
      default:
        return AppTheme.darkTheme.colorScheme.primary;
    }
  }

  String _getModeIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'professional':
        return 'medical_services';
      case 'fitness':
        return 'fitness_center';
      case 'wellness':
        return 'psychology';
      default:
        return 'favorite';
    }
  }

  String _getModeDisplayName(String mode) {
    switch (mode.toLowerCase()) {
      case 'professional':
        return 'Professional Doctor';
      case 'fitness':
        return 'Fitness Coach';
      case 'wellness':
        return 'Wellness Guide';
      default:
        return 'Friendly Advisor';
    }
  }
}
