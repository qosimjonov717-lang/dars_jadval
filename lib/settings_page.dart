import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool morningReminder = true;
  bool lessonReminder = true;
  bool soundEnabled = true;
  bool vibrationEnabled = true;

  TimeOfDay reminderTime = const TimeOfDay(
    hour: 7,
    minute: 30,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode
          ? const Color(0xFF10141C)
          : const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Text(
          'Sozlamalar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          // ==================================================
          // TEMA
          // ==================================================

          _sectionTitle('Ko‘rinish'),

          _settingsCard(
            child: Column(
              children: [

                _settingsTile(
                  icon: widget.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,

                  title: 'Tungi rejim',

                  subtitle: widget.isDarkMode
                      ? 'Tungi rejim yoqilgan'
                      : 'Kunduzgi rejim yoqilgan',

                  trailing: Switch(
                    value: widget.isDarkMode,

                    onChanged: (value) {
                      widget.onThemeChanged(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ==================================================
          // ESLATMALAR
          // ==================================================

          _sectionTitle('Eslatmalar'),

          _settingsCard(
            child: Column(
              children: [

                _settingsTile(
                  icon: Icons.notifications_outlined,

                  title: 'Ertalabki eslatma',

                  subtitle:
                      'Bugungi darslarni eslatish',

                  trailing: Switch(
                    value: morningReminder,

                    onChanged: (value) {
                      setState(() {
                        morningReminder = value;
                      });
                    },
                  ),
                ),

                if (morningReminder)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      14,
                    ),

                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(12),

                      onTap: _selectReminderTime,

                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: widget.isDarkMode
                              ? const Color(0xFF1B2230)
                              : const Color(0xFFF1F5FF),

                          borderRadius:
                              BorderRadius.circular(12),
                        ),

                        child: Row(
                          children: [

                            const Icon(
                              Icons.access_time_rounded,
                              color: Color(0xFF2864E8),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  const Text(
                                    'Eslatma vaqti',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    reminderTime.format(
                                      context,
                                    ),

                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),

                _settingsTile(
                  icon: Icons.school_outlined,

                  title: 'Dars eslatmasi',

                  subtitle:
                      'Dars boshlanishidan oldin eslatish',

                  trailing: Switch(
                    value: lessonReminder,

                    onChanged: (value) {
                      setState(() {
                        lessonReminder = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ==================================================
          // OVOZ
          // ==================================================

          _sectionTitle('Ovoz va vibratsiya'),

          _settingsCard(
            child: Column(
              children: [

                _settingsTile(
                  icon: Icons.volume_up_outlined,

                  title: 'Ovoz',

                  subtitle:
                      'Eslatma ovozini yoqish',

                  trailing: Switch(
                    value: soundEnabled,

                    onChanged: (value) {
                      setState(() {
                        soundEnabled = value;
                      });
                    },
                  ),
                ),

                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),

                _settingsTile(
                  icon: Icons.vibration_outlined,

                  title: 'Vibratsiya',

                  subtitle:
                      'Eslatma vaqtida vibratsiya',

                  trailing: Switch(
                    value: vibrationEnabled,

                    onChanged: (value) {
                      setState(() {
                        vibrationEnabled = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ==================================================
          // ILOVA HAQIDA
          // ==================================================

          _sectionTitle('Ilova haqida'),

          _settingsCard(
            child: Column(
              children: [

                _settingsTile(
                  icon: Icons.info_outline,

                  title: 'Ilova haqida',

                  subtitle: 'Dars Jadvali',

                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey,
                  ),

                  onTap: _showAboutDialog,
                ),

                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),

                _settingsTile(
                  icon: Icons.code_rounded,

                  title: 'Versiya',

                  subtitle: '1.0.0',

                  trailing: const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              'Dars Jadvali • 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),

      child: Text(
        title,

        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,

          color: widget.isDarkMode
              ? Colors.white
              : Colors.black87,
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _settingsCard({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? const Color(0xFF171C25)
            : Colors.white,

        borderRadius: BorderRadius.circular(18),
      ),

      child: child,
    );
  }

  // ============================================================
  // SETTINGS TILE
  // ============================================================

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),

      onTap: onTap,

      leading: Container(
        width: 42,
        height: 42,

        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? const Color(0xFF222A38)
              : const Color(0xFFEAF1FF),

          borderRadius: BorderRadius.circular(12),
        ),

        child: Icon(
          icon,
          color: const Color(0xFF2864E8),
        ),
      ),

      title: Text(
        title,

        style: TextStyle(
          fontWeight: FontWeight.w600,

          color: widget.isDarkMode
              ? Colors.white
              : Colors.black87,
        ),
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),

        child: Text(
          subtitle,

          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),

      trailing: trailing,
    );
  }

  // ============================================================
  // REMINDER TIME
  // ============================================================

  Future<void> _selectReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );

    if (picked != null) {
      setState(() {
        reminderTime = picked;
      });
    }
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void _showAboutDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Dars Jadvali',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(
                Icons.calendar_month_rounded,
                size: 60,
                color: Color(0xFF2864E8),
              ),

              SizedBox(height: 16),

              Text(
                'Maktab dars jadvalini boshqarish '
                'uchun yaratilgan ilova.',

                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12),

              Text(
                'Versiya: 1.0.0',

                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Yopish',
              ),
            ),
          ],
        );
      },
    );
  }
}