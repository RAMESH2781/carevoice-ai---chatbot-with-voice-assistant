import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteInputWidget extends StatefulWidget {
  final Function(String)? onNoteAdded;
  final VoidCallback? onVoiceInput;

  const NoteInputWidget({
    Key? key,
    this.onNoteAdded,
    this.onVoiceInput,
  }) : super(key: key);

  @override
  State<NoteInputWidget> createState() => _NoteInputWidgetState();
}

class _NoteInputWidgetState extends State<NoteInputWidget> {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void dispose() {
    _noteController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addNote() {
    final noteText = _noteController.text.trim();
    if (noteText.isNotEmpty) {
      widget.onNoteAdded?.call(noteText);
      _noteController.clear();
      setState(() {
        _isExpanded = false;
      });
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    focusNode: _focusNode,
                    maxLines: _isExpanded ? 4 : 1,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add a note to this conversation...',
                      hintStyle:
                          AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    onSubmitted: (_) => _addNote(),
                  ),
                ),
                SizedBox(width: 2.w),

                // Voice input button
                GestureDetector(
                  onTap: widget.onVoiceInput,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'mic',
                      size: 20,
                      color: AppTheme.darkTheme.colorScheme.primary,
                    ),
                  ),
                ),

                SizedBox(width: 2.w),

                // Send button
                GestureDetector(
                  onTap: _addNote,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _noteController.text.trim().isNotEmpty
                          ? AppTheme.darkTheme.colorScheme.primary
                          : AppTheme.darkTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'send',
                      size: 20,
                      color: _noteController.text.trim().isNotEmpty
                          ? Colors.white
                          : AppTheme.darkTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expanded controls
          if (_isExpanded)
            Container(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Character count
                  Text(
                    '${_noteController.text.length}/500',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),

                  // Action buttons
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _noteController.clear();
                          setState(() {
                            _isExpanded = false;
                          });
                          _focusNode.unfocus();
                        },
                        child: Text(
                          'Cancel',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.darkTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      ElevatedButton(
                        onPressed: _noteController.text.trim().isNotEmpty
                            ? _addNote
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.darkTheme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Add Note',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
