import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricPromptWidget extends StatelessWidget {
  final bool isVisible;
  final Function() onEnableBiometric;
  final Function() onSkipBiometric;
  final String biometricType;

  const BiometricPromptWidget({
    Key? key,
    required this.isVisible,
    required this.onEnableBiometric,
    required this.onSkipBiometric,
    required this.biometricType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkTheme.colorScheme.shadow,
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Biometric Icon
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color:
                  AppTheme.darkTheme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: biometricType == 'face' ? 'face' : 'fingerprint',
                color: AppTheme.darkTheme.colorScheme.primary,
                size: 8.w,
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Title
          Text(
            'Enable ${biometricType == 'face' ? 'Face ID' : 'Fingerprint'}?',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),

          // Description
          Text(
            'Use ${biometricType == 'face' ? 'Face ID' : 'your fingerprint'} to sign in quickly and securely to CareVoice AI.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),

          // Action Buttons
          Row(
            children: [
              // Skip Button
              Expanded(
                child: OutlinedButton(
                  onPressed: onSkipBiometric,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppTheme.darkTheme.colorScheme.outline,
                      width: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                  child: Text(
                    'Skip',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),

              // Enable Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onEnableBiometric,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkTheme.colorScheme.primary,
                    foregroundColor: AppTheme.darkTheme.colorScheme.onPrimary,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                  child: Text(
                    'Enable',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
