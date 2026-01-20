import 'SiteCategory.dart';

class SiteCategoryClassifier {
  static SiteCategory detect(String site) {
    final s = site.toLowerCase();

    if (s.contains('gmail') || s.contains('mail')) return SiteCategory.email;
    if (s.contains('whatsapp') || s.contains('telegram')) return SiteCategory.chat;
    if (s.contains('facebook') || s.contains('instagram')) return SiteCategory.social;
    if (s.contains('bank') || s.contains('hdfc') || s.contains('icici')) {
      return SiteCategory.banking;
    }
    if (s.contains('tinder') || s.contains('bumble')) return SiteCategory.dating;
    if (s.contains('.')) return SiteCategory.website;

    return SiteCategory.app;
  }
}
