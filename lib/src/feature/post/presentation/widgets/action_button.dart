import 'package:flutter/material.dart';

// some changes

class ActionButton extends StatelessWidget {
  final IconData icon;
  final int? count;
  final Function() onTap;
  final Color? iconColor;

  const ActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? Colors.white),
            const SizedBox(width: 4),
            Text(
              '${count ?? ''}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
