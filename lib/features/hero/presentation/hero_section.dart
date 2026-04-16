import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_style.dart';
import '../../../config/portfolio_data.dart';
import '../../../core/providers/scroll_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../shared/widgets/ghost_button.dart';

class HeroSection extends StatelessWidget {
  final GlobalKey sectionKey;
  const HeroSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final isMobile = AppResponsive.isMobile(context);

    return Container(
      key: sectionKey,
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height,
      ),
      decoration: BoxDecoration(
        color: isStartup ? AppColors.bg : AppColors.classicBg,
      ),
      child: Stack(
        children: [
          if (isStartup) const _HeroBackground(),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: 120,
                bottom: 80,
                left: AppResponsive.pagePadding(context).left,
                right: AppResponsive.pagePadding(context).right,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isMobile
                    ? const _HeroContentMobile()
                    : const _HeroContentDesktop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBackground extends StatefulWidget {
  const _HeroBackground();

  @override
  State<_HeroBackground> createState() => _HeroBackgroundState();
}

class _HeroBackgroundState extends State<_HeroBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(
          painter: _GridPainter(progress: _controller.value),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final double progress;
  const _GridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.04)
      ..strokeWidth = 1;

    const spacing = 60.0;
    final offsetY = (progress * spacing) % spacing;

    for (double y = -spacing + offsetY; y < size.height + spacing; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (double x = 0; x < size.width + spacing; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final glowPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 200, glowPaint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.8), 150, glowPaint);

    final rng = math.Random(42);
    for (int i = 0; i < 40; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final phase = (progress + rng.nextDouble()) % 1.0;
      final opacity = (math.sin(phase * math.pi * 2) * 0.5 + 0.5) * 0.4;
      canvas.drawPoints(
        PointMode.points,
        [Offset(x, y)],
        Paint()
          ..color = AppColors.accent.withOpacity(opacity)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.progress != progress;
}

class _HeroContentDesktop extends StatelessWidget {
  const _HeroContentDesktop();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 3, child: _HeroText()),
        SizedBox(width: 80),
        Expanded(flex: 2, child: _AvatarWidget()),
      ],
    );
  }
}

class _HeroContentMobile extends StatelessWidget {
  const _HeroContentMobile();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _AvatarWidget(),
        SizedBox(height: 48),
        _HeroText(centered: true),
      ],
    );
  }
}

class _HeroText extends ConsumerWidget {
  final bool centered;
  const _HeroText({this.centered = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStartup = AppStyle.isStartup;
    final isMobile = AppResponsive.isMobile(context);
    final nameSize = isMobile ? 42.0 : AppStyle.heroFontSize;

    Widget content = Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.accentGlow,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.accent.withOpacity(0.3)),
          ),
          child: Text(
            '< available for work />',
            style: TextStyle(
              fontFamily: isStartup ? 'JetBrains Mono' : 'Inter',
              fontSize: 11,
              color: AppColors.accent,
              letterSpacing: 0.1,
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (isStartup)
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.accentGradient.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Text(
              PortfolioData.brandName,
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: nameSize * 1.1,
                fontWeight: FontWeight.w800,
                height: 0.9,
                color: Colors.white,
              ),
            ),
          )
        else
          Text(
            PortfolioData.name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: nameSize,
              fontWeight: FontWeight.w800,
              color: AppColors.classicText,
              height: 1.1,
            ),
          ),
        if (isStartup)
          Text(
            PortfolioData.name,
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: nameSize * 0.45,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        const SizedBox(height: 16),
        Text(
          PortfolioData.role,
          style: TextStyle(
            fontFamily: isStartup ? 'Syne' : 'Inter',
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.w600,
            color: isStartup ? AppColors.textPrimary : AppColors.classicText,
          ),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            PortfolioData.bio,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          children: [
            GhostButton(
              label: 'View Projects',
              variant: GhostButtonVariant.primary,
              onTap: () => scrollToSection(ref, 'projects'),
            ),
            GhostButton(
              label: 'GitHub',
              variant: GhostButtonVariant.outline,
              icon: const Icon(Icons.open_in_new, size: 14),
              onTap: () => launchUrl(Uri.parse(PortfolioData.github)),
            ),
          ],
        ),
        const SizedBox(height: 48),
        const _StatRow(),
      ],
    );

    if (!AppStyle.useAnimations) return content;

    return content
        .animate()
        .fadeIn(duration: 800.ms, delay: 300.ms)
        .slideX(begin: -0.1, end: 0, duration: 800.ms, curve: Curves.easeOut);
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow();

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final items = [
      {'value': '3+', 'label': 'Years Flutter'},
      {'value': '10+', 'label': 'Projects Built'},
      {'value': '∞', 'label': 'Lines of Code'},
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['value']!,
                  style: TextStyle(
                    fontFamily: isStartup ? 'Syne' : 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isStartup ? AppColors.accent : AppColors.classicAccent,
                  ),
                ),
                Text(
                  item['label']!,
                  style: TextStyle(
                    fontFamily: isStartup ? 'JetBrains Mono' : 'Inter',
                    fontSize: 11,
                    color: isStartup ? AppColors.textMuted : AppColors.classicTextSecondary,
                    letterSpacing: 0.05,
                  ),
                ),
              ],
            ),
            if (i < items.length - 1) ...[
              const SizedBox(width: 24),
              Container(
                width: 1,
                height: 36,
                color: isStartup ? AppColors.border : AppColors.classicBorder,
                margin: const EdgeInsets.only(right: 24),
              ),
            ],
          ],
        );
      }).toList(),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget();

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final hasAvatar = PortfolioData.avatarUrl.isNotEmpty;
    final size = AppResponsive.isMobile(context) ? 200.0 : 280.0;

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isStartup ? AppColors.bgCard : AppColors.classicBorder,
        border: Border.all(
          color: isStartup ? AppColors.border : AppColors.classicBorder,
          width: 2,
        ),
        boxShadow: isStartup && AppStyle.useGlowEffects
            ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.15),
                  blurRadius: 60,
                  spreadRadius: -10,
                )
              ]
            : null,
      ),
      child: hasAvatar
          ? ClipOval(
              child: Image.network(
                PortfolioData.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _PlaceholderAvatar(size: size),
              ),
            )
          : _PlaceholderAvatar(size: size),
    );

    if (!AppStyle.useAnimations) return Center(child: avatar);

    return Center(
      child: avatar
          .animate()
          .fadeIn(duration: 900.ms, delay: 500.ms)
          .scale(
            begin: const Offset(0.85, 0.85),
            duration: 900.ms,
            curve: Curves.easeOut,
          ),
    );
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  final double size;
  const _PlaceholderAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withOpacity(0.2),
                  AppColors.accentDim.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Text(
            PortfolioData.brandName[0],
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: size * 0.35,
              fontWeight: FontWeight.w800,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
