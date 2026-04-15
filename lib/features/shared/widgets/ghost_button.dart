import 'package:flutter/material.dart';
import '../../../config/app_style.dart';
import '../../../core/theme/app_colors.dart';

enum GhostButtonVariant { primary, outline, ghost }

class GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final GhostButtonVariant variant;
  final Widget? icon;
  final bool compact;

  const GhostButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = GhostButtonVariant.primary,
    this.icon,
    this.compact = false,
  });

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final accentColor = isStartup ? AppColors.accent : AppColors.classicAccent;

    Color bg;
    Color textColor;
    Border border;

    switch (widget.variant) {
      case GhostButtonVariant.primary:
        bg = _hovered ? accentColor.withOpacity(0.85) : accentColor;
        textColor = AppColors.bg;
        border = Border.all(color: accentColor);
        break;
      case GhostButtonVariant.outline:
        bg = _hovered
            ? (isStartup ? AppColors.bgCardHover : AppColors.classicBorder)
            : Colors.transparent;
        textColor = isStartup ? AppColors.textPrimary : AppColors.classicText;
        border = Border.all(
          color: isStartup ? AppColors.border : AppColors.classicBorder,
        );
        break;
      case GhostButtonVariant.ghost:
        bg = _hovered ? AppColors.accentGlow : Colors.transparent;
        textColor = accentColor;
        border = Border.all(color: Colors.transparent);
        break;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.compact
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
              : const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppStyle.isStartup ? 10 : 6),
            border: border,
            boxShadow: AppStyle.useGlowEffects && widget.variant == GhostButtonVariant.primary
                ? [
                    BoxShadow(
                      color: accentColor.withOpacity(_hovered ? 0.4 : 0.2),
                      blurRadius: _hovered ? 20 : 10,
                      spreadRadius: 0,
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: isStartup ? 'Syne' : 'Inter',
                  fontSize: widget.compact ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
