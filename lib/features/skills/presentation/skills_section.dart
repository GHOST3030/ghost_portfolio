import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../config/app_style.dart';
import '../../../config/portfolio_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../shared/widgets/section_header.dart';

class SkillsSection extends StatefulWidget {
  final GlobalKey sectionKey;
  const SkillsSection({super.key, required this.sectionKey});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final isMobile = AppResponsive.isMobile(context);

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        key: widget.sectionKey,
        color: isStartup ? AppColors.bg : AppColors.classicBg,
        padding: EdgeInsets.symmetric(
          vertical: AppStyle.sectionPadding,
          horizontal: AppResponsive.pagePadding(context).left,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  tag: '// tech stack',
                  title: 'What I work with.',
                  subtitle:
                      'My primary tools for building production-grade applications.',
                ),
                const SizedBox(height: 64),
                _SkillsGrid(visible: _visible, isMobile: isMobile),
                const SizedBox(height: 64),
                _TechBadgeRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  final bool visible;
  final bool isMobile;

  const _SkillsGrid({required this.visible, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final skills = PortfolioData.skills;
    final crossAxisCount = isMobile ? 1 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 24,
        childAspectRatio: isMobile ? 5 : 4.5,
      ),
      itemCount: skills.length,
      itemBuilder: (context, i) {
        Widget card = _SkillBar(
          name: skills[i]['name'] as String,
          level: skills[i]['level'] as double,
          category: skills[i]['category'] as String,
          visible: visible,
          delay: i * 60,
        );

        if (!AppStyle.useAnimations || !visible) return card;

        return card
            .animate()
            .fadeIn(duration: 500.ms, delay: Duration(milliseconds: i * 60))
            .slideX(
              begin: -0.1,
              end: 0,
              duration: 500.ms,
              delay: Duration(milliseconds: i * 60),
              curve: Curves.easeOut,
            );
      },
    );
  }
}

class _SkillBar extends StatefulWidget {
  final String name;
  final double level;
  final String category;
  final bool visible;
  final int delay;

  const _SkillBar({
    required this.name,
    required this.level,
    required this.category,
    required this.visible,
    required this.delay,
  });

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(covariant _SkillBar old) {
    super.didUpdateWidget(old);
    if (widget.visible && !old.visible) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'mobile':
        return AppColors.accent;
      case 'backend':
        return const Color(0xFF00E5FF);
      case 'web':
        return const Color(0xFFFFD700);
      case 'desktop':
        return const Color(0xFFFF6B9D);
      case 'tools':
        return const Color(0xFFAB87FF);
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final catColor = isStartup
        ? _categoryColor(widget.category)
        : AppColors.classicAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isStartup ? AppColors.bgCard : Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.cardRadius),
        border: Border.all(
          color: isStartup ? AppColors.border : AppColors.classicBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontFamily: isStartup ? 'Syne' : 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isStartup
                        ? AppColors.textPrimary
                        : AppColors.classicText,
                  ),
                ),
              ),
              Text(
                '${(widget.level * 100).round()}%',
                style: TextStyle(
                  fontFamily: isStartup ? 'JetBrains Mono' : 'Inter',
                  fontSize: 11,
                  color: catColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 3,
              color: isStartup
                  ? AppColors.border
                  : AppColors.classicBorder,
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: AppStyle.useAnimations
                        ? _anim.value * widget.level
                        : widget.level,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isStartup
                            ? LinearGradient(
                                colors: [catColor, catColor.withOpacity(0.6)],
                              )
                            : null,
                        color: isStartup ? null : AppColors.classicAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechBadgeRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isStartup ? '// quick reference' : 'Technologies',
          style: TextStyle(
            fontFamily: isStartup ? 'JetBrains Mono' : 'Inter',
            fontSize: 12,
            color: isStartup ? AppColors.textMuted : AppColors.classicTextSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: PortfolioData.techStack
              .map((tech) => _TechBadge(tech: tech))
              .toList(),
        ),
      ],
    );
  }
}

class _TechBadge extends StatefulWidget {
  final String tech;
  const _TechBadge({required this.tech});

  @override
  State<_TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<_TechBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: _hovered && isStartup
              ? AppColors.accentGlow
              : (isStartup ? AppColors.bgCard : Colors.white),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _hovered && isStartup
                ? AppColors.accent.withOpacity(0.4)
                : (isStartup ? AppColors.border : AppColors.classicBorder),
          ),
        ),
        child: Text(
          widget.tech,
          style: TextStyle(
            fontFamily: isStartup ? 'JetBrains Mono' : 'Inter',
            fontSize: 12,
            color: _hovered && isStartup
                ? AppColors.accent
                : (isStartup
                    ? AppColors.textSecondary
                    : AppColors.classicTextSecondary),
          ),
        ),
      ),
    );
  }
}
