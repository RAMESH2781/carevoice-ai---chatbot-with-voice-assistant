import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isUser;
  final bool showTimestamp;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
    this.showTimestamp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Timestamp
          if (showTimestamp)
            Container(
              margin: EdgeInsets.only(bottom: 1.h),
              child: Text(
                _formatTimestamp(message['timestamp']),
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Message bubble
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar (for AI messages)
              if (!isUser) ...[
                Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.only(right: 2.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.darkTheme.colorScheme.primary,
                        AppTheme.darkTheme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'smart_toy',
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                ),
              ],

              // Message content
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 70.w,
                  ),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppTheme.darkTheme.colorScheme.primary
                        : AppTheme.darkTheme.colorScheme.surface.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                            color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message text
                      Text(
                        message['content'],
                        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: isUser
                              ? AppTheme.darkTheme.colorScheme.onPrimary
                              : AppTheme.darkTheme.colorScheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                      
                      // Error indicator for error messages
                      if (message['messageType'] == 'error')
                        Container(
                          margin: EdgeInsets.only(top: 1.h),
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.darkTheme.colorScheme.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'error',
                                color: AppTheme.darkTheme.colorScheme.error,
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Error occurred',
                                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.darkTheme.colorScheme.error,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Avatar (for user messages)
              if (isUser) ...[
                Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.only(left: 2.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.darkTheme.colorScheme.secondary,
                        AppTheme.darkTheme.colorScheme.tertiary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Message status (for user messages)
          if (isUser)
            Container(
              margin: EdgeInsets.only(top: 0.5.h, right: 10.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check',
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Delivered',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
