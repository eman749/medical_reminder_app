import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../localization/app_strings.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/language_toggle_button.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _selectedIndex = 1; // Default to middle card "Never Miss a Dose" as in Banani design

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic feature card data
    final features = [
      {
        'title': context.tr('onboard_card_1'),
        'desc': context.tr('onboard_card_1_desc'),
        'icon': Icons.medication_outlined,
      },
      {
        'title': context.tr('onboard_card_2'),
        'desc': context.tr('onboard_card_2_desc'),
        'icon': Icons.notifications_active_outlined,
      },
      {
        'title': context.tr('onboard_card_3'),
        'desc': context.tr('onboard_card_3_desc'),
        'icon': Icons.insights_outlined,
      },
    ];

    final currentFeature = features[_selectedIndex];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Header Row: MedCare Logo + Language Toggle + Skip Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(size: 38, showText: true),
                  Row(
                    children: [
                      const LanguageToggleButton(isCompact: true),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _navigateToLogin,
                        child: Text(
                          context.tr('skip'),
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // Center Visual: Bell Notification Emblem (matching Banani design)
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Icon(
                        currentFeature['icon'] as IconData,
                        size: 52,
                        color: AppTheme.primary,
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: AppTheme.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Title & Subtitle (changes reactively based on selected tab)
              Text(
                currentFeature['title'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  currentFeature['desc'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // 3 Feature Cards row (Exact match to Banani design)
              Row(
                children: List.generate(3, (index) {
                  final isSelected = _selectedIndex == index;
                  final item = features[index];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: index == 1 ? 6.0 : 0.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.border,
                              width: 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primary
                                          .withValues(alpha: 0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                size: 24,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['title'] as String,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const Spacer(flex: 2),

              // Bottom Buttons: Back & Next
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      text: context.tr('back'),
                      isOutlined: true,
                      onPressed: _selectedIndex > 0
                          ? () {
                              setState(() {
                                _selectedIndex--;
                              });
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: _selectedIndex == 2
                          ? context.tr('get_started')
                          : context.tr('next'),
                      onPressed: () {
                        if (_selectedIndex < 2) {
                          setState(() {
                            _selectedIndex++;
                          });
                        } else {
                          _navigateToLogin();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
