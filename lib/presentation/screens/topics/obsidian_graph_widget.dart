import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/cluster.dart';
import '../../../domain/entities/note.dart';
import '../../theme/app_colors.dart';

class ObsidianGraphWidget extends StatefulWidget {
  const ObsidianGraphWidget({
    super.key,
    required this.clusters,
    required this.notes,
    this.onRecenter,
  });

  final List<Cluster> clusters;
  final List<Note> notes;
  final VoidCallback? onRecenter;

  @override
  State<ObsidianGraphWidget> createState() => ObsidianGraphWidgetState();
}

class ObsidianGraphWidgetState extends State<ObsidianGraphWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Offset _panOffset = Offset.zero;
  double _scale = 1.0;

  final Map<String, Offset> _nodePositions = {};

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _calculateNodePositions();
  }

  @override
  void didUpdateWidget(ObsidianGraphWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clusters != widget.clusters ||
        oldWidget.notes != widget.notes) {
      _calculateNodePositions();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void recenter() {
    setState(() {
      _panOffset = Offset.zero;
      _scale = 1.0;
    });
  }

  void _calculateNodePositions() {
    _nodePositions.clear();
    if (widget.clusters.isEmpty) return;

    const center = Offset(0, 0);
    // Find highest note count cluster to put in center, or position radially
    final clusterCount = widget.clusters.length;
    final radius = math.max(140.0, clusterCount * 45.0);

    // Primary central cluster (first/largest)
    final mainCluster = widget.clusters.first;
    _nodePositions['cluster_${mainCluster.id}'] = center;

    // Outer clusters in radial layout
    final outerClusters = widget.clusters.skip(1).toList();
    final outerCount = outerClusters.length;

    for (int i = 0; i < outerCount; i++) {
      final cluster = outerClusters[i];
      final angle = (2 * math.pi * i) / math.max(1, outerCount) - (math.pi / 2);
      final clusterPos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      _nodePositions['cluster_${cluster.id}'] = clusterPos;
    }

    // Position notes
    for (final cluster in widget.clusters) {
      final clusterPos = _nodePositions['cluster_${cluster.id}'] ?? center;
      final clusterNotes =
          widget.notes.where((n) => n.clusterId == cluster.id).toList();
      final noteCount = clusterNotes.length;
      final noteRadius = math.max(45.0, noteCount * 12.0);

      for (int j = 0; j < noteCount; j++) {
        final note = clusterNotes[j];
        final noteAngle = (2 * math.pi * j) / math.max(1, noteCount);
        final notePos = Offset(
          clusterPos.dx + noteRadius * math.cos(noteAngle),
          clusterPos.dy + noteRadius * math.sin(noteAngle),
        );
        _nodePositions['note_${note.id}'] = notePos;
      }
    }
  }

  void _handleTap(Offset localPosition, Size widgetSize) {
    final centerOffset = Offset(widgetSize.width / 2, widgetSize.height / 2);

    for (final cluster in widget.clusters) {
      final rawPos = _nodePositions['cluster_${cluster.id}'];
      if (rawPos != null) {
        final transformed = (rawPos * _scale) + _panOffset + centerOffset;
        if ((localPosition - transformed).distance <= 45 * _scale) {
          context.push('/topics/${cluster.id}', extra: cluster.name);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) {
        setState(() {
          _panOffset += details.focalPointDelta;
          if (details.scale != 1.0) {
            _scale = (_scale * details.scale).clamp(0.4, 2.5);
          }
        });
      },
      onTapUp: (details) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          _handleTap(details.localPosition, renderBox.size);
        }
      },
      child: Container(
        color: AppColors.background,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return CustomPaint(
              painter: ObsidianGraphPainter(
                clusters: widget.clusters,
                notes: widget.notes,
                nodePositions: _nodePositions,
                panOffset: _panOffset,
                scale: _scale,
                pulseValue: _pulseController.value,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
      ),
    );
  }
}

class ObsidianGraphPainter extends CustomPainter {
  ObsidianGraphPainter({
    required this.clusters,
    required this.notes,
    required this.nodePositions,
    required this.panOffset,
    required this.scale,
    required this.pulseValue,
  });

  final List<Cluster> clusters;
  final List<Note> notes;
  final Map<String, Offset> nodePositions;
  final Offset panOffset;
  final double scale;
  final double pulseValue;

  @override
  void paint(Canvas canvas, Size size) {
    final centerOffset = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(
        centerOffset.dx + panOffset.dx, centerOffset.dy + panOffset.dy);
    canvas.scale(scale);

    // 1. Draw Connection Lines (Edges) between Central Cluster & Outer Clusters
    final mainClusterPos =
        clusters.isNotEmpty ? nodePositions['cluster_${clusters.first.id}'] : null;

    final linePaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    if (mainClusterPos != null) {
      for (int i = 1; i < clusters.length; i++) {
        final outerPos = nodePositions['cluster_${clusters[i].id}'];
        if (outerPos != null) {
          canvas.drawLine(mainClusterPos, outerPos, linePaint);
        }
      }
    }

    // 2. Draw Cluster Hub Nodes
    for (int i = 0; i < clusters.length; i++) {
      final cluster = clusters[i];
      final pos = nodePositions['cluster_${cluster.id}'];
      if (pos == null) continue;

      final isCenter = i == 0;
      final (textColor, bgColor) = _getColors(cluster.name, isCenter);
      final hubRadius = isCenter ? 44.0 : 36.0;

      // Soft outer shadow/glow
      final glowPaint = Paint()
        ..color = textColor.withOpacity(0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(pos, hubRadius + 4, glowPaint);

      // Hub Circle
      final hubPaint = Paint()..color = bgColor;
      canvas.drawCircle(pos, hubRadius, hubPaint);

      // Hub Border
      final borderPaint = Paint()
        ..color = textColor.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(pos, hubRadius, borderPaint);

      // Text Title & Note Count inside the circle
      final titlePainter = TextPainter(
        text: TextSpan(
          text: '${cluster.name}\n',
          style: TextStyle(
            color: textColor,
            fontSize: isCenter ? 12 : 11,
            fontWeight: FontWeight.w700,
          ),
          children: [
            TextSpan(
              text: '${cluster.noteCount} Notes',
              style: TextStyle(
                color: isCenter
                    ? Colors.white.withOpacity(0.85)
                    : textColor.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      titlePainter.layout(maxWidth: hubRadius * 2 - 4);
      titlePainter.paint(
        canvas,
        Offset(pos.dx - (titlePainter.width / 2),
            pos.dy - (titlePainter.height / 2)),
      );
    }

    canvas.restore();
  }

  (Color, Color) _getColors(String name, bool isCenter) {
    if (isCenter) {
      return (Colors.white, AppColors.primary);
    }
    final lower = name.toLowerCase();
    if (lower.contains('ai') || lower.contains('ml')) {
      return (AppColors.clusterAi, AppColors.clusterAiBg);
    } else if (lower.contains('project')) {
      return (AppColors.clusterProjects, AppColors.clusterProjectsBg);
    } else if (lower.contains('person')) {
      return (AppColors.clusterPersonal, AppColors.clusterPersonalBg);
    } else if (lower.contains('book')) {
      return (AppColors.clusterBooks, AppColors.clusterBooksBg);
    } else if (lower.contains('idea')) {
      return (AppColors.clusterIdeas, AppColors.clusterIdeasBg);
    }
    return (AppColors.primary, AppColors.primaryTint);
  }

  @override
  bool shouldRepaint(covariant ObsidianGraphPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.scale != scale ||
        oldDelegate.clusters != clusters ||
        oldDelegate.notes != notes;
  }
}
