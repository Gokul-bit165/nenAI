import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/cluster.dart';
import '../../../domain/entities/note.dart';

class ObsidianGraphWidget extends StatefulWidget {
  const ObsidianGraphWidget({
    super.key,
    required this.clusters,
    required this.notes,
  });

  final List<Cluster> clusters;
  final List<Note> notes;

  @override
  State<ObsidianGraphWidget> createState() => _ObsidianGraphWidgetState();
}

class _ObsidianGraphWidgetState extends State<ObsidianGraphWidget> with SingleTickerProviderStateMixin {
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
    if (oldWidget.clusters != widget.clusters || oldWidget.notes != widget.notes) {
      _calculateNodePositions();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _calculateNodePositions() {
    _nodePositions.clear();
    if (widget.clusters.isEmpty) return;

    const center = Offset(0, 0);
    final clusterCount = widget.clusters.length;
    final radius = math.max(180.0, clusterCount * 80.0);

    for (int i = 0; i < clusterCount; i++) {
      final cluster = widget.clusters[i];
      final angle = (2 * math.pi * i) / clusterCount;
      final clusterPos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      _nodePositions['cluster_${cluster.id}'] = clusterPos;

      // Position child notes around cluster hub
      final clusterNotes = widget.notes.where((n) => n.clusterId == cluster.id).toList();
      final noteCount = clusterNotes.length;
      final noteRadius = math.max(60.0, noteCount * 22.0);

      for (int j = 0; j < noteCount; j++) {
        final note = clusterNotes[j];
        final noteAngle = angle + (2 * math.pi * j) / math.max(1, noteCount) + (math.pi / 6);
        final notePos = Offset(
          clusterPos.dx + noteRadius * math.cos(noteAngle),
          clusterPos.dy + noteRadius * math.sin(noteAngle),
        );
        _nodePositions['note_${note.id}'] = notePos;
      }
    }

    // Position unclustered notes in outer ring
    final unclustered = widget.notes.where((n) => n.clusterId == null).toList();
    for (int k = 0; k < unclustered.length; k++) {
      final note = unclustered[k];
      final angle = (2 * math.pi * k) / math.max(1, unclustered.length);
      _nodePositions['note_${note.id}'] = Offset(
        center.dx + (radius + 220) * math.cos(angle),
        center.dy + (radius + 220) * math.sin(angle),
      );
    }
  }

  void _handleTap(Offset localPosition, Size widgetSize) {
    final centerOffset = Offset(widgetSize.width / 2, widgetSize.height / 2);

    for (final cluster in widget.clusters) {
      final rawPos = _nodePositions['cluster_${cluster.id}'];
      if (rawPos != null) {
        final transformed = (rawPos * _scale) + _panOffset + centerOffset;
        if ((localPosition - transformed).distance <= 35 * _scale) {
          context.push('/topics/${cluster.id}');
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
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
                isDark: isDark,
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
    required this.isDark,
  });

  final List<Cluster> clusters;
  final List<Note> notes;
  final Map<String, Offset> nodePositions;
  final Offset panOffset;
  final double scale;
  final double pulseValue;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final centerOffset = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(centerOffset.dx + panOffset.dx, centerOffset.dy + panOffset.dy);
    canvas.scale(scale);

    // 1. Draw Connection Lines (Edges)
    final linePaint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.12)
      ..strokeWidth = 1.2;

    for (final cluster in clusters) {
      final clusterPos = nodePositions['cluster_${cluster.id}'];
      if (clusterPos == null) continue;

      final clusterNotes = notes.where((n) => n.clusterId == cluster.id).toList();
      for (final note in clusterNotes) {
        final notePos = nodePositions['note_${note.id}'];
        if (notePos != null) {
          canvas.drawLine(clusterPos, notePos, linePaint);
        }
      }
    }

    // 2. Draw Note Leaf Nodes
    final noteNodePaint = Paint()
      ..color = isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);

    for (final note in notes) {
      final pos = nodePositions['note_${note.id}'];
      if (pos != null) {
        canvas.drawCircle(pos, 6.0, noteNodePaint);
      }
    }

    // 3. Draw Cluster Hub Nodes with Glow & Labels
    for (final cluster in clusters) {
      final pos = nodePositions['cluster_${cluster.id}'];
      if (pos == null) continue;

      final color = _parseColor(cluster.colorHex);
      final pulseRadius = 24.0 + (pulseValue * 6.0);

      // Outer Glow
      final glowPaint = Paint()
        ..color = color.withOpacity(0.25 - (pulseValue * 0.1))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(pos, pulseRadius + 6, glowPaint);

      // Cluster Hub Circle
      final hubPaint = Paint()..color = color;
      canvas.drawCircle(pos, 22.0, hubPaint);

      // White inner ring
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(pos, 22.0, borderPaint);

      // Cluster Name Label
      final textPainter = TextPainter(
        text: TextSpan(
          text: cluster.name,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: isDark ? Colors.black : Colors.white,
                blurRadius: 4,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(pos.dx - (textPainter.width / 2), pos.dy + 26.0));
    }

    canvas.restore();
  }

  Color _parseColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
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
