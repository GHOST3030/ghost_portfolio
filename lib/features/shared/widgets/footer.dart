import 'package:flutter/material.dart';
import '../../../config/app_style.dart';
import '../../../config/portfolio_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

class PortfolioFooter extends StatelessWidget {
  const PortfolioFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isStartup = AppStyle.isStartup;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: AppResponsive.pagePadding(context).horizontal / 2,
      ),
      decoration: BoxDecoration(
        color: isStartup ? AppColors.bgSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isStartup ? AppColors.border : AppColors.classicBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2024 ${PortfolioData.name}',
                style: TextStyle(
                  fontFamily: isStartup ? 'Syne' : 'Inter',
                  fontSize: 13,
                  color: isStartup
                      ? AppColors.textMuted
                      : AppColors.classicTextSecondary,
                ),
              ),
              Text(
                'Built with Flutter',
                style: TextStyle(
                  fontFamily: isStartup ? 'JetBrains Mono' : 'Inter',
                  fontSize: 12,
                  color: isStartup ? AppColors.accent : AppColors.classicAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
