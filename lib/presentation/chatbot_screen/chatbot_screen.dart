import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/app_export.dart';
import '../../services/gemini_service.dart';
import '../../services/database_service.dart';
import '../../services/voice_service.dart';
import './widgets/chat_message_widget.dart';
import './widgets/voice_input_widget.dart';
import './widgets/chat_input_widget.dart';

class ChatbotScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  
  const ChatbotScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  
  late GeminiService _geminiService;
  late DatabaseService _databaseService;
  late VoiceService _voiceService;
  
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _isListening = false;
  bool _isProcessing = false;
  int? _currentSessionId;
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeAnimations();
    _loadOrCreateChatSession();
    _addWelcomeMessage();
  }

  Future<void> _initializeServices() async {
    try {
      _geminiService = GeminiService();
      _databaseService = DatabaseService();
      _voiceService = VoiceService();
      
      await _voiceService.initialize();
      
      // Listen to voice service streams
      _voiceService.transcriptionStream.listen((transcription) {
        if (transcription.isNotEmpty) {
          _textController.text = transcription;
          _sendMessage(transcription);
        }
      });

      _voiceService.listeningStream.listen((isListening) {
        setState(() {
          _isListening = isListening;
        });
      });
    } catch (e) {
      _showErrorSnackBar('Failed to initialize services: ${e.toString()}');
    }
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _loadOrCreateChatSession() async {
    try {
      // Create a new chat session for this user
      _currentSessionId = await _databaseService.createChatSession(
        userId: widget.user['id'],
        title: 'New Chat',
      );
      
      // Load existing messages if any
      if (_currentSessionId != null) {
        final messages = await _databaseService.getMessages(_currentSessionId!);
        setState(() {
          _messages = messages.map((msg) => {
            'id': msg['id'],
            'role': msg['role'],
            'content': msg['content'],
            'timestamp': DateTime.parse(msg['timestamp']),
            'messageType': msg['message_type'],
          }).toList();
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load chat session: ${e.toString()}');
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'role': 'assistant',
      'content': '''Hello ${widget.user['name'] ?? 'there'}! 👋

I\'m CareVoice AI, your personal healthcare assistant. I\'m here to help you with:

• Health questions and concerns
• Wellness advice and tips
• Medical information (always consult professionals for serious issues)
• Lifestyle recommendations

How can I assist you today?''',
      'timestamp': DateTime.now(),
      'messageType': 'text',
    };
    
    setState(() {
      _messages.add(welcomeMessage);
    });
    
    _scrollToBottom();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'role': 'user',
      'content': message.trim(),
      'timestamp': DateTime.now(),
      'messageType': 'text',
    };

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _isProcessing = true;
    });

    _scrollToBottom();

    try {
      // Save user message to database
      if (_currentSessionId != null) {
        await _databaseService.addMessage(
          sessionId: _currentSessionId!,
          role: 'user',
          content: message.trim(),
        );
      }

      // Generate AI response
      final response = await _geminiService.generateResponse(message.trim());
      
      final aiMessage = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'role': 'assistant',
        'content': response,
        'timestamp': DateTime.now(),
        'messageType': 'text',
      };

      // Save AI response to database
      if (_currentSessionId != null) {
        await _databaseService.addMessage(
          sessionId: _currentSessionId!,
          role: 'assistant',
          content: response,
        );
      }

      setState(() {
        _messages.add(aiMessage);
        _isLoading = false;
        _isProcessing = false;
      });

      _scrollToBottom();
      
      // Update chat session title if it's the first exchange
      if (_messages.length == 3 && _currentSessionId != null) {
        final title = message.length > 30 
            ? '${message.substring(0, 30)}...' 
            : message;
        await _databaseService.updateChatSession(_currentSessionId!, title);
      }

    } catch (e) {
      final errorMessage = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'role': 'assistant',
        'content': 'I apologize, but I encountered an error processing your request. Please try again.',
        'timestamp': DateTime.now(),
        'messageType': 'error',
      };

      setState(() {
        _messages.add(errorMessage);
        _isLoading = false;
        _isProcessing = false;
      });

      _scrollToBottom();
      _showErrorSnackBar('Failed to generate response: ${e.toString()}');
    }
  }

  Future<void> _startVoiceInput() async {
    try {
      await _voiceService.startListening();
    } catch (e) {
      _showErrorSnackBar('Failed to start voice input: ${e.toString()}');
    }
  }

  Future<void> _stopVoiceInput() async {
    try {
      await _voiceService.stopListening();
    } catch (e) {
      _showErrorSnackBar('Failed to stop voice input: ${e.toString()}');
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.darkTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface.withValues(alpha: 0.8),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.darkTheme.colorScheme.primary,
                    AppTheme.darkTheme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'smart_toy',
                  color: Colors.white,
                  size: 4.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CareVoice AI',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Your AI Health Assistant',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            onPressed: () {
              // Show options menu
              _showOptionsMenu();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'chat',
                          color: AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          size: 15.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Start a conversation',
                          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(4.w),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatMessageWidget(
                        message: message,
                        isUser: message['role'] == 'user',
                        showTimestamp: index == _messages.length - 1 || 
                                      index == 0 || 
                                      _shouldShowTimestamp(index),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 300),
                        delay: Duration(milliseconds: index * 100),
                      );
                    },
                  ),
          ),

          // Loading indicator
          if (_isLoading)
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 6.w,
                    height: 6.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.darkTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'AI is thinking...',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

          // Input area
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.darkTheme.colorScheme.surface.withValues(alpha: 0.5),
              border: Border(
                top: BorderSide(
                  color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                // Voice input button
                VoiceInputWidget(
                  isListening: _isListening,
                  isProcessing: _isProcessing,
                  onPressed: _isListening ? _stopVoiceInput : _startVoiceInput,
                ),
                SizedBox(width: 3.w),

                // Text input
                Expanded(
                  child: ChatInputWidget(
                    controller: _textController,
                    onSend: _sendMessage,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowTimestamp(int index) {
    if (index == 0) return true;
    
    final currentMessage = _messages[index];
    final previousMessage = _messages[index - 1];
    
    final currentTime = currentMessage['timestamp'] as DateTime;
    final previousTime = previousMessage['timestamp'] as DateTime;
    
    return currentTime.difference(previousTime).inMinutes > 5;
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            
            _buildOptionTile(
              icon: 'delete',
              title: 'Clear Chat',
              subtitle: 'Remove all messages',
              onTap: _clearChat,
            ),
            
            _buildOptionTile(
              icon: 'history',
              title: 'Chat History',
              subtitle: 'View previous conversations',
              onTap: _viewChatHistory,
            ),
            
            _buildOptionTile(
              icon: 'settings',
              title: 'Settings',
              subtitle: 'Configure preferences',
              onTap: _openSettings,
            ),
            
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.darkTheme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.darkTheme.colorScheme.primary,
            size: 6.w,
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
          color: AppTheme.darkTheme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _clearChat() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Clear Chat',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all messages? This action cannot be undone.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkTheme.colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _messages.clear();
      });
      
      // Clear messages from database
      if (_currentSessionId != null) {
        try {
          await _databaseService.deleteChatSession(_currentSessionId!);
          await _loadOrCreateChatSession();
        } catch (e) {
          _showErrorSnackBar('Failed to clear chat: ${e.toString()}');
        }
      }
      
      _addWelcomeMessage();
      Navigator.pop(context);
    }
  }

  void _viewChatHistory() {
    Navigator.pop(context);
    // TODO: Navigate to chat history screen
    _showInfoSnackBar('Chat history feature coming soon!');
  }

  void _openSettings() {
    Navigator.pop(context);
    // TODO: Navigate to settings screen
    _showInfoSnackBar('Settings feature coming soon!');
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.darkTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }
}
