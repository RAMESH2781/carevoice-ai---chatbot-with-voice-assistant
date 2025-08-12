import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageContextMenuWidget extends StatelessWidget {
  final VoidCallback? onCopyText;
  final VoidCallback? onShareSnippet;
  final VoidCallback? onAddToNotes;
  final VoidCallback? onSetReminder;
  final VoidCallback? onClose;

  const MessageContextMenuWidget({
    Key? key,
    this.onCopyText,
    this.onShareSnippet,
    this.onAddToNotes,
    this.onSetReminder,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            icon: 'content_copy',
            title: 'Copy Text',
            onTap: () {
              onCopyText?.call();
              onClose?.call();
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: 'share',
            title: 'Share Snippet',
            onTap: () {
              onShareSnippet?.call();
              onClose?.call();
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: 'note_add',
            title: 'Add to Notes',
            onTap: () {
              onAddToNotes?.call();
              onClose?.call();
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: 'alarm_add',
            title: 'Set Reminder',
            onTap: () {
              onSetReminder?.call();
              onClose?.call();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 50.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 20,
              color: AppTheme.darkTheme.colorScheme.onSurface,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.3),
    );
  }
}
