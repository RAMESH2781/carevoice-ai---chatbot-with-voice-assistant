import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteEditorWidget extends StatefulWidget {
  final Map<String, dynamic>? existingNote;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const NoteEditorWidget({
    Key? key,
    this.existingNote,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<NoteEditorWidget> createState() => _NoteEditorWidgetState();
}

class _NoteEditorWidgetState extends State<NoteEditorWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'general';
  String _selectedAiMode = 'Friendly Advisor';
  bool _isListening = false;
  bool _hasReminder = false;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'General Health', 'value': 'general', 'icon': 'note_alt'},
    {'label': 'Medications', 'value': 'medications', 'icon': 'medication'},
    {
      'label': 'Appointments',
      'value': 'appointments',
      'icon': 'calendar_today'
    },
    {'label': 'Symptoms', 'value': 'symptoms', 'icon': 'health_and_safety'},
  ];

  final List<String> _aiModes = [
    'Friendly Advisor',
    'Professional Doctor',
    'Fitness Coach',
    'Mental Wellness Guide',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      _titleController.text = widget.existingNote!['title'] as String;
      _contentController.text = widget.existingNote!['content'] as String;
      _selectedCategory = widget.existingNote!['category'] as String;
      _selectedAiMode = widget.existingNote!['aiMode'] as String;
      _hasReminder = widget.existingNote!['hasReminder'] as bool? ?? false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleVoiceInput() {
    setState(() {
      _isListening = !_isListening;
    });

    // Simulate voice input completion after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
        // Simulate adding voice transcription to content
        if (_contentController.text.isNotEmpty) {
          _contentController.text += '\n\n';
        }
        _contentController.text +=
            'Voice input: Blood pressure reading 120/80 mmHg, feeling good today.';
      }
    });
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title for your note')),
      );
      return;
    }

    final note = {
      'id': widget.existingNote?['id'] ?? DateTime.now().millisecondsSinceEpoch,
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'category': _selectedCategory,
      'aiMode': _selectedAiMode,
      'hasReminder': _hasReminder,
      'createdDate': widget.existingNote?['createdDate'] ??
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      'preview': _contentController.text.trim().length > 100
          ? '${_contentController.text.trim().substring(0, 100)}...'
          : _contentController.text.trim(),
    };

    widget.onSave(note);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text('Cancel'),
                ),
                Spacer(),
                Text(
                  widget.existingNote != null ? 'Edit Note' : 'New Note',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: _saveNote,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title input
                  TextField(
                    controller: _titleController,
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                    decoration: InputDecoration(
                      hintText: 'Note title...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Category selection
                  Text(
                    'Category',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected =
                            _selectedCategory == category['value'];
                        return Container(
                          margin: EdgeInsets.only(right: 2.w),
                          child: FilterChip(
                            selected: isSelected,
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: category['icon']!,
                                  color: isSelected
                                      ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(category['label']!),
                              ],
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = category['value']!;
                                });
                              }
                            },
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.surface,
                            selectedColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            labelStyle: AppTheme
                                .lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // AI Mode selection
                  Text(
                    'AI Mode Source',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedAiMode,
                        isExpanded: true,
                        items: _aiModes.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(mode),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedAiMode = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Content input with voice button
                  Row(
                    children: [
                      Text(
                        'Content',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: _handleVoiceInput,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: _isListening
                                ? AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1)
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isListening
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: _isListening ? 'mic' : 'mic_none',
                                color: _isListening
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                size: 20,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                _isListening ? 'Listening...' : 'Voice Input',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: _isListening
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    constraints: BoxConstraints(minHeight: 20.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText:
                            'Start typing or use voice input to add your health note...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(4.w),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Reminder toggle
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'notifications',
                        color: AppTheme.getWarningColor(false),
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Set Reminder',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Switch(
                        value: _hasReminder,
                        onChanged: (value) {
                          setState(() {
                            _hasReminder = value;
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
