import 'dart:async';

import 'package:flutter/material.dart';

import 'today_page.dart';
import 'schedule_page.dart';
import 'settings_page.dart';

void main() {
  runApp(const SchoolScheduleApp());
}

// ============================================================
// APP
// ============================================================

class SchoolScheduleApp extends StatefulWidget {
  const SchoolScheduleApp({super.key});

  @override
  State<SchoolScheduleApp> createState() =>
      _SchoolScheduleAppState();
}

class _SchoolScheduleAppState
    extends State<SchoolScheduleApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Dars Jadvali',

      themeMode:
          isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2864E8),
        ),

        scaffoldBackgroundColor:
            const Color(0xFFF7F9FC),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.dark,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2864E8),
          brightness: Brightness.dark,
        ),

        scaffoldBackgroundColor:
            const Color(0xFF10141C),
      ),

      home: MainPage(
        isDarkMode: isDarkMode,

        onThemeChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }
}

// ============================================================
// MAIN PAGE
// ============================================================

class MainPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MainPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  DateTime now = DateTime.now();

  Timer? timer;

  // ==========================================================
  // LESSONS
  // ==========================================================

  final List<Map<String, String>> lessons = [
    // DUSHANBA
    {
      'day': 'Dushanba',
      'subject': 'Informatika',
      'group': '8-A',
      'startTime': '08:30',
      'endTime': '09:15',
    },
    {
      'day': 'Dushanba',
      'subject': 'Matematika',
      'group': '9-A',
      'startTime': '09:25',
      'endTime': '10:10',
    },
    {
      'day': 'Dushanba',
      'subject': 'Fizika',
      'group': '10-B',
      'startTime': '10:20',
      'endTime': '11:05',
    },
    {
      'day': 'Dushanba',
      'subject': 'Ingliz tili',
      'group': '9-A',
      'startTime': '11:15',
      'endTime': '12:00',
    },
    {
      'day': 'Dushanba',
      'subject': 'Tarix',
      'group': '10-A',
      'startTime': '12:10',
      'endTime': '12:55',
    },
    {
      'day': 'Dushanba',
      'subject': 'Ona tili',
      'group': '8-B',
      'startTime': '13:05',
      'endTime': '13:50',
    },
    {
      'day': 'Dushanba',
      'subject': 'Jismoniy tarbiya',
      'group': '7-A',
      'startTime': '14:00',
      'endTime': '14:45',
    },

    // SESHANBA
    {
      'day': 'Seshanba',
      'subject': 'Matematika',
      'group': '9-A',
      'startTime': '08:30',
      'endTime': '09:15',
    },
    {
      'day': 'Seshanba',
      'subject': 'Informatika',
      'group': '8-A',
      'startTime': '09:25',
      'endTime': '10:10',
    },
    {
      'day': 'Seshanba',
      'subject': 'Kimyo',
      'group': '10-A',
      'startTime': '10:20',
      'endTime': '11:05',
    },
    {
      'day': 'Seshanba',
      'subject': 'Biologiya',
      'group': '9-B',
      'startTime': '11:15',
      'endTime': '12:00',
    },
    {
      'day': 'Seshanba',
      'subject': 'Geometriya',
      'group': '11-B',
      'startTime': '12:10',
      'endTime': '12:55',
    },
    {
      'day': 'Seshanba',
      'subject': 'Adabiyot',
      'group': '8-B',
      'startTime': '13:05',
      'endTime': '13:50',
    },
    {
      'day': 'Seshanba',
      'subject': 'Jismoniy tarbiya',
      'group': '7-B',
      'startTime': '14:00',
      'endTime': '14:45',
    },

    // CHORSHANBA
    {
      'day': 'Chorshanba',
      'subject': 'Geometriya',
      'group': '11-B',
      'startTime': '08:30',
      'endTime': '09:15',
    },
    {
      'day': 'Chorshanba',
      'subject': 'Fizika',
      'group': '10-B',
      'startTime': '09:25',
      'endTime': '10:10',
    },
    {
      'day': 'Chorshanba',
      'subject': 'Ona tili',
      'group': '8-A',
      'startTime': '10:20',
      'endTime': '11:05',
    },
    {
      'day': 'Chorshanba',
      'subject': 'Ingliz tili',
      'group': '9-A',
      'startTime': '11:15',
      'endTime': '12:00',
    },
    {
      'day': 'Chorshanba',
      'subject': 'Tarix',
      'group': '10-A',
      'startTime': '12:10',
      'endTime': '12:55',
    },
    {
      'day': 'Chorshanba',
      'subject': 'Kimyo',
      'group': '10-A',
      'startTime': '13:05',
      'endTime': '13:50',
    },
    {
      'day': 'Chorshanba',
      'subject': 'Informatika',
      'group': '8-B',
      'startTime': '14:00',
      'endTime': '14:45',
    },

    // PAYSHANBA
    {
      'day': 'Payshanba',
      'subject': 'Matematika',
      'group': '9-A',
      'startTime': '08:30',
      'endTime': '09:15',
    },
    {
      'day': 'Payshanba',
      'subject': 'Geometriya',
      'group': '11-B',
      'startTime': '09:25',
      'endTime': '10:10',
    },
    {
      'day': 'Payshanba',
      'subject': 'Biologiya',
      'group': '9-B',
      'startTime': '10:20',
      'endTime': '11:05',
    },
    {
      'day': 'Payshanba',
      'subject': 'Informatika',
      'group': '8-A',
      'startTime': '11:15',
      'endTime': '12:00',
    },
    {
      'day': 'Payshanba',
      'subject': 'Fizika',
      'group': '10-B',
      'startTime': '12:10',
      'endTime': '12:55',
    },
    {
      'day': 'Payshanba',
      'subject': 'Adabiyot',
      'group': '8-B',
      'startTime': '13:05',
      'endTime': '13:50',
    },
    {
      'day': 'Payshanba',
      'subject': 'Ingliz tili',
      'group': '9-A',
      'startTime': '14:00',
      'endTime': '14:45',
    },

    // JUMA
    {
      'day': 'Juma',
      'subject': 'Ingliz tili',
      'group': '9-A',
      'startTime': '08:30',
      'endTime': '09:15',
    },
    {
      'day': 'Juma',
      'subject': 'Matematika',
      'group': '9-B',
      'startTime': '09:25',
      'endTime': '10:10',
    },
    {
      'day': 'Juma',
      'subject': 'Tarix',
      'group': '10-A',
      'startTime': '10:20',
      'endTime': '11:05',
    },
    {
      'day': 'Juma',
      'subject': 'Fizika',
      'group': '10-B',
      'startTime': '11:15',
      'endTime': '12:00',
    },
    {
      'day': 'Juma',
      'subject': 'Ona tili',
      'group': '8-A',
      'startTime': '12:10',
      'endTime': '12:55',
    },
    {
      'day': 'Juma',
      'subject': 'Informatika',
      'group': '8-B',
      'startTime': '13:05',
      'endTime': '13:50',
    },
    {
      'day': 'Juma',
      'subject': 'Jismoniy tarbiya',
      'group': '7-A',
      'startTime': '14:00',
      'endTime': '14:45',
    },

    // SHANBA
    {
      'day': 'Shanba',
      'subject': 'Tarix',
      'group': '10-A',
      'startTime': '08:30',
      'endTime': '09:15',
    },
    {
      'day': 'Shanba',
      'subject': 'Biologiya',
      'group': '9-B',
      'startTime': '09:25',
      'endTime': '10:10',
    },
    {
      'day': 'Shanba',
      'subject': 'Kimyo',
      'group': '10-A',
      'startTime': '10:20',
      'endTime': '11:05',
    },
    {
      'day': 'Shanba',
      'subject': 'Matematika',
      'group': '9-A',
      'startTime': '11:15',
      'endTime': '12:00',
    },
    {
      'day': 'Shanba',
      'subject': 'Informatika',
      'group': '8-A',
      'startTime': '12:10',
      'endTime': '12:55',
    },
    {
      'day': 'Shanba',
      'subject': 'Adabiyot',
      'group': '8-B',
      'startTime': '13:05',
      'endTime': '13:50',
    },
  ];

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          setState(() {
            now = DateTime.now();
          });
        }
      },
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final pages = [
      TodayPage(
        lessons: lessons,
        now: now,
      ),

      SchedulePage(
        lessons: lessons,
      ),

      SettingsPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.today_outlined,
            ),
            selectedIcon: Icon(
              Icons.today,
            ),
            label: 'Bugun',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            selectedIcon: Icon(
              Icons.calendar_month,
            ),
            label: 'Jadval',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
            ),
            selectedIcon: Icon(
              Icons.settings,
            ),
            label: 'Sozlamalar',
          ),
        ],
      ),
    );
  }
}