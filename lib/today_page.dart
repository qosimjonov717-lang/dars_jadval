import 'package:flutter/material.dart';

class TodayPage extends StatelessWidget {
  final List<Map<String, String>> lessons;
  final DateTime now;

  const TodayPage({
    super.key,
    required this.lessons,
    required this.now,
  });

  String getDayName(int weekday) {
    const days = [
      'Dushanba',
      'Seshanba',
      'Chorshanba',
      'Payshanba',
      'Juma',
      'Shanba',
      'Yakshanba',
    ];

    return days[weekday - 1];
  }

  int timeToMinutes(String time) {
    final parts = time.split(':');

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return hour * 60 + minute;
  }

  int getCurrentMinutes() {
    return now.hour * 60 + now.minute;
  }

  bool isLessonPassed(Map<String, String> lesson) {
    return timeToMinutes(lesson['endTime']!) < getCurrentMinutes();
  }

  bool isLessonCurrent(Map<String, String> lesson) {
    final start = timeToMinutes(lesson['startTime']!);
    final end = timeToMinutes(lesson['endTime']!);
    final current = getCurrentMinutes();

    return current >= start && current <= end;
  }

  @override
  Widget build(BuildContext context) {
    final today = getDayName(now.weekday);

    final todayLessons = lessons
        .where((lesson) => lesson['day'] == today)
        .toList();

    todayLessons.sort(
      (a, b) => timeToMinutes(a['startTime']!)
          .compareTo(timeToMinutes(b['startTime']!)),
    );

    final currentLesson = todayLessons.where(isLessonCurrent).firstOrNull;

    final nextLessons = todayLessons.where(
      (lesson) =>
          timeToMinutes(lesson['startTime']!) > getCurrentMinutes(),
    );

    final nextLesson = nextLessons.isNotEmpty ? nextLessons.first : null;

    final completedCount =
        todayLessons.where(isLessonPassed).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Bugun',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================
              // SANA VA VAQT
              // =========================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF2864E8),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      today,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${now.hour.toString().padLeft(2, '0')}:'
                      '${now.minute.toString().padLeft(2, '0')}:'
                      '${now.second.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${now.day.toString().padLeft(2, '0')}.'
                      '${now.month.toString().padLeft(2, '0')}.'
                      '${now.year}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // STATISTIKA
              // =========================

              Row(
                children: [

                  Expanded(
                    child: _InfoCard(
                      icon: Icons.menu_book_rounded,
                      title: 'Jami dars',
                      value: '${todayLessons.length}',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _InfoCard(
                      icon: Icons.check_circle_rounded,
                      title: 'O‘tgan',
                      value: '$completedCount',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =========================
              // HOZIRGI DARS
              // =========================

              const Text(
                'Hozirgi dars',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              if (currentLesson != null)
                _CurrentLessonCard(
                  lesson: currentLesson,
                )
              else if (nextLesson != null)
                _NextLessonCard(
                  lesson: nextLesson,
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: const Row(
                    children: [

                      Icon(
                        Icons.done_all_rounded,
                        size: 35,
                        color: Colors.green,
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          'Bugungi barcha darslar tugagan.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // =========================
              // BUGUNGI DARSLAR
              // =========================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    'Bugungi darslar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    '$completedCount/${todayLessons.length}',
                    style: const TextStyle(
                      color: Color(0xFF2864E8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (todayLessons.isEmpty)

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: const Column(
                    children: [

                      Icon(
                        Icons.event_busy_rounded,
                        size: 45,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 10),

                      Text(
                        'Bugun dars yo‘q',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else

                ...todayLessons.map(
                  (lesson) => _LessonCard(
                    lesson: lesson,
                    isCurrent: isLessonCurrent(lesson),
                    isPassed: isLessonPassed(lesson),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// INFO CARD
// ============================================================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: const Color(0xFF2864E8),
            size: 28,
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CURRENT LESSON
// ============================================================

class _CurrentLessonCard extends StatelessWidget {
  final Map<String, String> lesson;

  const _CurrentLessonCard({
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF2864E8),
          width: 1.5,
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              color: const Color(0xFF2864E8),
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  'HOZIR',
                  style: TextStyle(
                    color: Color(0xFF2864E8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  lesson['subject']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${lesson['group']}  •  '
                  '${lesson['startTime']} - ${lesson['endTime']}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// NEXT LESSON
// ============================================================

class _NextLessonCard extends StatelessWidget {
  final Map<String, String> lesson;

  const _NextLessonCard({
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.access_time_rounded,
              color: Color(0xFF2864E8),
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  'KEYINGI DARS',
                  style: TextStyle(
                    color: Color(0xFF2864E8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  lesson['subject']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${lesson['group']}  •  '
                  '${lesson['startTime']} - ${lesson['endTime']}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LESSON CARD
// ============================================================

class _LessonCard extends StatelessWidget {
  final Map<String, String> lesson;
  final bool isCurrent;
  final bool isPassed;

  const _LessonCard({
    required this.lesson,
    required this.isCurrent,
    required this.isPassed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(0xFFEAF1FF)
            : Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: isCurrent
            ? Border.all(
                color: const Color(0xFF2864E8),
              )
            : null,
      ),

      child: Row(
        children: [

          SizedBox(
            width: 65,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  lesson['startTime']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isPassed
                        ? Colors.grey
                        : const Color(0xFF2864E8),
                  ),
                ),

                const SizedBox(height: 3),

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
            color: isPassed
                ? Colors.grey.shade300
                : const Color(0xFF2864E8),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  lesson['subject']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPassed
                        ? Colors.grey
                        : Colors.black87,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  lesson['group']!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          if (isPassed)
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
            ),

          if (isCurrent)
            const Icon(
              Icons.play_circle_fill_rounded,
              color: Color(0xFF2864E8),
            ),
        ],
      ),
    );
  }
}