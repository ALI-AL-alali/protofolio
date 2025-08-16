import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:my_portfolio/widgets/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/portfolio_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/contact_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  int _activeIndex = 0;
  bool _showBackToTop = false;

  final String _github = 'https://github.com/ALI-AL-alali';
  final String _linkedin = 'https://www.linkedin.com/in/ali-alali-06b560325/';
  final String _cvUrl =
      'https://drive.google.com/file/d/1q7dJHldOxyQtSjT58aAAacSF33bryTik/view?usp=drivesdk';

  final List<Project> defaultProjects = [
    Project(
      title: 'Fast Fode',
      description:
          'يعرض قائمة الطعام المتوفرة، يدعم الحجز الداخلي والخارجي، ويوفر خدمة توصيل الطلبات للمنازل. يعرض أقرب المطاعم ويتحقق من توافر الطلب. مبني باستخدام Flutter و Laravel.',
      images: "assets/projects/1.png",
      color: const Color.fromARGB(255, 203, 21, 8),
      tags: ['Flutter', 'Laravel'],
    ),
    Project(
      title: 'Delivery App',
      description:
          'نظام توصيل يتيح تتبع السائقين وإرسال إشعارات لحظية. يدعم حالة الطلب (قيد المعالجة، في الطريق، مكتمل)، مع تسجيل دخول للسائقين والعملاء. مبني باستخدام Flutter و Laravel API.',
      images: "assets/projects/4.png",
      color: const Color.fromARGB(255, 235, 169, 54),
      tags: ['Flutter', 'Laravel'],
    ),
    Project(
      title: 'Ev Power',
      description:
          'نظام لإدارة حجوزات محطات شحن السيارات الكهربائية مع تخصيص الأدوار، رموز QR، وحجز الطوارئ. مبني باستخدام Laravel و Flutter.',
      images: "assets/projects/6.png",
      color: const Color.fromARGB(255, 0, 20, 205),
      tags: ['Flutter', 'Laravel'],
    ),
    Project(
      title: 'Ev Management',
      description:
          'تطبيق لإدارة محطات الشحن بشكل شامل، يتضمن إدارة المآخذ، جدول الحجز، وتتبع استخدام المحطات، مع لوحة تحكم للمدير. مبني باستخدام Flutter و Laravel.',
      images: "assets/projects/5.png",
      color: const Color.fromARGB(255, 6, 100, 176),
      tags: ['Flutter', 'Laravel'],
    ),
    Project(
      title: 'So CHIC',
      description:
          'متجر SO CHIC لبيع المنتجات، يدعم عرض المنتجات، السلة، الطلبات، والدفع الإلكتروني. مبني باستخدام Flutter و Laravel.',
      images: "assets/projects/7.png",
      color: const Color.fromARGB(255, 113, 113, 112),
      tags: ['Flutter', 'Laravel'],
    ),
    Project(
      title: 'Shop Smart',
      description:
          'تطبيق لادارة المتاجر. يعرض المنتجات، يدير الطلبات، ويوفر تجربة شراء سلسة مع تتبع الفواتير و الاحصائيات. مبني باستخدام Flutter و Laravel.',
      images: "assets/projects/3.png",
      color: const Color.fromARGB(255, 136, 6, 176),
      tags: ['Flutter', 'Laravel'],
    ),
    Project(
      title: 'Chat & Talk',
      description:
          'تطبيق محادثة يدعم إرسال النصوص، الصور، الفيديوهات، الصوتيات، والملفات، مع نظام حالة الرسائل (مرسلة، غير مقروءة، مقروءة) وحالة المستخدم (متصل/غير متصل). مبني باستخدام Flutter و ASP.NET Core.',
      images: "assets/projects/2.png",
      color: const Color.fromARGB(255, 6, 100, 176),
      tags: ['Flutter', 'Laravel'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToKey(GlobalKey key) async {
    if (key.currentContext != null) {
      await Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void _onScroll() {
    final keys = [_heroKey, _portfolioKey, _skillsKey, _contactKey];
    final positions = keys.map((key) {
      if (key.currentContext == null) return double.infinity;
      final box = key.currentContext!.findRenderObject() as RenderBox?;
      if (box == null) return double.infinity;
      return box.localToGlobal(Offset.zero).dy;
    }).toList();

    final double topReference = kToolbarHeight + 20;
    double minDiff = double.infinity;
    int nearestIndex = 0;

    for (var i = 0; i < positions.length; i++) {
      final diff = (positions[i] - topReference).abs();
      if (diff < minDiff) {
        minDiff = diff;
        nearestIndex = i;
      }
    }

    final shouldShowBackToTop = _scrollController.offset > 300;

    if (_activeIndex != nearestIndex || _showBackToTop != shouldShowBackToTop) {
      setState(() {
        _activeIndex = nearestIndex;
        _showBackToTop = shouldShowBackToTop;
      });
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء فتح الرابط')),
        );
      }
    }
  }

  Future<void> _openCV() async {
    final uri = Uri.parse(_cvUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تعذر فتح ملف CV')));
      }
    }
  }

  List<_NavItem> get _navItems => [
    _NavItem(label: 'الرئيسية', key: _heroKey),
    _NavItem(label: 'أعمالي', key: _portfolioKey),
    _NavItem(label: 'مهاراتي', key: _skillsKey),
    _NavItem(label: 'تواصل معي', key: _contactKey),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'معرض أعمالي',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          elevation: _showBackToTop ? 6 : 2,
          actions: isMobile
              ? null
              : [
                  for (var i = 0; i < _navItems.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextButton(
                        onPressed: () => _scrollToKey(_navItems[i].key),
                        style: TextButton.styleFrom(
                          foregroundColor: _activeIndex == i
                              ? Colors.white
                              : Colors.white70,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        child: Text(
                          _navItems[i].label,
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: _activeIndex == i
                                ? FontWeight.bold
                                : FontWeight.w500,
                            decoration: _activeIndex == i
                                ? TextDecoration.underline
                                : null,
                            decorationColor: Colors.white54,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ),
                  IconButton(
                    onPressed: () => _openUrl(_github),
                    icon: const Icon(Icons.code),
                  ),
                  IconButton(
                    onPressed: () => _openUrl(_linkedin),
                    icon: const Icon(Icons.business),
                  ),
                  const SizedBox(width: 8),
                ],
        ),
        drawer: isMobile
            ? Drawer(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                        ),
                        child: Text(
                          'معرض أعمالي',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (var i = 0; i < _navItems.length; i++)
                        ListTile(
                          title: Text(
                            _navItems[i].label,
                            style: GoogleFonts.cairo(),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Future.delayed(
                              const Duration(milliseconds: 200),
                              () => _scrollToKey(_navItems[i].key),
                            );
                          },
                        ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.code),
                                label: const Text('GitHub'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _openUrl(_github);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.business),
                                label: const Text('LinkedIn'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _openUrl(_linkedin);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              )
            : null,
        floatingActionButton: _showBackToTop
            ? FloatingActionButton(
                tooltip: 'العودة للأعلى',
                onPressed: () => _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                ),
                child: const Icon(Icons.arrow_upward),
              )
            : null,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              HeroSection(
                key: _heroKey,
                scrollToPortfolio: () => _scrollToKey(_portfolioKey),
                openCV: _openCV,
              ),
              PortfolioSection(key: _portfolioKey, projects: defaultProjects),
              SkillsSection(key: _skillsKey),
              ContactSection(key: _contactKey),
              const FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final GlobalKey key;
  _NavItem({required this.label, required this.key});
}

// ================================= HeroSection =================================
class HeroSection extends StatelessWidget {
  final VoidCallback scrollToPortfolio;
  final VoidCallback openCV;

  const HeroSection({
    super.key,
    required this.scrollToPortfolio,
    required this.openCV,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: isNarrow
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  child: FadeInLeft(
                    delay: const Duration(milliseconds: 120),
                    child: LottieBuilder.asset(
                      'assets/animations/portfolio.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'مرحباً — أنا علي',
                  style: GoogleFonts.cairo(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'مطور Flutter و Web متخصص في بناء تطبيقات عصرية ذات أداء عالي وتجربة مستخدم سلسة. أقدم حلولًا رقمية متكاملة بتصاميم احترافية تلبي احتياجات الأعمال وتحوّل الأفكار إلى منتجات واقعية مميزة.',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: scrollToPortfolio,
                      icon: const Icon(Icons.work),
                      label: const Text('شاهد أعمالي'),
                    ),
                    ElevatedButton.icon(
                      onPressed: openCV,
                      icon: const Icon(Icons.portrait_rounded),
                      label: const Text('عرض CV'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          231,
                          214,
                          248,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 380,
                  height: 300,
                  child: FadeInLeft(
                    delay: const Duration(milliseconds: 120),
                    child: LottieBuilder.asset(
                      'assets/animations/portfolio.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: FadeInRight(
                    delay: const Duration(milliseconds: 150),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'مرحباً — أنا علي',
                          style: GoogleFonts.cairo(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'مطور تطبيقات Flutter و Web',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              onPressed: scrollToPortfolio,
                              icon: const Icon(Icons.work),
                              label: const Text('شاهد أعمالي'),
                            ),
                            ElevatedButton.icon(
                              onPressed: openCV,
                              icon: const Icon(Icons.portrait_rounded),
                              label: const Text('عرض CV'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  231,
                                  214,
                                  248,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// ================================= FooterSection =================================
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 14),
      child: Column(
        children: [
          const Divider(),
          Text(
            '© ${DateTime.now().year} جميع الحقوق محفوظة ل علي',
            style: GoogleFonts.cairo(color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}
