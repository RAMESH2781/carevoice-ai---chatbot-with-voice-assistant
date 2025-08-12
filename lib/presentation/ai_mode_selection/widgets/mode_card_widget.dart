import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ModeCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String iconName;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isSelected;
  final VoidCallback onTap;

  const ModeCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.iconName,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isSelected ? 85.w : 75.w,
        height: isSelected ? 28.h : 24.h,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withValues(alpha: 0.2),
              secondaryColor.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : AppTheme.darkTheme.colorScheme.outline,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppTheme.shadowDark,
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Orb Preview
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 16.w : 12.w,
                height: isSelected ? 16.w : 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.8),
                      secondaryColor.withValues(alpha: 0.6),
                      primaryColor.withValues(alpha: 0.3),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.5),
                      blurRadius: isSelected ? 15 : 10,
                      spreadRadius: isSelected ? 3 : 1,
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: Colors.white,
                    size: isSelected ? 8.w : 6.w,
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Title
              Text(
                title,
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: isSelected ? primaryColor : AppTheme.textPrimaryDark,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: isSelected ? 16.sp : 14.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),

              // Description
              Expanded(
                child: Text(
                  description,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryDark,
                    fontSize: 11.sp,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
