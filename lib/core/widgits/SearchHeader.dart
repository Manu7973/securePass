import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ValueNotifier<bool> showSearch;
  final ValueChanged<String> onChanged;

  SearchHeaderDelegate({
    required this.showSearch,
    required this.onChanged,
  });

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 70;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent) {
    return ValueListenableBuilder<bool>(
      valueListenable: showSearch,
      builder: (_, visible, _) {
        if (!visible) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
          color:  Colors.white,
          child: CupertinoSearchTextField(
            onChanged: onChanged,
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant SearchHeaderDelegate oldDelegate) {
    return true;
  }
}
