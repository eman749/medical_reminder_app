import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../localization/app_strings.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isHorizontal;

  const AppLogo({
    super.key,
    this.size = 56,
    this.showText = true,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(size * 0.32),
        border: Border.all(color: AppTheme.border, width: 1.2),
      ),
      child: Center(
        child: Icon(
          Icons.medication_rounded,
          color: AppTheme.primary,
          size: size * 0.58,
        ),
      ),
    );

    if (!showText) return iconWidget;

    final textWidget = Column(
      crossAxisAlignment:
          isHorizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr('app_name'),
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        Text(
          context.tr('app_subtitle'),
          style: TextStyle(
            fontSize: size * 0.22,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );

    if (isHorizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: 12),
          textWidget,
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(height: 14),
          textWidget,
        ],
      );
    }
  }
}
