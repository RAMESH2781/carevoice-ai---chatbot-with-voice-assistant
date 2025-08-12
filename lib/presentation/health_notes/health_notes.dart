import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/note_card_widget.dart';
import './widgets/note_editor_widget.dart';
import './widgets/search_bar_widget.dart';

class HealthNotes extends StatefulWidget {
  const HealthNotes({Key? key}) : super(key: key);

  @override
  State<HealthNotes> createState() => _HealthNotesState();
}

class _HealthNotesState extends State<HealthNotes> {
  List<Map<String, dynamic>> _allNotes = [];
  List<Map<String, dynamic>> _filteredNotes = [];
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedSort = 'recent';
  Set<int> _selectedNotes = {};
  bool _isMultiSelectMode = false;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _allNotes = [
      {
        "id": 1,
        "title": "Blood Pressure Reading",
        "content":
            "Morning reading: 120/80 mmHg. Feeling good today, no dizziness or headaches. Doctor recommended continuing current medication dosage.",
        "category": "symptoms",
        "aiMode": "Professional Doctor",
        "hasReminder": true,
        "createdDate": "12/08/2025",
        "preview":
            "Morning reading: 120/80 mmHg. Feeling good today, no dizziness or headaches...",
      },
      {
        "id": 2,
        "title": "Medication Schedule",
        "content":
            "Lisinopril 10mg - Take once daily in the morning with breakfast. Side effects: None observed. Next refill due: 20/08/2025",
        "category": "medications",
        "aiMode": "Friendly Advisor",
        "hasReminder": true,
        "createdDate": "11/08/2025",
        "preview":
            "Lisinopril 10mg - Take once daily in the morning with breakfast...",
      },
      {
        "id": 3,
        "title": "Cardiology Appointment",
        "content":
            "Dr. Sarah Johnson - 15/08/2025 at 2:30 PM. Discuss recent ECG results and adjust medication if needed. Location: City Heart Clinic, Room 205",
        "category": "appointments",
        "aiMode": "Professional Doctor",
        "hasReminder": true,
        "createdDate": "10/08/2025",
        "preview":
            "Dr. Sarah Johnson - 15/08/2025 at 2:30 PM. Discuss recent ECG results...",
      },
      {
        "id": 4,
        "title": "Daily Exercise Log",
        "content":
            "30 minutes brisk walking in the park. Heart rate: 110-125 bpm. Felt energized afterwards. Weather was perfect for outdoor activity.",
        "category": "general",
        "aiMode": "Fitness Coach",
        "hasReminder": false,
        "createdDate": "12/08/2025",
        "preview":
            "30 minutes brisk walking in the park. Heart rate: 110-125 bpm...",
      },
      {
        "id": 5,
        "title": "Sleep Quality Assessment",
        "content":
            "Slept 7.5 hours last night. Woke up feeling refreshed. No interruptions. Meditation before bed helped with relaxation.",
        "category": "general",
        "aiMode": "Mental Wellness Guide",
        "hasReminder": false,
        "createdDate": "11/08/2025",
        "preview": "Slept 7.5 hours last night. Woke up feeling refreshed...",
      },
      {
        "id": 6,
        "title": "Vitamin D Supplement",
        "content":
            "Started Vitamin D3 1000 IU daily as recommended by doctor. Taking with lunch for better absorption. Monitor energy levels over next month.",
        "category": "medications",
        "aiMode": "Professional Doctor",
        "hasReminder": true,
        "createdDate": "09/08/2025",
        "preview":
            "Started Vitamin D3 1000 IU daily as recommended by doctor...",
      },
    ];
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allNotes);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((note) {
        final title = (note['title'] as String).toLowerCase();
        final content = (note['content'] as String).toLowerCase();
        final category = (note['category'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) ||
            content.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'all') {
      filtered = filtered
          .where((note) => note['category'] == _selectedCategory)
          .toList();
    }

    // Apply sort
    switch (_selectedSort) {
      case 'recent':
        filtered.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
        break;
      case 'oldest':
        filtered.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
        break;
      case 'alphabetical':
        filtered.sort(
            (a, b) => (a['title'] as String).compareTo(b['title'] as String));
        break;
      case 'aiMode':
        filtered.sort(
            (a, b) => (a['aiMode'] as String).compareTo(b['aiMode'] as String));
        break;
    }

    setState(() {
      _filteredNotes = filtered;
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _handleVoiceSearch() {
    // Simulate voice search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'mic',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Voice search activated...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleCategoryFilter(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
  }

  void _handleSortFilter(String sort) {
    setState(() {
      _selectedSort = sort;
    });
    _applyFilters();
  }

  void _showNoteEditor({Map<String, dynamic>? note}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteEditorWidget(
        existingNote: note,
        onSave: (savedNote) {
          setState(() {
            if (note != null) {
              // Edit existing note
              final index = _allNotes.indexWhere((n) => n['id'] == note['id']);
              if (index != -1) {
                _allNotes[index] = savedNote;
              }
            } else {
              // Add new note
              _allNotes.insert(0, savedNote);
            }
          });
          _applyFilters();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(note != null
                  ? 'Note updated successfully'
                  : 'Note created successfully'),
              backgroundColor: AppTheme.getSuccessColor(false),
            ),
          );
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _handleNoteAction(Map<String, dynamic> note, String action) {
    switch (action) {
      case 'edit':
        _showNoteEditor(note: note);
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing: ${note['title']}')),
        );
        break;
      case 'setReminder':
        setState(() {
          note['hasReminder'] = !(note['hasReminder'] as bool);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(note['hasReminder']
                ? 'Reminder set for ${note['title']}'
                : 'Reminder removed from ${note['title']}'),
          ),
        );
        break;
      case 'duplicate':
        final duplicatedNote = Map<String, dynamic>.from(note);
        duplicatedNote['id'] = DateTime.now().millisecondsSinceEpoch;
        duplicatedNote['title'] = '${note['title']} (Copy)';
        setState(() {
          _allNotes.insert(0, duplicatedNote);
        });
        _applyFilters();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note duplicated successfully')),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exporting: ${note['title']}')),
        );
        break;
      case 'delete':
        setState(() {
          _allNotes.removeWhere((n) => n['id'] == note['id']);
        });
        _applyFilters();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Note deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _allNotes.insert(0, note);
                });
                _applyFilters();
              },
            ),
          ),
        );
        break;
    }
  }

  void _handleNoteLongPress(Map<String, dynamic> note) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedNotes.add(note['id'] as int);
    });
  }

  void _toggleNoteSelection(Map<String, dynamic> note) {
    setState(() {
      final noteId = note['id'] as int;
      if (_selectedNotes.contains(noteId)) {
        _selectedNotes.remove(noteId);
        if (_selectedNotes.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedNotes.add(noteId);
      }
    });
  }

  void _handleBulkAction(String action) {
    switch (action) {
      case 'delete':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Selected Notes'),
            content: Text(
                'Are you sure you want to delete ${_selectedNotes.length} selected notes?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _allNotes.removeWhere(
                        (note) => _selectedNotes.contains(note['id']));
                    _selectedNotes.clear();
                    _isMultiSelectMode = false;
                  });
                  _applyFilters();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected notes deleted')),
                  );
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Exporting ${_selectedNotes.length} selected notes')),
        );
        setState(() {
          _selectedNotes.clear();
          _isMultiSelectMode = false;
        });
        break;
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedNotes.clear();
      _isMultiSelectMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: _isMultiSelectMode
            ? Text('${_selectedNotes.length} selected')
            : Text(
                'Health Notes',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
        leading: _isMultiSelectMode
            ? IconButton(
                onPressed: _clearSelection,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
        actions: _isMultiSelectMode
            ? [
                IconButton(
                  onPressed: () => _handleBulkAction('export'),
                  icon: CustomIconWidget(
                    iconName: 'file_download',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: () => _handleBulkAction('delete'),
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 24,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  icon: CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: _filteredNotes.isEmpty && _allNotes.isEmpty
          ? EmptyStateWidget(
              onCreateFirstNote: () => _showNoteEditor(),
            )
          : Column(
              children: [
                if (!_isMultiSelectMode) ...[
                  // Search bar
                  SearchBarWidget(
                    onSearchChanged: _handleSearch,
                    onVoiceSearch: _handleVoiceSearch,
                    hintText: 'Search notes, symptoms, medications...',
                  ),

                  SizedBox(height: 1.h),

                  // Filter chips
                  FilterChipsWidget(
                    selectedCategory: _selectedCategory,
                    selectedSort: _selectedSort,
                    onCategoryChanged: _handleCategoryFilter,
                    onSortChanged: _handleSortFilter,
                  ),

                  SizedBox(height: 1.h),
                ],

                // Notes list
                Expanded(
                  child: _filteredNotes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 15.w,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No notes found',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Try adjusting your search or filters',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemCount: _filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = _filteredNotes[index];
                            final isSelected =
                                _selectedNotes.contains(note['id']);

                            return NoteCardWidget(
                              note: note,
                              isSelected: isSelected,
                              onTap: () {
                                if (_isMultiSelectMode) {
                                  _toggleNoteSelection(note);
                                } else {
                                  Navigator.pushNamed(
                                      context, '/conversation-detail');
                                }
                              },
                              onLongPress: _isMultiSelectMode
                                  ? null
                                  : () => _handleNoteLongPress(note),
                              onEdit: () => _handleNoteAction(note, 'edit'),
                              onShare: () => _handleNoteAction(note, 'share'),
                              onSetReminder: () =>
                                  _handleNoteAction(note, 'setReminder'),
                              onDuplicate: () =>
                                  _handleNoteAction(note, 'duplicate'),
                              onExport: () => _handleNoteAction(note, 'export'),
                              onDelete: () => _handleNoteAction(note, 'delete'),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showNoteEditor(),
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text('New Note'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
    );
  }
}
