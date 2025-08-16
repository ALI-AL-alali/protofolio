import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:my_portfolio/widgets/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final String sendToEmail;
  final String linkedIn;
  final String gitHub;

  const ContactSection({
    super.key,
    this.sendToEmail = 'alialali13484@gmail.com',
    this.linkedIn = 'https://www.linkedin.com/in/ali-alali-06b560325/',
    this.gitHub = 'https://github.com/ALI-AL-alali',
  });

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر فتح الرابط')));
    }
  }

  void _copyEmail(BuildContext context) {
    Clipboard.setData(ClipboardData(text: sendToEmail));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم نسخ البريد الإلكتروني')));
  }

  Widget _buildCard(BuildContext context, Widget child) {
    return Card(
      elevation: 8,
      shadowColor: Colors.deepPurple.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: ResponsiveUtils.responsivePadding(
          context,
          mobile: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          tablet: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          desktop: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;
    final textColor = Colors.grey[800];

    final titleSize = ResponsiveUtils.responsiveTextSize(
      context,
      mobile: 24,
      tablet: 28,
      desktop: 32,
    );

    final subtitleSize = ResponsiveUtils.responsiveTextSize(
      context,
      mobile: 14,
      tablet: 15,
      desktop: 16,
    );

    final cardsSpacing = ResponsiveUtils.responsiveValue(
      context,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );

    // ✅ تعديل: نجيب العرض من context
    final isMobile = ResponsiveUtils.isMobileContext(context);

    final emailCard = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: primaryColor.withOpacity(0.1),
            child: Icon(Icons.email, color: primaryColor),
          ),
          title: SelectableText(
            sendToEmail,
            style: GoogleFonts.cairo(
              fontSize: subtitleSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.copy, color: primaryColor),
                onPressed: () => _copyEmail(context),
                tooltip: 'نسخ البريد الإلكتروني',
              ),
              IconButton(
                icon: Icon(Icons.open_in_new, color: primaryColor),
                onPressed: () => _openUrl(context, 'mailto:$sendToEmail'),
                tooltip: 'فتح البريد',
              ),
            ],
          ),
        ),
      ],
    );

    final linkedInCard = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.link, color: Colors.blue.shade700),
          ),
          title: Text(
            'LinkedIn',
            style: GoogleFonts.cairo(
              fontSize: subtitleSize,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade800,
            ),
          ),
          trailing: IconButton(
            onPressed: () => _openUrl(context, linkedIn),
            icon: Icon(Icons.open_in_new, color: Colors.blue.shade700),
            tooltip: 'زيارة LinkedIn',
          ),
        ),
      ],
    );

    final gitHubCard = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.black87,
            child: Icon(Icons.code, color: Colors.white),
          ),
          title: Text(
            'GitHub',
            style: GoogleFonts.cairo(
              fontSize: subtitleSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          trailing: IconButton(
            onPressed: () => _openUrl(context, gitHub),
            icon: const Icon(Icons.open_in_new, color: Colors.black87),
            tooltip: 'زيارة GitHub',
          ),
        ),
      ],
    );

    final cards = [
      _buildCard(context, emailCard),
      _buildCard(context, linkedInCard),
      _buildCard(context, gitHubCard),
    ];

    return Padding(
      padding: ResponsiveUtils.responsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        desktop: const EdgeInsets.symmetric(horizontal: 36, vertical: 50),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '📞 تواصل معي',
                  style: GoogleFonts.cairo(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: cardsSpacing),
                Text(
                  'يمكنك التواصل معي عبر البريد الإلكتروني أو زيارة حساباتي على LinkedIn وGitHub.',
                  style: GoogleFonts.cairo(
                    color: Colors.grey[600],
                    fontSize: subtitleSize,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: cardsSpacing * 2),

                // ✅ Responsive Layout للبطاقات
                isMobile
                    ? Column(
                        children: cards
                            .map(
                              (card) => Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: cardsSpacing / 2,
                                ),
                                child: card,
                              ),
                            )
                            .toList(),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: cards
                            .map(
                              (card) => Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: cardsSpacing / 2,
                                  ),
                                  child: card,
                                ),
                              ),
                            )
                            .toList(),
                      ),

                SizedBox(height: cardsSpacing * 2),
                Text(
                  'متاح للعمل الحر — تواصل لتناقش فكرة مشروعك.',
                  style: GoogleFonts.cairo(
                    color: Colors.grey[600],
                    fontSize: subtitleSize,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
