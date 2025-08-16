import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/widgets/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';

/// نموذج المشروع
class Project {
  final String title;
  final String description;
  final String images;
  final Color color;
  final List<String>? tags;

  const Project({
    required this.title,
    required this.description,
    required this.images,
    required this.color,
    this.tags,
  });
}

/// SECTION: Portfolio
class PortfolioSection extends StatelessWidget {
  final List<Project> projects;

  const PortfolioSection({super.key, required this.projects});

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('تعذر فتح الرابط: $url');
    }
  }

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
      mobile: 22,
      tablet: 24,
      desktop: 28,
    );

    final subtitleSize = ResponsiveUtils.responsiveTextSize(
      context,
      mobile: 14,
      tablet: 15,
      desktop: 16,
    );

    final isMobile = ResponsiveUtils.isMobile(context);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'أعمالي',
            style: GoogleFonts.cairo(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'مجموعة مختارة من المشاريع التي عملت عليها.',
            style: GoogleFonts.cairo(
              fontSize: subtitleSize,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // الكارد الواحد لجميع المشاريع
          PortfolioCard(projects: projects),

          const SizedBox(height: 20),

          // زر "عرض المزيد"
          ElevatedButton.icon(
            onPressed: () => _openLink(
              'https://drive.google.com/drive/folders/1fG2ZlOpCGs6PZHoPXlq-tHLxWqT-fz3P',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 40,
                vertical: isMobile ? 14 : 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
            ),
            icon: const Icon(Icons.open_in_new, size: 20),
            label: Text(
              'عرض المزيد',
              style: GoogleFonts.cairo(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// PortfolioCard: كارد واحد لجميع المشاريع
class PortfolioCard extends StatefulWidget {
  final List<Project> projects;

  const PortfolioCard({super.key, required this.projects});

  @override
  State<PortfolioCard> createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard> {
  late final PageController _controller;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients) {
        final next = (_currentIndex + 1) % widget.projects.length;
        _controller.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() => _currentIndex = next);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: isMobile ? 16 / 16 : 16 / 15,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.projects.length,
                itemBuilder: (context, index) {
                  final project = widget.projects[index];
                  return Image.asset(project.images, fit: BoxFit.fitHeight);
                },
              ),
              Container(
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Container(
                  color: widget.projects[_currentIndex].color,
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  height: ResponsiveUtils.responsiveValue(
                    context,
                    mobile: 100,
                    desktop: 200,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.projects[_currentIndex].title,
                        style: GoogleFonts.cairo(
                          fontSize: ResponsiveUtils.responsiveTextSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.projects[_currentIndex].description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: ResponsiveUtils.responsiveTextSize(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 15,
                          ),
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
