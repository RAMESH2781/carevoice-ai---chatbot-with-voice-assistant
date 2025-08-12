import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/audio_player_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_context_menu_widget.dart';
import './widgets/note_input_widget.dart';
import './widgets/orb_animation_widget.dart';

class ConversationDetail extends StatefulWidget {
  const ConversationDetail({Key? key}) : super(key: key);

  @override
  State<ConversationDetail> createState() => _ConversationDetailState();
}

class _ConversationDetailState extends State<ConversationDetail> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  bool _showContextMenu = false;
  bool _showAudioPlayer = false;
  String _selectedAudioPath = '';
  Map<String, dynamic>? _selectedMessage;
  Offset _contextMenuPosition = Offset.zero;
  String _searchQuery = '';
  bool _isLoading = false;

  // Mock conversation data
  final List<Map<String, dynamic>> _conversationMessages = [
    {
      "id": 1,
      "content":
          "Hello! I've been having some trouble sleeping lately. Can you help me with some advice?",
      "isUser": true,
      "timestamp": "2025-08-12 14:30",
      "hasAudio": true,
      "audioPath": "/audio/user_message_1.wav",
      "animationState": "idle"
    },
    {
      "id": 2,
      "content":
          "I understand you're having trouble sleeping. This is quite common and there are several effective strategies we can explore. First, let's talk about sleep hygiene - maintaining a consistent bedtime routine can significantly improve your sleep quality.",
      "isUser": false,
      "mode": "wellness",
      "timestamp": "2025-08-12 14:31",
      "hasAudio": true,
      "audioPath": "/audio/ai_response_1.wav",
      "animationState": "speaking"
    },
    {
      "id": 3,
      "content":
          "That sounds helpful. What specific things should I include in my bedtime routine?",
      "isUser": true,
      "timestamp": "2025-08-12 14:32",
      "hasAudio": true,
      "audioPath": "/audio/user_message_2.wav",
      "animationState": "listening"
    },
    {
      "id": 4,
      "content":
          "Great question! Here are some key elements for an effective bedtime routine: 1) Set a consistent sleep schedule - go to bed and wake up at the same time daily, 2) Create a relaxing pre-sleep ritual like reading or gentle stretching, 3) Avoid screens 1 hour before bed, 4) Keep your bedroom cool, dark, and quiet, 5) Consider relaxation techniques like deep breathing or meditation.",
      "isUser": false,
      "mode": "wellness",
      "timestamp": "2025-08-12 14:33",
      "hasAudio": true,
      "audioPath": "/audio/ai_response_2.wav",
      "animationState": "speaking"
    },
    {
      "id": 5,
      "content":
          "I think the screen time before bed might be my biggest issue. I usually scroll through my phone.",
      "isUser": true,
      "timestamp": "2025-08-12 14:34",
      "hasAudio": true,
      "audioPath": "/audio/user_message_3.wav",
      "animationState": "idle"
    },
    {
      "id": 6,
      "content":
          "You've identified a very common sleep disruptor! Blue light from screens can interfere with your body's natural melatonin production. Try placing your phone in another room or using a traditional alarm clock instead. You could replace phone scrolling with reading a physical book, gentle journaling, or listening to calming music or nature sounds.",
      "isUser": false,
      "mode": "wellness",
      "timestamp": "2025-08-12 14:35",
      "hasAudio": true,
      "audioPath": "/audio/ai_response_3.wav",
      "animationState": "speaking"
    }
  ];

  final List<Map<String, dynamic>> _conversationNotes = [
    {
      "id": 1,
      "content": "Remember to avoid screens 1 hour before bed",
      "timestamp": "2025-08-12 14:36",
      "messageId": 4
    },
    {
      "id": 2,
      "content": "Try reading physical books instead of phone scrolling",
      "timestamp": "2025-08-12 14:37",
      "messageId": 6
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadConversationData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConversationData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshConversation() async {
    await _loadConversationData();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _showMessageContextMenu(Map<String, dynamic> message, Offset position) {
    setState(() {
      _selectedMessage = message;
      _contextMenuPosition = position;
      _showContextMenu = true;
    });
  }

  void _hideContextMenu() {
    setState(() {
      _showContextMenu = false;
      _selectedMessage = null;
    });
  }

  void _copyMessageText() {
    if (_selectedMessage != null) {
      Clipboard.setData(
          ClipboardData(text: _selectedMessage!['content'] as String));
      _showSnackBar('Message copied to clipboard');
    }
  }

  void _shareMessageSnippet() {
    if (_selectedMessage != null) {
      // Implement share functionality
      _showSnackBar('Share functionality would be implemented here');
    }
  }

  void _addMessageToNotes() {
    if (_selectedMessage != null) {
      Navigator.pushNamed(context, '/health-notes');
    }
  }

  void _setMessageReminder() {
    if (_selectedMessage != null) {
      _showSnackBar('Reminder functionality would be implemented here');
    }
  }

  void _playAudio(String audioPath) {
    setState(() {
      _selectedAudioPath = audioPath;
      _showAudioPlayer = true;
    });
  }

  void _closeAudioPlayer() {
    setState(() {
      _showAudioPlayer = false;
      _selectedAudioPath = '';
    });
  }

  void _addNote(String noteText) {
    setState(() {
      _conversationNotes.add({
        "id": _conversationNotes.length + 1,
        "content": noteText,
        "timestamp": DateTime.now().toString().substring(0, 16),
        "messageId": null
      });
    });
    _showSnackBar('Note added successfully');
  }

  void _handleVoiceInput() {
    _showSnackBar('Voice input functionality would be implemented here');
  }

  void _continueConversation() {
    Navigator.pushNamed(context, '/main-voice-interface');
  }

  void _exportConversation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildExportOptions(),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredMessages() {
    if (_searchQuery.isEmpty) {
      return _conversationMessages;
    }
    return _conversationMessages.where((message) {
      final content = (message['content'] as String).toLowerCase();
      return content.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              if (_isSearching) _buildSearchBar(),
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _buildConversationView(),
              ),
              _buildNoteInput(),
            ],
          ),
          if (_showContextMenu) _buildContextMenuOverlay(),
          if (_showAudioPlayer) _buildAudioPlayerOverlay(),
        ],
      ),
      floatingActionButton: _buildContinueConversationFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.darkTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Sleep Wellness Chat',
        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.darkTheme.colorScheme.onSurface,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _toggleSearch,
          icon: CustomIconWidget(
            iconName: _isSearching ? 'close' : 'search',
            color: AppTheme.darkTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: _exportConversation,
          icon: CustomIconWidget(
            iconName: 'share',
            color: AppTheme.darkTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.darkTheme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Search in conversation...',
          hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color:
                AppTheme.darkTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          prefixIcon: CustomIconWidget(
            iconName: 'search',
            color:
                AppTheme.darkTheme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 1.h),
        ),
        onChanged: _performSearch,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OrbAnimationWidget(
            animationState: 'loading',
            mode: 'wellness',
            size: 80,
          ),
          SizedBox(height: 3.h),
          Text(
            'Loading conversation...',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationView() {
    final filteredMessages = _getFilteredMessages();

    return RefreshIndicator(
      onRefresh: _refreshConversation,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      color: AppTheme.darkTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: filteredMessages.length + _conversationNotes.length,
        itemBuilder: (context, index) {
          if (index < filteredMessages.length) {
            final message = filteredMessages[index];
            return Column(
              children: [
                MessageBubbleWidget(
                  message: message,
                  onTap: () {
                    if (message['hasAudio'] == true) {
                      _playAudio(message['audioPath'] as String);
                    }
                  },
                  onLongPress: () {
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final position = renderBox.localToGlobal(Offset.zero);
                    _showMessageContextMenu(message, position);
                  },
                  onPlayAudio: () => _playAudio(message['audioPath'] as String),
                ),
                if (index < filteredMessages.length - 1 &&
                    message['animationState'] != null)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    child: OrbAnimationWidget(
                      animationState: message['animationState'] as String,
                      mode: (message['mode'] as String?) ?? 'wellness',
                      size: 40,
                    ),
                  ),
              ],
            );
          } else {
            final noteIndex = index - filteredMessages.length;
            final note = _conversationNotes[noteIndex];
            return _buildNoteItem(note);
          }
        },
      ),
    );
  }

  Widget _buildNoteItem(Map<String, dynamic> note) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'note',
            size: 16,
            color: AppTheme.darkTheme.colorScheme.tertiary,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note['content'] as String,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Note • ${note['timestamp']}',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.tertiary
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    return NoteInputWidget(
      onNoteAdded: _addNote,
      onVoiceInput: _handleVoiceInput,
    );
  }

  Widget _buildContextMenuOverlay() {
    return GestureDetector(
      onTap: _hideContextMenu,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Stack(
          children: [
            Positioned(
              left: _contextMenuPosition.dx,
              top: _contextMenuPosition.dy,
              child: MessageContextMenuWidget(
                onCopyText: _copyMessageText,
                onShareSnippet: _shareMessageSnippet,
                onAddToNotes: _addMessageToNotes,
                onSetReminder: _setMessageReminder,
                onClose: _hideContextMenu,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: AudioPlayerWidget(
          audioPath: _selectedAudioPath,
          onClose: _closeAudioPlayer,
        ),
      ),
    );
  }

  Widget _buildContinueConversationFAB() {
    return FloatingActionButton.extended(
      onPressed: _continueConversation,
      backgroundColor: AppTheme.darkTheme.colorScheme.primary,
      foregroundColor: Colors.white,
      icon: CustomIconWidget(
        iconName: 'chat',
        size: 20,
        color: Colors.white,
      ),
      label: Text(
        'Continue Chat',
        style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildExportOptions() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export Conversation',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          _buildExportOption(
            icon: 'text_snippet',
            title: 'Text Only',
            subtitle: 'Export as plain text file',
            onTap: () {
              Navigator.pop(context);
              _showSnackBar(
                  'Text export functionality would be implemented here');
            },
          ),
          _buildExportOption(
            icon: 'audiotrack',
            title: 'Audio Only',
            subtitle: 'Export all audio recordings',
            onTap: () {
              Navigator.pop(context);
              _showSnackBar(
                  'Audio export functionality would be implemented here');
            },
          ),
          _buildExportOption(
            icon: 'folder_zip',
            title: 'Complete Package',
            subtitle: 'Text, audio, and notes combined',
            onTap: () {
              Navigator.pop(context);
              _showSnackBar(
                  'Complete export functionality would be implemented here');
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 24,
              color: AppTheme.darkTheme.colorScheme.primary,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              size: 16,
              color: AppTheme.darkTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
