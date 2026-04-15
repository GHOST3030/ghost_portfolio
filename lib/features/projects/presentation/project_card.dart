import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_style.dart';
import '../../../core/theme/app_colors.dart';

class ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final int index;
  final bool visible;

  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.visible,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final tech = (widget.project['tech'] as List).cast<String>();
    final title = widget.project['title'] as String;
    final description = widget.project['description'] as String;
    final github = widget.project['github'] as String;
    final image = widget.project['image'] as String;

    Widget card = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isStartup
              ? (_hovered ? AppColors.bgCardHover : AppColors.bgCard)
              : (_hovered ? const Color(0xFFF8F8FF) : Colors.white),
          borderRadius: BorderRadius.circular(AppStyle.cardRadius),
          border: Border.all(
            color: isStartup
                ? (_hovered ? AppColors.accent.withOpacity(0.3) : AppColors.border)
                : (_hovered
                    ? AppColors.classicAccent.withOpacity(0.3)
                    : AppColors.classicBorder),
          ),
          boxShadow: isStartup && _hovered && AppStyle.useGlowEffects
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.08),
                    blurRadius: 30,
                    spreadRadius: -5,
                    offset: const Offset(0, 10),
                  )
                ]
              : (!isStartup && _hovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ]
                  : null),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProjectImage(image: image, title: title, hovered: _hovered),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontFamily: isStartup ? 'Syne' : 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isStartup
                                ? AppColors.textPrimary
                                : AppColors.classicText,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _hovered ? 1.0 : 0.4,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.arrow_outward_rounded,
                          size: 18,
                          color: isStartup
                              ? AppColors.accent
                              : AppColors.classicAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: isStartup ? 'DM Sans' : 'Inter',
                      fontSize: 14,
                      color: isStartup
                          ? AppColors.textSecondary
                          : AppColors.classicTextSecondary,
                      height: 1.6,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tech
                        .map((t) => _TechPill(label: t))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(github)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.code_rounded,
                          size: 14,
                          color: isStartup
                              ? AppColors.accent
                              : AppColors.classicAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'View on GitHub',
                          style: TextStyle(
                            fontFamily: isStartup ? 'Syne' : 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isStartup
                                ? AppColors.accent
                                : AppColors.classicAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!AppStyle.useAnimations || !widget.visible) return card;

    return card
        .animate()
        .fadeIn(
          duration: 600.ms,
          delay: Duration(milliseconds: widget.index * 100 + 200),
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 600.ms,
          delay: Duration(milliseconds: widget.index * 100 + 200),
          curve: Curves.easeOut,
        );
  }
}

class _ProjectImage extends StatelessWidget {
  final String image;
  final String title;
  final bool hovered;

  const _ProjectImage({
    required this.image,
    required this.title,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: isStartup
            ? (hovered ? AppColors.bgCardHover : AppColors.bg)
            : AppColors.classicBorder.withOpacity(0.3),
      ),
      child: image.isNotEmpty
          ? ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: AnimatedScale(
                scale: hovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) =>
                      _PlaceholderImage(title: title),
                ),
              ),
            )
          : _PlaceholderImage(title: title),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final String title;
  const _PlaceholderImage({required this.title});

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isStartup
                ? [
                    AppColors.accent.withOpacity(0.05),
                    AppColors.accentDim.withOpacity(0.02),
                  ]
                : [
                    AppColors.classicAccent.withOpacity(0.05),
                    AppColors.classicAccent.withOpacity(0.02),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            title[0],
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 64,
              fontWeight: FontWeight.w800,
              color: isStartup
                  ? AppColors.accent.withOpacity(0.15)
                  : AppColors.classicAccent.withOpacity(0.15),
            ),
          ),
        ),
      ),
    );
  }
}

class _TechPill extends StatelessWidget {
  final String label;
  const _TechPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isStartup
            ? AppColors.accentGlow
            : AppColors.classicAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: isStartup ? 'JetBrains Mono' : 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isStartup ? AppColors.accent : AppColors.classicAccent,
        ),
      ),
    );
  }
}
