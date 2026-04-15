import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../config/app_style.dart';
import '../../../config/portfolio_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/section_header.dart';

class ContactSection extends StatefulWidget {
  final GlobalKey sectionKey;
  const ContactSection({super.key, required this.sectionKey});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final isMobile = AppResponsive.isMobile(context);

    return VisibilityDetector(
      key: const Key('contact-section'),
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
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                tag: '// get in touch',
                title: 'Let\'s build\nsomething.',
              ),
              const SizedBox(height: 40),
              _ContactInfo(visible: visible),
            ],
          ),
        ),
        const SizedBox(width: 80),
        Expanded(
          flex: 3,
          child: _ContactForm(visible: visible),
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
          tag: '// get in touch',
          title: 'Let\'s build\nsomething.',
        ),
        const SizedBox(height: 40),
        _ContactInfo(visible: visible),
        const SizedBox(height: 48),
        _ContactForm(visible: visible),
      ],
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final bool visible;
  const _ContactInfo({required this.visible});

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Open to freelance projects, collaboration, and full-time opportunities. '
          'Send a message and I\'ll get back to you.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        _ContactLink(
          icon: Icons.email_outlined,
          label: PortfolioData.email,
          onTap: () => launchUrl(
            Uri.parse('mailto:${PortfolioData.email}'),
          ),
        ),
        const SizedBox(height: 16),
        _ContactLink(
          icon: Icons.code_rounded,
          label: 'github.com/GHOST3030',
          onTap: () => launchUrl(Uri.parse(PortfolioData.github)),
        ),
      ],
    );

    if (!AppStyle.useAnimations || !visible) return content;

    return content
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideX(begin: -0.1, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }
}

class _ContactLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ContactLink> createState() => _ContactLinkState();
}

class _ContactLinkState extends State<_ContactLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final accent = isStartup ? AppColors.accent : AppColors.classicAccent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? (isStartup ? AppColors.accentGlow : accent.withOpacity(0.06))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? accent.withOpacity(0.3)
                  : (isStartup ? AppColors.border : AppColors.classicBorder),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: accent),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: isStartup ? 'JetBrains Mono' : 'Inter',
                  fontSize: 13,
                  color: _hovered
                      ? accent
                      : (isStartup
                          ? AppColors.textSecondary
                          : AppColors.classicTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  final bool visible;
  const _ContactForm({required this.visible});

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final subject = Uri.encodeComponent('Portfolio Contact from ${_nameCtrl.text}');
    final body = Uri.encodeComponent(
      'Name: ${_nameCtrl.text}\nEmail: ${_emailCtrl.text}\n\nMessage:\n${_msgCtrl.text}',
    );
    launchUrl(
      Uri.parse('mailto:${PortfolioData.email}?subject=$subject&body=$body'),
    );
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;

    Widget form = _submitted ? _SuccessView() : _FormContent(
      formKey: _formKey,
      nameCtrl: _nameCtrl,
      emailCtrl: _emailCtrl,
      msgCtrl: _msgCtrl,
      onSubmit: _submit,
    );

    if (!AppStyle.useAnimations || !widget.visible) return form;

    return form
        .animate()
        .fadeIn(duration: 700.ms, delay: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 700.ms, curve: Curves.easeOut);
  }
}

class _FormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController msgCtrl;
  final VoidCallback onSubmit;

  const _FormContent({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.msgCtrl,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isStartup ? AppColors.bgCard : Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.cardRadius),
        border: Border.all(
          color: isStartup ? AppColors.border : AppColors.classicBorder,
        ),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FormField(
              controller: nameCtrl,
              label: 'Your Name',
              hint: 'John Doe',
              validator: (v) =>
                  v == null || v.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 20),
            _FormField(
              controller: emailCtrl,
              label: 'Email Address',
              hint: 'john@example.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _FormField(
              controller: msgCtrl,
              label: 'Message',
              hint: 'Tell me about your project...',
              maxLines: 5,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Message is required' : null,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: GhostButton(
                label: 'Send Message',
                onTap: onSubmit,
                icon: const Icon(Icons.send_rounded, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final accent = isStartup ? AppColors.accent : AppColors.classicAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: isStartup ? 'Syne' : 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isStartup ? AppColors.textSecondary : AppColors.classicTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: TextFormField(
            controller: widget.controller,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: TextStyle(
              fontFamily: isStartup ? 'DM Sans' : 'Inter',
              fontSize: 14,
              color: isStartup ? AppColors.textPrimary : AppColors.classicText,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontFamily: isStartup ? 'DM Sans' : 'Inter',
                fontSize: 14,
                color: isStartup ? AppColors.textMuted : AppColors.classicBorder,
              ),
              filled: true,
              fillColor: isStartup ? AppColors.bg : AppColors.classicBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isStartup ? AppColors.border : AppColors.classicBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isStartup ? AppColors.border : AppColors.classicBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: accent, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
              errorStyle: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 12,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: isStartup ? AppColors.bgCard : Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.cardRadius),
        border: Border.all(
          color: isStartup
              ? AppColors.accent.withOpacity(0.3)
              : AppColors.classicAccent.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accentGlow,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: AppColors.accent, size: 32),
          ),
          const SizedBox(height: 24),
          Text(
            'Message sent!',
            style: TextStyle(
              fontFamily: isStartup ? 'Syne' : 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isStartup ? AppColors.textPrimary : AppColors.classicText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your email client should open. I\'ll get back to you soon.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: isStartup ? 'DM Sans' : 'Inter',
              fontSize: 14,
              color: isStartup ? AppColors.textSecondary : AppColors.classicTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(
          begin: const Offset(0.95, 0.95),
          duration: 500.ms,
          curve: Curves.easeOut,
        );
  }
}
