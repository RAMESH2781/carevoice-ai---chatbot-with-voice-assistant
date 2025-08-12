import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_settings_widget.dart';
import './widgets/mode_card_widget.dart';
import './widgets/mode_description_panel_widget.dart';

class AiModeSelection extends StatefulWidget {
  const AiModeSelection({Key? key}) : super(key: key);

  @override
  State<AiModeSelection> createState() => _AiModeSelectionState();
}

class _AiModeSelectionState extends State<AiModeSelection>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  int _selectedModeIndex = 0;
  bool _isLoading = false;
  bool _showAdvancedSettings = false;

  // Advanced settings state
  double _voiceSpeed = 1.0;
  String _formalityLevel = 'Professional';
  bool _specializedVocabulary = true;

  // Mock data for AI modes
  final List<Map<String, dynamic>> _aiModes = [
    {
      "id": 1,
      "title": "Friendly Advisor",
      "description":
          "Your warm and caring health companion for everyday wellness guidance and support.",
      "iconName": "favorite",
      "primaryColor": const Color(0xFF8B5CF6),
      "secondaryColor": const Color(0xFFEC4899),
      "detailedDescription":
          "A compassionate AI personality that provides gentle health guidance with empathy and understanding. Perfect for daily wellness check-ins and emotional support.",
      "capabilities": [
        "Personalized wellness recommendations",
        "Emotional support and motivation",
        "Daily health habit tracking",
        "Gentle medication reminders",
        "Stress management techniques"
      ],
      "exampleCommands": [
        "How can I improve my sleep quality?",
        "I'm feeling stressed, can you help?",
        "What are some healthy breakfast options?",
        "Remind me to take my vitamins"
      ]
    },
    {
      "id": 2,
      "title": "Professional Doctor",
      "description":
          "Clinical expertise and medical knowledge for serious health consultations and advice.",
      "iconName": "medical_services",
      "primaryColor": const Color(0xFF3B82F6),
      "secondaryColor": const Color(0xFF1E40AF),
      "detailedDescription":
          "A professional medical AI with clinical knowledge and evidence-based recommendations. Ideal for health concerns requiring medical expertise.",
      "capabilities": [
        "Symptom analysis and assessment",
        "Medical terminology explanations",
        "Treatment option discussions",
        "Medication interaction checks",
        "Health screening reminders"
      ],
      "exampleCommands": [
        "What could be causing my headaches?",
        "Explain my blood test results",
        "Are these medications safe together?",
        "When should I see a specialist?"
      ]
    },
    {
      "id": 3,
      "title": "Fitness Coach",
      "description":
          "Energetic motivation and expert guidance for your fitness journey and active lifestyle.",
      "iconName": "fitness_center",
      "primaryColor": const Color(0xFFF59E0B),
      "secondaryColor": const Color(0xFFEF4444),
      "detailedDescription":
          "An energetic and motivating AI coach focused on physical fitness, exercise routines, and active lifestyle guidance.",
      "capabilities": [
        "Personalized workout plans",
        "Exercise form corrections",
        "Nutrition for fitness goals",
        "Progress tracking and motivation",
        "Injury prevention tips"
      ],
      "exampleCommands": [
        "Create a workout plan for me",
        "How many calories did I burn?",
        "What should I eat before exercising?",
        "Help me stay motivated"
      ]
    },
    {
      "id": 4,
      "title": "Mental Wellness Guide",
      "description":
          "Calming presence and mindfulness techniques for mental health and emotional well-being.",
      "iconName": "self_improvement",
      "primaryColor": const Color(0xFF10B981),
      "secondaryColor": const Color(0xFF059669),
      "detailedDescription":
          "A calming and supportive AI focused on mental health, mindfulness, and emotional well-being through therapeutic techniques.",
      "capabilities": [
        "Guided meditation sessions",
        "Anxiety and stress management",
        "Mood tracking and insights",
        "Breathing exercises",
        "Cognitive behavioral techniques"
      ],
      "exampleCommands": [
        "Guide me through a meditation",
        "I'm having anxiety, help me calm down",
        "Track my mood today",
        "Teach me breathing exercises"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _selectMode(int index) {
    if (index != _selectedModeIndex) {
      HapticFeedback.lightImpact();
      setState(() {
        _selectedModeIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleAdvancedSettings() {
    setState(() {
      _showAdvancedSettings = !_showAdvancedSettings;
    });
  }

  void _playVoicePreview() {
    HapticFeedback.selectionClick();
    // Voice preview implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Playing ${(_aiModes[_selectedModeIndex]["title"] as String)} voice preview...',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimaryDark,
          ),
        ),
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _applyMode() async {
    setState(() {
      _isLoading = true;
    });

    _loadingController.repeat();

    // Simulate mode application process
    await Future.delayed(const Duration(seconds: 2));

    _loadingController.stop();
    _loadingController.reset();

    setState(() {
      _isLoading = false;
    });

    HapticFeedback.heavyImpact();

    // Navigate back to main voice interface
    Navigator.pushReplacementNamed(context, '/main-voice-interface');
  }

  void _cancelSelection() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final selectedMode = _aiModes[_selectedModeIndex];

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _cancelSelection,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.darkTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.darkTheme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textPrimaryDark,
                        size: 5.w,
                      ),
                    ),
                  ),
                  Text(
                    'Select AI Mode',
                    style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleAdvancedSettings,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _showAdvancedSettings
                            ? AppTheme.primaryDark.withValues(alpha: 0.2)
                            : AppTheme.darkTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _showAdvancedSettings
                              ? AppTheme.primaryDark
                              : AppTheme.darkTheme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'settings',
                        color: _showAdvancedSettings
                            ? AppTheme.primaryDark
                            : AppTheme.textPrimaryDark,
                        size: 5.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Mode Cards Carousel
            SizedBox(
              height: 30.h,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _selectMode,
                itemCount: _aiModes.length,
                itemBuilder: (context, index) {
                  final mode = _aiModes[index];
                  return ModeCardWidget(
                    title: mode["title"] as String,
                    description: mode["description"] as String,
                    iconName: mode["iconName"] as String,
                    primaryColor: mode["primaryColor"] as Color,
                    secondaryColor: mode["secondaryColor"] as Color,
                    isSelected: index == _selectedModeIndex,
                    onTap: () => _selectMode(index),
                  );
                },
              ),
            ),

            SizedBox(height: 2.h),

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _aiModes.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: index == _selectedModeIndex ? 8.w : 2.w,
                  height: 1.h,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: index == _selectedModeIndex
                        ? (selectedMode["primaryColor"] as Color)
                        : AppTheme.textDisabledDark,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Mode Description Panel
                    ModeDescriptionPanelWidget(
                      title: selectedMode["title"] as String,
                      description:
                          selectedMode["detailedDescription"] as String,
                      capabilities:
                          (selectedMode["capabilities"] as List).cast<String>(),
                      exampleCommands: (selectedMode["exampleCommands"] as List)
                          .cast<String>(),
                      primaryColor: selectedMode["primaryColor"] as Color,
                      onVoicePreview: _playVoicePreview,
                    ),

                    SizedBox(height: 2.h),

                    // Advanced Settings
                    AdvancedSettingsWidget(
                      isExpanded: _showAdvancedSettings,
                      voiceSpeed: _voiceSpeed,
                      formalityLevel: _formalityLevel,
                      specializedVocabulary: _specializedVocabulary,
                      onVoiceSpeedChanged: (value) {
                        setState(() {
                          _voiceSpeed = value;
                        });
                      },
                      onFormalityChanged: (value) {
                        setState(() {
                          _formalityLevel = value;
                        });
                      },
                      onSpecializedVocabularyChanged: (value) {
                        setState(() {
                          _specializedVocabulary = value;
                        });
                      },
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Apply Mode Button
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _applyMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedMode["primaryColor"] as Color,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: (selectedMode["primaryColor"] as Color)
                        .withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _loadingAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _loadingAnimation.value * 2 * 3.14159,
                                  child: CustomIconWidget(
                                    iconName: 'sync',
                                    color: Colors.white,
                                    size: 5.w,
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Applying Mode...',
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: Colors.white,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Apply ${selectedMode["title"]} Mode',
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
