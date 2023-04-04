import 'package:flutter/material.dart';

class ShowDialog extends StatelessWidget {
  final List<PopupMenuEntry> menulist;
  final Widget? icon;
  const ShowDialog({
    super.key,
    required this.menulist,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => menulist,
      icon: icon,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
