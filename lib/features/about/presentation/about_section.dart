import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../config/app_style.dart';
import '../../../config/portfolio_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../shared/widgets/section_header.dart';

class AboutSection extends StatefulWidget {
  final GlobalKey sectionKey;
  const AboutSection({super.key, required this.sectionKey});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final isMobile = AppResponsive.isMobile(context);

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        key: widget.sectionKey,
        color: isStartup ? AppColors.bgSurface : AppColors.classicBg,
        padding: EdgeInsets.symmetric(
          vertical: AppStyle.sectionPadding,
          horizontal: AppResponsive.pagePadding(context).left,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isMobile
                ? _MobileLayout(visible: _visible)
                : _DesktopLayout(visible: _visible),
          ),
        ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final bool visible;
  const _DesktopLayout({required this.visible});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 2,
          child: SectionHeader(
            tag: '// about me',
            title: 'Turning ideas\ninto apps.',
          ),
        ),
        const SizedBox(width: 80),
        Expanded(
          flex: 3,
          child: _AboutContent(visible: visible),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final bool visible;
  const _MobileLayout({required this.visible});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          tag: '// about me',
          title: 'Turning ideas\ninto apps.',
        ),
        const SizedBox(height: 40),
        _AboutContent(visible: visible),
      ],
    );
  }
}

class _AboutContent extends StatelessWidget {
  final bool visible;
  const _AboutContent({required this.visible});

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;

    final highlights = [
      {'icon': '⚡', 'label': 'Clean Architecture'},
      {'icon': '📱', 'label': 'Flutter Specialist'},
      {'icon': '🔧', 'label': 'Riverpod Expert'},
      {'icon': '☁️', 'label': 'Supabase Backend'},
    ];

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PortfolioData.aboutLong,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: highlights
              .map((h) => _HighlightChip(icon: h['icon']!, label: h['label']!))
              .toList(),
        ),
        const SizedBox(height: 40),
        _CodeSnippet(),
      ],
    );

    if (!AppStyle.useAnimations || !visible) return content;

    return content
        .animate()
        .fadeIn(duration: 700.ms, delay: 200.ms)
        .slideY(begin: 0.15, end: 0, duration: 700.ms, curve: Curves.easeOut);
  }
}

class _HighlightChip extends StatelessWidget {
  final String icon;
  final String label;
  const _HighlightChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isStartup ? AppColors.bgCard : AppColors.classicSurface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isStartup ? AppColors.border : AppColors.classicBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: isStartup ? 'Syne' : 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isStartup ? AppColors.textPrimary : AppColors.classicText,
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeSnippet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!AppStyle.isStartup) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFF5F57), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF28C840), shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Text(
                'developer.dart',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _CodeLine('class', ' Developer ', '{', color: const Color(0xFF00E5FF)),
          _CodeLine('  final name', ' = ', "'${PortfolioData.name}'", color: const Color(0xFFFFD700)),
          _CodeLine('  final role', ' = ', "'${PortfolioData.role}'", color: const Color(0xFFFFD700)),
          _CodeLine('  final stack', ' = ', '[Flutter, Dart, Riverpod]', color: AppColors.accent),
          _CodeLine('}', '', '', color: const Color(0xFF00E5FF)),
        ],
      ),
    );
  }
}

class _CodeLine extends StatelessWidget {
  final String keyword;
  final String middle;
  final String value;
  final Color color;

  const _CodeLine(this.keyword, this.middle, this.value, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: keyword,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: color,
              ),
            ),
            TextSpan(
              text: middle,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
