import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class OrbAnimationWidget extends StatefulWidget {
  final String animationState;
  final String mode;
  final double size;

  const OrbAnimationWidget({
    Key? key,
    required this.animationState,
    required this.mode,
    this.size = 60,
  }) : super(key: key);

  @override
  State<OrbAnimationWidget> createState() => _OrbAnimationWidgetState();
}

class _OrbAnimationWidgetState extends State<OrbAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _expandController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationBasedOnState();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _expandAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimationBasedOnState() {
    _stopAllAnimations();

    switch (widget.animationState.toLowerCase()) {
      case 'idle':
        _pulseController.repeat(reverse: true);
        break;
      case 'listening':
        _expandController.forward();
        _pulseController.repeat(reverse: true);
        break;
      case 'speaking':
        _rippleController.repeat();
        break;
      case 'error':
      case 'loading':
        _pulseController.repeat(reverse: true);
        break;
    }
  }

  void _stopAllAnimations() {
    _pulseController.stop();
    _rippleController.stop();
    _expandController.reset();
  }

  @override
  void didUpdateWidget(OrbAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationState != widget.animationState ||
        oldWidget.mode != widget.mode) {
      _startAnimationBasedOnState();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseController,
        _rippleController,
        _expandController,
      ]),
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ripple effect for speaking state
              if (widget.animationState.toLowerCase() == 'speaking')
                ..._buildRippleEffects(),

              // Main orb
              Transform.scale(
                scale: _getOrbScale(),
                child: Container(
                  width: widget.size * 0.6,
                  height: widget.size * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _getModeColor().withValues(alpha: 0.9),
                        _getModeColor().withValues(alpha: 0.6),
                        _getModeColor().withValues(alpha: 0.3),
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getModeColor().withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: _getModeColor().withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getModeIcon(),
                      size: widget.size * 0.2,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),

              // Outer glow ring
              Transform.scale(
                scale: _getGlowScale(),
                child: Container(
                  width: widget.size * 0.8,
                  height: widget.size * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getModeColor().withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildRippleEffects() {
    return List.generate(3, (index) {
      final delay = index * 0.3;
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _rippleController,
        curve: Interval(delay, 1.0, curve: Curves.easeOut),
      ));

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (animation.value * 0.5),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getModeColor()
                      .withValues(alpha: (1.0 - animation.value) * 0.5),
                  width: 2,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  double _getOrbScale() {
    double scale = 1.0;

    if (widget.animationState.toLowerCase() == 'listening') {
      scale *= _expandAnimation.value;
    }

    if (widget.animationState.toLowerCase() == 'idle' ||
        widget.animationState.toLowerCase() == 'listening' ||
        widget.animationState.toLowerCase() == 'error' ||
        widget.animationState.toLowerCase() == 'loading') {
      scale *= _pulseAnimation.value;
    }

    return scale;
  }

  double _getGlowScale() {
    if (widget.animationState.toLowerCase() == 'listening') {
      return _expandAnimation.value * _pulseAnimation.value;
    }
    return _pulseAnimation.value;
  }

  Color _getModeColor() {
    switch (widget.mode.toLowerCase()) {
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

  String _getModeIcon() {
    switch (widget.mode.toLowerCase()) {
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
}
