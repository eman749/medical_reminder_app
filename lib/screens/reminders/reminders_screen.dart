import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../localization/app_strings.dart';
import '../../services/database_service.dart';
import '../../services/settings_service.dart';
import '../../widgets/language_toggle_button.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final Map<String, bool> _reminderStates = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkSurface : AppTheme.surface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.border;
    final settings = SettingsService.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('reminders_title'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: LanguageToggleButton(isCompact: true),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          DatabaseService.instance,
          settings,
        ]),
        builder: (context, _) {
          final doses = DatabaseService.instance.todayDoses;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            children: [
              // Settings Card connected to SettingsService
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: AppTheme.primary,
                      title: Text(
                        context.tr('sound_vibrate'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                        ),
                      ),
                      secondary: const Icon(
                        Icons.volume_up_outlined,
                        color: AppTheme.primary,
                      ),
                      value: settings.soundEnabled,
                      onChanged: (val) {
                        settings.setSoundEnabled(val);
                        settings.setVibrationEnabled(val);
                      },
                    ),
                    const Divider(height: 16),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: AppTheme.primary,
                      title: Text(
                        context.tr('notify_early'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                        ),
                      ),
                      secondary: const Icon(
                        Icons.alarm_on_outlined,
                        color: AppTheme.primary,
                      ),
                      value: settings.earlyReminderMinutes > 0,
                      onChanged: (val) {
                        settings.setEarlyReminder(val ? 10 : 0);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                context.tr('today_doses'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              ...doses.map((dose) {
                final isEnabled = _reminderStates[dose.id] ?? true;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkSecondary : AppTheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: AppTheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dose.medicationName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dose.time} • ${dose.dosage}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: isEnabled,
                        activeTrackColor: AppTheme.primary,
                        onChanged: (val) {
                          setState(() {
                            _reminderStates[dose.id] = val;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
