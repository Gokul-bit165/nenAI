import 'package:flutter/material.dart';

/// Clean, horizontal scrollable breadcrumb component displaying hierarchical context paths.
/// Example: Meeting with Dean → Project Discussion → ReadSmart AI → Deployment → Testing
class ContextBreadcrumbPath extends StatelessWidget {
  const ContextBreadcrumbPath({
    super.key,
    required this.pathNodes,
    this.primaryColor = const Color(0xFF6366F1),
    this.backgroundColor = const Color(0xFFF1F5F9),
  });

  final List<String> pathNodes;
  final Color primaryColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (pathNodes.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < pathNodes.length; i++) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: i == pathNodes.length - 1
                    ? primaryColor.withValues(alpha: 0.12)
                    : backgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: i == pathNodes.length - 1
                      ? primaryColor.withValues(alpha: 0.35)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    i == 0
                        ? Icons.folder_open_rounded
                        : (i == pathNodes.length - 1
                            ? Icons.my_location_rounded
                            : Icons.subdirectory_arrow_right_rounded),
                    size: 13,
                    color: i == pathNodes.length - 1
                        ? primaryColor
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    pathNodes[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: i == pathNodes.length - 1
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: i == pathNodes.length - 1
                          ? primaryColor
                          : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
            if (i < pathNodes.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
