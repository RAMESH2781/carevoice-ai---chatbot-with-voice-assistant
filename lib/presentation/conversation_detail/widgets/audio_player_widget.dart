import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final VoidCallback? onClose;

  const AudioPlayerWidget({
    Key? key,
    required this.audioPath,
    this.onClose,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _totalDuration = 100.0;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _initializeAudio();
  }

  void _initializeAudio() {
    // Initialize audio player with the provided path
    // This would integrate with a real audio player package
    setState(() {
      _totalDuration = 45.0; // Mock duration in seconds
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _waveController.repeat();
      _simulatePlayback();
    } else {
      _waveController.stop();
    }
  }

  void _simulatePlayback() {
    // This would be replaced with real audio playback
    if (_isPlaying && _currentPosition < _totalDuration) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _isPlaying) {
          setState(() {
            _currentPosition += 0.1;
          });
          _simulatePlayback();
        }
      });
    } else if (_currentPosition >= _totalDuration) {
      setState(() {
        _isPlaying = false;
        _currentPosition = 0.0;
      });
      _waveController.stop();
    }
  }

  void _seekTo(double position) {
    setState(() {
      _currentPosition = position;
    });
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Audio Playback',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: widget.onClose,
                child: CustomIconWidget(
                  iconName: 'close',
                  size: 24,
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Waveform visualization
          Container(
            height: 8.h,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(20, (index) {
                    final height = _isPlaying
                        ? (0.3 +
                                0.7 *
                                    (0.5 +
                                        0.5 *
                                            (index / 20 + _waveController.value)
                                                .sin())) *
                            8.h
                        : 2.h;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 3,
                      height: height,
                      decoration: BoxDecoration(
                        color: index <= (_currentPosition / _totalDuration * 20)
                            ? AppTheme.darkTheme.colorScheme.primary
                            : AppTheme.darkTheme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Progress slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: _currentPosition,
              min: 0.0,
              max: _totalDuration,
              onChanged: _seekTo,
              activeColor: AppTheme.darkTheme.colorScheme.primary,
              inactiveColor: AppTheme.darkTheme.colorScheme.outline,
            ),
          ),

          // Time indicators
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  _formatDuration(_totalDuration),
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Skip backward
              GestureDetector(
                onTap: () =>
                    _seekTo((_currentPosition - 10).clamp(0.0, _totalDuration)),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.darkTheme.colorScheme.outline,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'replay_10',
                    size: 24,
                    color: AppTheme.darkTheme.colorScheme.onSurface,
                  ),
                ),
              ),

              SizedBox(width: 6.w),

              // Play/Pause button
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.darkTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CustomIconWidget(
                    iconName: _isPlaying ? 'pause' : 'play_arrow',
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(width: 6.w),

              // Skip forward
              GestureDetector(
                onTap: () =>
                    _seekTo((_currentPosition + 10).clamp(0.0, _totalDuration)),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.darkTheme.colorScheme.outline,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'forward_10',
                    size: 24,
                    color: AppTheme.darkTheme.colorScheme.onSurface,
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

extension on double {
  double sin() => 0.5 + 0.5 * (this * 2 * 3.14159).sin();
}
