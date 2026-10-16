import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'localization/app_language.dart';
import 'services/settings_service.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedCareApp());
}

class MedCareApp extends StatelessWidget {
  const MedCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        AppLanguage.instance,
        SettingsService.instance,
      ]),
      builder: (context, _) {
        final currentLocale = AppLanguage.instance.locale;
        final currentThemeMode = SettingsService.instance.themeMode;

        return MaterialApp(
          title: 'MedCare - إدارة الدواء الذكية',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,

          // Localization Setup with full RTL & LTR Directionality
          locale: currentLocale,
          supportedLocales: const [
            Locale('ar'), // Arabic (Default)
            Locale('en'), // English
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Starts with Splash Screen
          home: const SplashScreen(),
        );
      },
    );
  }
}
