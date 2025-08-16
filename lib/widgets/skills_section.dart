import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/widgets/responsive_utils.dart';

class Skill {
  final String name;
  final String iconPath; // الآن يستخدم PNG أو JPG
  final double level;
  final Color color;

  const Skill({
    required this.name,
    required this.iconPath,
    required this.level,
    required this.color,
  });
}

class SkillsSection extends StatelessWidget {
  final List<Skill> skills;

  const SkillsSection({super.key, this.skills = _defaultSkills});

  static const List<Skill> _defaultSkills = [
    Skill(
      name: 'Flutter',
      iconPath: 'assets/icons/flutter.png',
      level: 0.95,
      color: Color.fromARGB(255, 72, 74, 184),
    ),
    Skill(
      name: 'Dart',
      iconPath: 'assets/icons/dart.png',
      level: 0.90,
      color: Colors.lightBlue,
    ),
    Skill(
      name: 'Laravel',
      iconPath: 'assets/icons/laravel.png',
      level: 0.40,
      color: Color.fromARGB(255, 248, 143, 135),
    ),
    Skill(
      name: '.NET',
      iconPath: 'assets/icons/dotnet.png',
      level: 0.75,
      color: Colors.blueAccent,
    ),
    Skill(
      name: 'C#',
      iconPath: 'assets/icons/c#.png',
      level: 0.75,
      color: Colors.purpleAccent,
    ),
    Skill(
      name: 'HTML',
      iconPath: 'assets/icons/html.png',
      level: 0.85,
      color: Colors.orange,
    ),
    Skill(
      name: 'CSS',
      iconPath: 'assets/icons/css.png',
      level: 0.80,
      color: Color.fromARGB(255, 33, 51, 243),
    ),
    Skill(
      name: 'Bootstrap',
      iconPath: 'assets/icons/bootstrap.png',
      level: 0.75,
      color: Color.fromARGB(255, 226, 61, 255),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsivePadding(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      desktop: const EdgeInsets.symmetric(horizontal: 36, vertical: 30),
    );

    final titleSize = ResponsiveUtils.responsiveTextSize(
      context,
      mobile: 20,
      tablet: 24,
      desktop: 28,
    );

    final subtitleSize = ResponsiveUtils.responsiveTextSize(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );

    int crossAxisCount;
    if (ResponsiveUtils.isDesktop(context)) {
      crossAxisCount = 4;
    } else if (ResponsiveUtils.isTablet(context)) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            Text(
              '💡 مهاراتي',
              style: GoogleFonts.cairo(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'مجموعة من المهارات والأدوات التي أستخدمها في عملي اليومي.',
              style: GoogleFonts.cairo(
                color: Colors.grey[700],
                fontSize: subtitleSize,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final childAspectRatio =
                    constraints.maxWidth / crossAxisCount / 160;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: skills.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final skill = skills[index];
                    return FadeInUp(
                      duration: Duration(milliseconds: 300 + index * 80),
                      child: _SkillCard(skill: skill),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final Skill skill;

  const _SkillCard({required this.skill});

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveUtils.responsiveTextSize(
      context,
      mobile: 36,
      tablet: 40,
      desktop: 48,
    );

    final nameFontSize = ResponsiveUtils.responsiveTextSize(
      context,
      mobile: 12,
      tablet: 13,
      desktop: 14,
    );

    final percentageFontSize = ResponsiveUtils.responsiveTextSize(
      context,
      mobile: 10,
      tablet: 11,
      desktop: 12,
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    skill.color.withOpacity(0.95),
                    skill.color.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: skill.color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: ClipOval(
                child: Image.asset(
                  skill.iconPath, // استخدام الصور العادية
                  width: iconSize * 0.6,
                  height: iconSize * 0.6,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              skill.name,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: nameFontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: skill.level,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(skill.color),
            ),
            const SizedBox(height: 4),
            Text(
              '${(skill.level * 100).toInt()}%',
              style: GoogleFonts.cairo(
                fontSize: percentageFontSize,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
