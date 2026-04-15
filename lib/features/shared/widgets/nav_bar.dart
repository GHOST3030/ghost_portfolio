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

class NavBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scrollControllerProvider).addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    ref.read(scrollControllerProvider).removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final scrolled = ref.read(scrollControllerProvider).offset > 20;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
  }

  void _scrollTo(String section) => scrollToSection(ref, section);

  @override
  Widget build(BuildContext context) {
    final isMobile = AppResponsive.isMobile(context);
    final isStartup = AppStyle.isStartup;

    Widget navContent = Padding(
      padding: AppResponsive.pagePadding(context),
      child: Row(
        children: [
          _LogoMark(onTap: () => _scrollTo('hero')),
          const Spacer(),
          if (!isMobile) ...[
            _NavItem('About', () => _scrollTo('about')),
            _NavItem('Skills', () => _scrollTo('skills')),
            _NavItem('Projects', () => _scrollTo('projects')),
            _NavItem('Contact', () => _scrollTo('contact')),
            const SizedBox(width: 16),
            _GhubButton(),
          ] else
            _MobileMenuButton(onNavTap: _scrollTo),
        ],
      ),
    );

    if (isStartup) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _scrolled ? AppStyle.navBlur : 0,
            sigmaY: _scrolled ? AppStyle.navBlur : 0,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 72,
            decoration: BoxDecoration(
              color: _scrolled
                  ? AppColors.bg.withOpacity(0.85)
                  : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: _scrolled ? AppColors.border : Colors.transparent,
                ),
              ),
            ),
            child: navContent,
          ),
        ),
      ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
    }

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.classicBg,
        border: const Border(
          bottom: BorderSide(color: AppColors.classicBorder),
        ),
      ),
      child: navContent,
    );
  }
}

class _LogoMark extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoMark({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.bg,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              PortfolioData.brandName,
              style: TextStyle(
                fontFamily: isStartup ? 'Syne' : 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isStartup ? AppColors.textPrimary : AppColors.classicText,
                letterSpacing: isStartup ? 0.15 : 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavItem(this.label, this.onTap);

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: isStartup ? 'Syne' : 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _hovered
                  ? (isStartup ? AppColors.accent : AppColors.classicAccent)
                  : (isStartup
                      ? AppColors.textSecondary
                      : AppColors.classicTextSecondary),
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _GhubButton extends StatefulWidget {
  @override
  State<_GhubButton> createState() => _GhubButtonState();
}

class _GhubButtonState extends State<_GhubButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(PortfolioData.github)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent
                  : (isStartup ? AppColors.border : AppColors.classicBorder),
            ),
          ),
          child: Text(
            'GitHub',
            style: TextStyle(
              fontFamily: isStartup ? 'Syne' : 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _hovered
                  ? AppColors.bg
                  : (isStartup ? AppColors.textPrimary : AppColors.classicText),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final void Function(String) onNavTap;
  const _MobileMenuButton({required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.menu_rounded,
        color: AppStyle.isStartup ? AppColors.textPrimary : AppColors.classicText,
      ),
      onPressed: () => _showDrawer(context),
    );
  }

  void _showDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          AppStyle.isStartup ? AppColors.bgCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppStyle.isStartup
                    ? AppColors.border
                    : AppColors.classicBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            for (final section in ['about', 'skills', 'projects', 'contact'])
              ListTile(
                title: Text(
                  section[0].toUpperCase() + section.substring(1),
                  style: TextStyle(
                    fontFamily: AppStyle.isStartup ? 'Syne' : 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppStyle.isStartup
                        ? AppColors.textPrimary
                        : AppColors.classicText,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onNavTap(section);
                },
              ),
          ],
        ),
      ),
    );
  }
}
