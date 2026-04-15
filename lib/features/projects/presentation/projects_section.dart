import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../config/app_style.dart';
import '../../../config/portfolio_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../shared/widgets/section_header.dart';
import 'project_card.dart';

class ProjectsSection extends StatefulWidget {
  final GlobalKey sectionKey;
  const ProjectsSection({super.key, required this.sectionKey});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    final isMobile = AppResponsive.isMobile(context);
    final isTablet = AppResponsive.isTablet(context);

    return VisibilityDetector(
      key: const Key('projects-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  tag: '// projects',
                  title: 'Things I\'ve built.',
                  subtitle:
                      'A selection of real-world applications and tools.',
                ),
                const SizedBox(height: 64),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 2),
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: isMobile ? 0.85 : 0.9,
                  ),
                  itemCount: PortfolioData.projects.length,
                  itemBuilder: (context, index) {
                    return ProjectCard(
                      project: PortfolioData.projects[index],
                      index: index,
                      visible: _visible,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
