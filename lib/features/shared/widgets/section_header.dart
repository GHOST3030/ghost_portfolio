import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/app_style.dart';
import '../../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String tag;
  final String title;
  final String? subtitle;
  final bool animate;

  const SectionHeader({
    super.key,
    required this.tag,
    required this.title,
    this.subtitle,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: isStartup
                ? AppColors.accentGlow
                : AppColors.classicAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isStartup
                  ? AppColors.accent.withOpacity(0.3)
                  : AppColors.classicAccent.withOpacity(0.3),
            ),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontFamily: isStartup ? 'JetBrains Mono' : 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isStartup ? AppColors.accent : AppColors.classicAccent,
              letterSpacing: 0.15,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
        const SizedBox(height: 16),
        Container(
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            gradient: isStartup
                ? AppColors.accentGradient
                : const LinearGradient(
                    colors: [AppColors.classicAccent, Color(0xFF3385FF)],
                  ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );

    if (!animate || !AppStyle.useAnimations) return content;

    return content
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }
}
