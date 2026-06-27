import 'package:flutter/material.dart';

class AdminSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isDanger;

  const AdminSection({
    super.key,
    required this.title,
    required this.children,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              if (isDanger) ...[
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6467), size: 16),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  color: isDanger ? const Color(0xFFFF6467) : const Color(0xFF6A7282),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDanger ? const Color(0xFFFB2C36).withOpacity(0.3) : const Color(0xFF262626),
              width: 1.5,
            ),
          ),
          child: Column(
            children: _buildChildrenWithDividers(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    List<Widget> items = [];
    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(
          Container(
            height: 1.5,
            color: isDanger ? const Color(0xFFFB2C36).withOpacity(0.2) : const Color(0xFF262626),
          ),
        );
      }
    }
    return items;
  }
}
