import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../localization/app_strings.dart';
import '../../localization/app_language.dart';
import '../../services/database_service.dart';
import '../../services/settings_service.dart';
import '../auth/login_screen.dart';
import 'account_settings_screen.dart';
import 'notifications_settings_screen.dart';
import 'reminder_settings_screen.dart';
import 'privacy_rules_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLanguageBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentCode = AppLanguage.instance.currentCode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('language_title'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('lang_switch_hint'),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Arabic Option
              _LanguageOptionTile(
                title: 'العربية (Arabic) - الافتراضي',
                subtitle: 'واجهة باللغة العربية مع دعم كامل من اليمين لليسار',
                isSelected: currentCode == 'ar',
                onTap: () {
                  AppLanguage.instance.switchToArabic();
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 10),

              // English Option
              _LanguageOptionTile(
                title: 'English (الإنجليزية)',
                subtitle: 'English interface with left-to-right alignment',
                isSelected: currentCode == 'en',
                onTap: () {
                  AppLanguage.instance.switchToEnglish();
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = SettingsService.instance;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            context.tr('theme_title'),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ThemeOptionItem(
                title: context.tr('theme_light'),
                icon: Icons.wb_sunny_rounded,
                iconColor: Colors.amber,
                isSelected: settings.themeMode == ThemeMode.light,
                onTap: () {
                  settings.setThemeMode(ThemeMode.light);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 8),
              _ThemeOptionItem(
                title: context.tr('theme_dark'),
                icon: Icons.nightlight_round,
                iconColor: const Color(0xFF6DE8BD),
                isSelected: settings.themeMode == ThemeMode.dark,
                onTap: () {
                  settings.setThemeMode(ThemeMode.dark);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 8),
              _ThemeOptionItem(
                title: context.tr('theme_system'),
                icon: Icons.phone_android_rounded,
                iconColor: AppTheme.primary,
                isSelected: settings.themeMode == ThemeMode.system,
                onTap: () {
                  settings.setThemeMode(ThemeMode.system);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded, color: AppTheme.error, size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                context.tr('logout_confirm_title'),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
            ],
          ),
          content: Text(
            context.tr('logout_confirm_msg'),
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                context.tr('cancel'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                DatabaseService.instance.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                context.tr('logout_btn'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkSurface : AppTheme.surface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.border;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('settings_heading'),
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          DatabaseService.instance,
          SettingsService.instance,
          AppLanguage.instance,
        ]),
        builder: (context, _) {
          final user = DatabaseService.instance.currentUser;
          final settings = SettingsService.instance;
          final isArabic = AppLanguage.instance.isArabic;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // 1. Profile Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark ? AppTheme.darkSecondary : AppTheme.secondary,
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppTheme.primary,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Sarah Ahmed',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user?.email ?? 'sarah.ahmed@example.com',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  user?.bloodType ?? 'O+',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                user?.phone ?? '+20 101 234 5678',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppTheme.darkTextMuted : AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_note_rounded, color: AppTheme.primary, size: 28),
                      tooltip: context.tr('edit_profile_btn'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Offline Guarantee Banner (Prominent badge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF13382D) : const Color(0xFFEAF5F1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2FA882).withValues(alpha: 0.3) : const Color(0xFFA5D8C8),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.tr('offline_badge_title') + ' • ' + (isArabic ? 'يعمل بدون نت' : 'Offline Mode'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFF6DE8BD) : AppTheme.primary,
                        ),
                      ),
                    ),
                    const Icon(Icons.offline_bolt_rounded, color: AppTheme.primary, size: 18),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- 15. ⚙️ Settings List (All 8 Items) ---
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    // 1. Account
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      iconColor: AppTheme.primary,
                      title: context.tr('sec_account'),
                      subtitle: context.tr('account_desc'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // 2. Notifications (Offline sound alerts)
                    _SettingsTile(
                      icon: Icons.notifications_active_outlined,
                      iconColor: const Color(0xFF028090),
                      title: context.tr('sec_notifications'),
                      subtitle: context.tr('notifications_desc'),
                      trailingBadge: settings.soundEnabled
                          ? (isArabic ? 'صوت مفعل' : 'Sound ON')
                          : (isArabic ? 'صامت' : 'Muted'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationsSettingsScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // 3. Reminder settings (Snooze duration, etc.)
                    _SettingsTile(
                      icon: Icons.snooze_rounded,
                      iconColor: AppTheme.accent,
                      title: context.tr('sec_reminder_settings'),
                      subtitle: '${context.tr('snooze_duration_title')}: ${settings.snoozeDurationMinutes} ${isArabic ? 'دقائق' : 'mins'}',
                      trailingBadge: '${settings.snoozeDurationMinutes}m',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReminderSettingsScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // 4. Language (Smooth Arabic <-> English)
                    _SettingsTile(
                      icon: Icons.language_rounded,
                      iconColor: const Color(0xFF27AE60),
                      title: context.tr('sec_language'),
                      subtitle: isArabic ? 'اللغة العربية (الافتراضي)' : 'English',
                      trailingBadge: isArabic ? 'العربية' : 'English',
                      onTap: () => _showLanguageBottomSheet(context),
                    ),
                    const Divider(height: 1),

                    // 5. Theme (Light / Dark)
                    _SettingsTile(
                      icon: Icons.palette_outlined,
                      iconColor: const Color(0xFF8E44AD),
                      title: context.tr('sec_theme'),
                      subtitle: settings.themeMode == ThemeMode.dark
                          ? context.tr('theme_dark')
                          : (settings.themeMode == ThemeMode.light
                              ? context.tr('theme_light')
                              : context.tr('theme_system')),
                      trailingBadge: settings.themeMode == ThemeMode.dark
                          ? '🌙 Dark'
                          : '☀️ Light',
                      onTap: () => _showThemeDialog(context),
                    ),
                    const Divider(height: 1),

                    // 6. Privacy & App Rules
                    _SettingsTile(
                      icon: Icons.security_rounded,
                      iconColor: const Color(0xFF2980B9),
                      title: context.tr('sec_privacy'),
                      subtitle: context.tr('privacy_desc'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrivacyRulesScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // 7. About
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: const Color(0xFF16A085),
                      title: context.tr('sec_about'),
                      subtitle: context.tr('version_label'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // 8. Logout
                    _SettingsTile(
                      icon: Icons.logout_rounded,
                      iconColor: AppTheme.error,
                      title: context.tr('sec_logout'),
                      subtitle: context.tr('logout_confirm_msg'),
                      titleColor: AppTheme.error,
                      onTap: () => _showLogoutConfirmation(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailingBadge;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingBadge,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: isDark ? 0.2 : 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: titleColor ?? (isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary),
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingBadge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSecondary : AppTheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                trailingBadge!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: isDark ? AppTheme.darkTextMuted : AppTheme.textMuted,
          ),
        ],
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF193B32) : AppTheme.secondary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.primary : (isDark ? AppTheme.darkBorder : AppTheme.border),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primary
                          : (isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF193B32) : AppTheme.secondary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : (isDark ? AppTheme.darkBorder : AppTheme.borderSubtle),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              size: 20,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primary
                      : (isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
