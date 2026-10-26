import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  final List<Map<String, String>> lessons;

  const SchedulePage({
    super.key,
    required this.lessons,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<String> days = [
    'Dushanba',
    'Seshanba',
    'Chorshanba',
    'Payshanba',
    'Juma',
    'Shanba',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Jadval',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showLessonDialog();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...days.map(
            (day) => _buildDaySection(day),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLessonDialog();
        },
        backgroundColor: const Color(0xFF2864E8),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // ============================================================
  // DAY SECTION
  // ============================================================

  Widget _buildDaySection(String day) {
    final dayLessons = widget.lessons
        .where((lesson) => lesson['day'] == day)
        .toList();

    dayLessons.sort(
      (a, b) => _timeToMinutes(a['startTime']!)
          .compareTo(_timeToMinutes(b['startTime']!)),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 25,
                decoration: BoxDecoration(
                  color: const Color(0xFF2864E8),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),

              const SizedBox(width: 10),

              Text(
                day,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 8),

              if (dayLessons.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${dayLessons.length}',
                    style: const TextStyle(
                      color: Color(0xFF2864E8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          if (dayLessons.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    color: Colors.grey,
                  ),

                  SizedBox(width: 10),

                  Text(
                    'Bu kunda dars yo‘q',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            ...dayLessons.map(
              (lesson) => _buildLessonCard(lesson),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // LESSON CARD
  // ============================================================

  Widget _buildLessonCard(Map<String, String> lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        onTap: () {
          _showLessonDialog(
            lesson: lesson,
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Row(
            children: [
              // TIME
              SizedBox(
                width: 65,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      lesson['startTime']!,
                      style: const TextStyle(
                        color: Color(0xFF2864E8),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      lesson['endTime']!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 2,
                height: 45,
                color: const Color(0xFF2864E8),
              ),

              const SizedBox(width: 14),

              // SUBJECT
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      lesson['subject']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons.groups_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          lesson['group']!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // EDIT
              IconButton(
                onPressed: () {
                  _showLessonDialog(
                    lesson: lesson,
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 20,
                ),
              ),

              // DELETE
              IconButton(
                onPressed: () {
                  _deleteLesson(lesson);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ADD / EDIT DIALOG
  // ============================================================

  void _showLessonDialog({
    Map<String, String>? lesson,
  }) {
    final bool isEdit = lesson != null;

    String selectedDay =
        lesson?['day'] ?? 'Dushanba';

    final subjectController = TextEditingController(
      text: lesson?['subject'] ?? '',
    );

    final groupController = TextEditingController(
      text: lesson?['group'] ?? '',
    );

    TimeOfDay selectedStart =
        _parseTime(lesson?['startTime'] ?? '08:30');

    TimeOfDay selectedEnd =
        _parseTime(lesson?['endTime'] ?? '09:15');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isEdit
                    ? 'Darsni tahrirlash'
                    : 'Dars qo‘shish',
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    // DAY
                    DropdownButtonFormField<String>(
                      value: selectedDay,

                      decoration: InputDecoration(
                        labelText: 'Hafta kuni',
                        prefixIcon: const Icon(
                          Icons.calendar_today_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),

                      items: days.map(
                        (day) {
                          return DropdownMenuItem(
                            value: day,
                            child: Text(day),
                          );
                        },
                      ).toList(),

                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedDay = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    // SUBJECT
                    TextField(
                      controller: subjectController,

                      decoration: InputDecoration(
                        labelText: 'Fan nomi',
                        hintText: 'Masalan: Matematika',
                        prefixIcon: const Icon(
                          Icons.menu_book_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // GROUP
                    TextField(
                      controller: groupController,

                      decoration: InputDecoration(
                        labelText: 'Sinf / Guruh',
                        hintText: 'Masalan: 9-A',
                        prefixIcon: const Icon(
                          Icons.groups_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // START TIME
                    _timeSelector(
                      title: 'Boshlanish vaqti',
                      time: selectedStart,

                      onTap: () async {
                        final picked =
                            await showTimePicker(
                          context: context,
                          initialTime: selectedStart,
                        );

                        if (picked != null) {
                          setDialogState(() {
                            selectedStart = picked;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    // END TIME
                    _timeSelector(
                      title: 'Tugash vaqti',
                      time: selectedEnd,

                      onTap: () async {
                        final picked =
                            await showTimePicker(
                          context: context,
                          initialTime: selectedEnd,
                        );

                        if (picked != null) {
                          setDialogState(() {
                            selectedEnd = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Bekor qilish',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    _saveLesson(
                      dialogContext: dialogContext,
                      lesson: lesson,
                      selectedDay: selectedDay,
                      subject: subjectController.text,
                      group: groupController.text,
                      startTime: selectedStart,
                      endTime: selectedEnd,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2864E8),
                    foregroundColor: Colors.white,
                  ),

                  child: Text(
                    isEdit ? 'Yangilash' : 'Saqlash',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // TIME SELECTOR
  // ============================================================

  Widget _timeSelector({
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(12),

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          children: [
            const Icon(
              Icons.access_time_outlined,
              color: Color(0xFF2864E8),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    time.format(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_drop_down,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SAVE LESSON
  // ============================================================

  void _saveLesson({
    required BuildContext dialogContext,
    required Map<String, String>? lesson,
    required String selectedDay,
    required String subject,
    required String group,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) {
    final cleanSubject = subject.trim();
    final cleanGroup = group.trim();

    if (cleanSubject.isEmpty) {
      _showError('Fan nomini kiriting');
      return;
    }

    if (cleanGroup.isEmpty) {
      _showError('Sinf / Guruhni kiriting');
      return;
    }

    final startMinutes =
        startTime.hour * 60 + startTime.minute;

    final endMinutes =
        endTime.hour * 60 + endTime.minute;

    if (startMinutes >= endMinutes) {
      _showError(
        'Tugash vaqti boshlanish vaqtidan keyin bo‘lishi kerak',
      );
      return;
    }

    final newLesson = {
      'day': selectedDay,
      'subject': cleanSubject,
      'group': cleanGroup,
      'startTime': _formatTime(startTime),
      'endTime': _formatTime(endTime),
    };

    setState(() {
      if (lesson != null) {
        lesson['day'] = newLesson['day']!;
        lesson['subject'] = newLesson['subject']!;
        lesson['group'] = newLesson['group']!;
        lesson['startTime'] = newLesson['startTime']!;
        lesson['endTime'] = newLesson['endTime']!;
      } else {
        widget.lessons.add(newLesson);
      }
    });

    Navigator.pop(dialogContext);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lesson != null
              ? 'Dars yangilandi'
              : 'Dars qo‘shildi',
        ),
      ),
    );
  }

  // ============================================================
  // DELETE LESSON
  // ============================================================

  void _deleteLesson(Map<String, String> lesson) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Darsni o‘chirish',
          ),

          content: Text(
            '${lesson['subject']} darsini o‘chirmoqchimisiz?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Bekor qilish',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.lessons.remove(lesson);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Dars o‘chirildi',
                    ),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              child: const Text(
                'O‘chirish',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // TIME FUNCTIONS
  // ============================================================

  int _timeToMinutes(String time) {
    final parts = time.split(':');

    return int.parse(parts[0]) * 60 +
        int.parse(parts[1]);
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');

    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}