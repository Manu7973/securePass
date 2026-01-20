import 'package:flutter/material.dart';
import '../../features/feature_home/domain/PasswordEntity.dart';
import '../../features/feature_home/domain/SiteCategory.dart';
import 'PasswordDetailsSheet.dart';

class PasswordCard extends StatelessWidget {
  final PasswordEntity item;

  const PasswordCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = SiteCategoryUI.color(item.category);
    final icon = SiteCategoryUI.icon(item.category);

    return GestureDetector(
      onTap: () => _showPasswordDetails(context),
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.0, 0.015],
            colors: [
              color,
              Colors.white,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 12, 0),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.site,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  void _showPasswordDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PasswordDetailsSheet(item: item),
    );
  }
}


class SiteCategoryUI {
  static Color color(SiteCategory category) {
    switch (category) {
      case SiteCategory.email:
        return Colors.redAccent;
      case SiteCategory.chat:
        return Colors.green;
      case SiteCategory.social:
        return Colors.blue;
      case SiteCategory.banking:
        return Colors.purple;
      case SiteCategory.dating:
        return Colors.pink;
      case SiteCategory.shopping:
        return Colors.orange;
      case SiteCategory.entertainment:
        return Colors.deepPurple;
      case SiteCategory.app:
        return Colors.teal;
      case SiteCategory.website:
        return Colors.indigo;
      case SiteCategory.other:
        return Colors.white12;
      default:
        return Colors.grey;
    }
  }

  static IconData icon(SiteCategory category) {
    switch (category) {
      case SiteCategory.email:
        return Icons.email_rounded;
      case SiteCategory.chat:
        return Icons.chat_bubble_rounded;
      case SiteCategory.social:
        return Icons.people_alt_rounded;
      case SiteCategory.banking:
        return Icons.account_balance_rounded;
      case SiteCategory.dating:
        return Icons.favorite_rounded;
      case SiteCategory.shopping:
        return Icons.shopping_bag_rounded;
      case SiteCategory.entertainment:
        return Icons.movie_rounded;
      case SiteCategory.app:
        return Icons.apps_rounded;
      case SiteCategory.website:
        return Icons.language_rounded;
      case SiteCategory.other:
        return Icons.vpn_key_rounded;
      default:
        return Icons.vpn_key_rounded;
    }
  }
}
