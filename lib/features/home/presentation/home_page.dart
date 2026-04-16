import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/scroll_provider.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/footer.dart';
import '../../hero/presentation/hero_section.dart';
import '../../about/presentation/about_section.dart';
import '../../skills/presentation/skills_section.dart';
import '../../projects/presentation/projects_section.dart';
import '../../contact/presentation/contact_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollCtrl = ref.watch(scrollControllerProvider);
    final sectionKeys = ref.watch(sectionKeysProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const NavBar(),
      body: SingleChildScrollView(
        controller: scrollCtrl,
        child: Column(
          children: [
            HeroSection(sectionKey: sectionKeys['hero']!),
            // AboutSection(sectionKey: sectionKeys['about']!),
            // SkillsSection(sectionKey: sectionKeys['skills']!),
            // ProjectsSection(sectionKey: sectionKeys['projects']!),
            // ContactSection(sectionKey: sectionKeys['contact']!),
            // const PortfolioFooter(),
          ],
        ),
      ),
    );
  }
}
