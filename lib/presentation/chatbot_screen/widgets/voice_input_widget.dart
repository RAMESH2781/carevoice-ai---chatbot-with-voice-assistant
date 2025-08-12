import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final bool isListening;
  final bool isProcessing;
  final VoidCallback onPressed;

  const VoiceInputWidget({
    Key? key,
    required this.isListening,
    required this.isProcessing,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(VoiceInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isListening && !oldWidget.isListening) {
      _startListeningAnimations();
    } else if (!widget.isListening && oldWidget.isListening) {
      _stopListeningAnimations();
    }
  }

  void _startListeningAnimations() {
    _pulseController.repeat(reverse: true);
    _rippleController.repeat();
  }

  void _stopListeningAnimations() {
    _pulseController.stop();
    _rippleController.stop();
    _pulseController.reset();
    _rippleController.reset();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isProcessing) {
          HapticFeedback.lightImpact();
        }
      },
      onTapUp: (_) {
        if (!widget.isProcessing) {
          widget.onPressed();
        }
      },
      onTapCancel: () {
        if (!widget.isProcessing) {
          widget.onPressed();
        }
      },
      child: Container(
        width: 14.w,
        height: 14.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: widget.isListening
                ? [
                    AppTheme.darkTheme.colorScheme.error,
                    AppTheme.darkTheme.colorScheme.error.withValues(alpha: 0.8),
                  ]
                : [
                    AppTheme.darkTheme.colorScheme.primary,
                    AppTheme.darkTheme.colorScheme.secondary,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: (widget.isListening
                      ? AppTheme.darkTheme.colorScheme.error
                      : AppTheme.darkTheme.colorScheme.primary)
                  .withValues(alpha: 0.3),
              blurRadius: widget.isListening ? 20 : 10,
              spreadRadius: widget.isListening ? 5 : 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Ripple effect when listening
            if (widget.isListening)
              Center(
                child: AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _rippleAnimation.value,
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.darkTheme.colorScheme.error.withValues(
                              alpha: 1.0 - (_rippleAnimation.value - 1.0),
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Main button content
            Center(
              child: AnimatedBuilder(
                animation: widget.isListening ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                builder: (context, child) {
                  return Transform.scale(
                    scale: widget.isListening ? _pulseAnimation.value : 1.0,
                    child: CustomIconWidget(
                      iconName: _getIconName(),
                      color: Colors.white,
                      size: 7.w,
                    ),
                  );
                },
              ),
            ),

            // Processing indicator
            if (widget.isProcessing)
              Center(
                child: Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().scale(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  String _getIconName() {
    if (widget.isProcessing) {
      return 'hourglass_empty';
    } else if (widget.isListening) {
      return 'mic';
    } else {
      return 'mic_none';
    }
  }
}
