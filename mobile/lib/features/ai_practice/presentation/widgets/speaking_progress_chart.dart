
import 'package:flutter/material.dart';

import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';

class SpeakingProgressChart extends StatelessWidget {
  final List<SpeakingSessionResult> sessions;

  const SpeakingProgressChart({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    // Sort sessions from oldest to newest.
    final sortedSessions = List<SpeakingSessionResult>.from(sessions)
      ..sort(
        (a, b) => a.completedAt.compareTo(b.completedAt),
      );

    if (sortedSessions.isEmpty) {
      return const SizedBox.shrink();
    }

    final scores = sortedSessions
        .map((session) => session.metrics.practiceScore)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Speaking Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your practice score across sessions',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 190,
            width: double.infinity,
            child: CustomPaint(
              painter: _SpeakingChartPainter(scores),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(sortedSessions.first.completedAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                '${sortedSessions.length} ${sortedSessions.length == 1 ? 'session' : 'sessions'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
              Text(
                _formatDate(sortedSessions.last.completedAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month';
  }
}

class _SpeakingChartPainter extends CustomPainter {
  final List<double> scores;

  _SpeakingChartPainter(this.scores);

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 30.0;
    const rightPadding = 10.0;
    const topPadding = 10.0;
    const bottomPadding = 15.0;

    final chartWidth =
        size.width - leftPadding - rightPadding;

    final chartHeight =
        size.height - topPadding - bottomPadding;

    final chartLeft = leftPadding;
    final chartTop = topPadding;

    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.fill;

    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final textStyle = const TextStyle(
      fontSize: 10,
      color: Color(0xFF64748B),
    );

    // Draw horizontal grid lines and score labels.
    for (var value = 0; value <= 100; value += 25) {
      final y = chartTop +
          chartHeight -
          (value / 100 * chartHeight);

      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartLeft + chartWidth, y),
        gridPaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: '$value',
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(0, y - textPainter.height / 2),
      );
    }

    if (scores.isEmpty) return;

    final points = <Offset>[];

    for (var i = 0; i < scores.length; i++) {
      final x = scores.length == 1
          ? chartLeft + chartWidth / 2
          : chartLeft +
              (i / (scores.length - 1)) * chartWidth;

      final score = scores[i].clamp(0.0, 100.0);

      final y = chartTop +
          chartHeight -
          (score / 100 * chartHeight);

      points.add(Offset(x, y));
    }

    // Draw the progress line.
    if (points.length > 1) {
      final path = Path()
        ..moveTo(points.first.dx, points.first.dy);

      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      canvas.drawPath(path, linePaint);
    }

    // Draw circular markers for each session.
    for (final point in points) {
      canvas.drawCircle(point, 6, pointBorderPaint);
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(
    covariant _SpeakingChartPainter oldDelegate,
  ) {
    return oldDelegate.scores != scores;
  }
}
