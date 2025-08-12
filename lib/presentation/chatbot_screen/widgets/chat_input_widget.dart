import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isLoading;

  const ChatInputWidget({
    Key? key,
    required this.controller,
    required this.onSend,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleSend() {
    final message = widget.controller.text.trim();
    if (message.isNotEmpty && !widget.isLoading) {
      widget.onSend(message);
      widget.controller.clear();
      HapticFeedback.lightImpact();
    }
  }

  void _handleSubmitted(String value) {
    _handleSend();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Text input field
          Expanded(
            child: TextField(
              controller: widget.controller,
              onSubmitted: _handleSubmitted,
              enabled: !widget.isLoading,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkTheme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 3.h,
                ),
                suffixIcon: widget.isLoading
                    ? Padding(
                        padding: EdgeInsets.all(4.w),
                        child: SizedBox(
                          width: 4.w,
                          height: 4.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),

          // Send button
          Container(
            margin: EdgeInsets.only(right: 1.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _hasText && !widget.isLoading ? _handleSend : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hasText && !widget.isLoading
                        ? AppTheme.darkTheme.colorScheme.primary
                        : AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'send',
                      color: _hasText && !widget.isLoading
                          ? AppTheme.darkTheme.colorScheme.onPrimary
                          : AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      size: 5.w,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
