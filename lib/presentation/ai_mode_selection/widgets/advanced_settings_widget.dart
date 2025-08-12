import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedSettingsWidget extends StatefulWidget {
  final bool isExpanded;
  final double voiceSpeed;
  final String formalityLevel;
  final bool specializedVocabulary;
  final Function(double) onVoiceSpeedChanged;
  final Function(String) onFormalityChanged;
  final Function(bool) onSpecializedVocabularyChanged;

  const AdvancedSettingsWidget({
    Key? key,
    required this.isExpanded,
    required this.voiceSpeed,
    required this.formalityLevel,
    required this.specializedVocabulary,
    required this.onVoiceSpeedChanged,
    required this.onFormalityChanged,
    required this.onSpecializedVocabularyChanged,
  }) : super(key: key);

  @override
  State<AdvancedSettingsWidget> createState() => _AdvancedSettingsWidgetState();
}

class _AdvancedSettingsWidgetState extends State<AdvancedSettingsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(AdvancedSettingsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      widget.isExpanded
          ? _animationController.forward()
          : _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.darkTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                // Settings content
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Voice Speed Setting
                        Text(
                          'Voice Speed',
                          style:
                              AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.textPrimaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'speed',
                              color: AppTheme.primaryDark,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Slider(
                                value: widget.voiceSpeed,
                                min: 0.5,
                                max: 2.0,
                                divisions: 6,
                                label:
                                    '${widget.voiceSpeed.toStringAsFixed(1)}x',
                                onChanged: widget.onVoiceSpeedChanged,
                                activeColor: AppTheme.primaryDark,
                                inactiveColor:
                                    AppTheme.primaryDark.withValues(alpha: 0.3),
                              ),
                            ),
                            Text(
                              '${widget.voiceSpeed.toStringAsFixed(1)}x',
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryDark,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),

                        // Formality Level Setting
                        Text(
                          'Formality Level',
                          style:
                              AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.textPrimaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'psychology',
                              color: AppTheme.primaryDark,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: widget.formalityLevel,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppTheme
                                          .darkTheme.colorScheme.outline,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppTheme
                                          .darkTheme.colorScheme.outline,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppTheme.primaryDark,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                dropdownColor:
                                    AppTheme.darkTheme.colorScheme.surface,
                                style: AppTheme.darkTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.textPrimaryDark,
                                ),
                                items: ['Casual', 'Professional', 'Formal']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    widget.onFormalityChanged(newValue);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),

                        // Specialized Vocabulary Setting
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'school',
                              color: AppTheme.primaryDark,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                'Use Specialized Medical Vocabulary',
                                style: AppTheme.darkTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color: AppTheme.textPrimaryDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Switch(
                              value: widget.specializedVocabulary,
                              onChanged: widget.onSpecializedVocabularyChanged,
                              activeColor: AppTheme.primaryDark,
                              activeTrackColor:
                                  AppTheme.primaryDark.withValues(alpha: 0.3),
                              inactiveThumbColor: AppTheme.textDisabledDark,
                              inactiveTrackColor: AppTheme.textDisabledDark
                                  .withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
