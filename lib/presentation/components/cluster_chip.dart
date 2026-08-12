import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ClusterChip extends StatelessWidget {
  const ClusterChip({
    super.key,
    required this.name,
    this.colorHex,
  });

  final String name;
  final String? colorHex;

  (Color, Color) _getColors(String clusterName, String? hex) {
    final lower = clusterName.toLowerCase();
    if (lower.contains('tech')) {
      return (AppColors.clusterTech, AppColors.clusterTechBg);
    } else if (lower.contains('project')) {
      return (AppColors.clusterProjects, AppColors.clusterProjectsBg);
    } else if (lower.contains('ai') || lower.contains('ml')) {
      return (AppColors.clusterAi, AppColors.clusterAiBg);
    } else if (lower.contains('person')) {
      return (AppColors.clusterPersonal, AppColors.clusterPersonalBg);
    } else if (lower.contains('book')) {
      return (AppColors.clusterBooks, AppColors.clusterBooksBg);
    } else if (lower.contains('idea')) {
      return (AppColors.clusterIdeas, AppColors.clusterIdeasBg);
    }

    if (hex != null && hex.isNotEmpty) {
      try {
        final buffer = StringBuffer();
        if (hex.length == 6 || hex.length == 7) buffer.write('ff');
        buffer.write(hex.replaceFirst('#', ''));
        final color = Color(int.parse(buffer.toString(), radix: 16));
        return (color, color.withOpacity(0.14));
      } catch (_) {}
    }

    return (AppColors.primary, AppColors.primaryTint);
  }

  @override
  Widget build(BuildContext context) {
    final (textColor, bgColor) = _getColors(name, colorHex);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        name,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
