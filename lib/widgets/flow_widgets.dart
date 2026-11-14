import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../theme/flow_theme.dart';

enum ButtonKind { primary, complete, undo }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon = Icons.add_rounded,
    this.kind = ButtonKind.primary,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final ButtonKind kind;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: kind == ButtonKind.primary
          ? FlowTheme.gradient
          : kind == ButtonKind.complete
          ? const LinearGradient(colors: [Color(0xFF007F8A), FlowTheme.teal])
          : null,
      color: kind == ButtonKind.undo ? Colors.white : null,
      border: kind == ButtonKind.undo
          ? Border.all(color: FlowTheme.teal, width: 2)
          : null,
      borderRadius: BorderRadius.circular(22),
    ),
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: kind == ButtonKind.undo
            ? FlowTheme.teal
            : Colors.white,
        minimumSize: const Size(48, 56),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    ),
  );
}

class LifeFlowLogo extends StatelessWidget {
  const LifeFlowLogo({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'LifeFlow, organiza tu día a tu ritmo',
    image: true,
    child: ExcludeSemantics(
      child: SizedBox(
        width: 188,
        height: 49,
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 300,
              height: 78,
              child: Stack(
                children: [
                  Positioned(
                    left: -163,
                    top: -85,
                    width: 1024,
                    height: 1536,
                    child: Image.asset(
                      'assets/reference.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class FlowHeader extends StatelessWidget {
  const FlowHeader(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF00D4D8), Color(0xFF247DF0), Color(0xFF793CF0)],
            ),
          ),
        ),
      ),
      Positioned.fill(child: CustomPaint(painter: _Waves())),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LifeFlowLogo(), const SizedBox(height: 16),
            // An opaque dark plate retains the bright reference palette without low-contrast white text.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF143B78),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Waves extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint();
    Path wave(double y, double depth) => Path()
      ..moveTo(0, s.height - y)
      ..cubicTo(
        s.width * .32,
        s.height + depth,
        s.width * .62,
        s.height - y - 68,
        s.width,
        s.height - y - 12,
      )
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    p.color = const Color(0xFFAAF0F3);
    canvas.drawPath(wave(34, 20), p);
    p.color = const Color(0xFFD7DEFF);
    canvas.drawPath(wave(17, 22), p);
    p.color = FlowTheme.background;
    canvas.drawPath(wave(5, 12), p);
  }

  @override
  bool shouldRepaint(_Waves oldDelegate) => false;
}

/// Shared secondary-page identity; title wraps at 200% rather than clipping in AppBar.
class FlowPageBar extends StatelessWidget implements PreferredSizeWidget {
  const FlowPageBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(72);
  @override
  Widget build(BuildContext context) =>
      AppBar(toolbarHeight: 72, title: const LifeFlowLogo());
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: FlowTheme.gradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
  );
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.done, {super.key});
  final bool done;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: done ? const Color(0xFFDCF6E6) : const Color(0xFFDDF1FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            size: 20,
            color: done ? FlowTheme.green : FlowTheme.teal,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              done ? 'Completada' : 'Pendiente',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: done ? FlowTheme.green : FlowTheme.ink,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    required this.date,
    required this.onToggle,
    required this.onDetail,
    this.routine,
  });
  final Activity activity;
  final DateTime date;
  final VoidCallback onToggle, onDetail;
  final String? routine;
  @override
  Widget build(BuildContext context) {
    final done = activity.completed(date);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: done
              ? [const Color(0xFFF0FCF6), const Color(0xFFE0F8EF)]
              : [Colors.white, const Color(0xFFF5F8FF)],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border(
          left: BorderSide(
            color: done ? FlowTheme.green : FlowTheme.teal,
            width: 6,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15245599),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final large =
                  MediaQuery.textScalerOf(context).scale(16) > 20 ||
                  c.maxWidth < 310;
              final symbol = ExcludeSemantics(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: activity.icon == Icons.directions_walk_rounded
                        ? const Color(0xFFDCF8E5)
                        : activity.icon == Icons.restaurant_rounded
                        ? const Color(0xFFFFE8D9)
                        : const Color(0xFFECE3FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    activity.icon,
                    size: 42,
                    color: activity.icon == Icons.directions_walk_rounded
                        ? FlowTheme.green
                        : activity.icon == Icons.restaurant_rounded
                        ? const Color(0xFFB83C17)
                        : FlowTheme.purple,
                  ),
                ),
              );
              final info = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 22,
                            color: FlowTheme.ink,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            activity.hour,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: FlowTheme.ink,
                            ),
                          ),
                        ],
                      ),
                      StatusBadge(done),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Semantics(
                    header: true,
                    child: Text(
                      activity.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: FlowTheme.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${activity.frequency}${routine == null ? '' : ' · $routine'}',
                    style: const TextStyle(
                      color: FlowTheme.muted,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
              return large
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [symbol, const SizedBox(height: 12), info],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        symbol,
                        const SizedBox(width: 14),
                        Expanded(child: info),
                      ],
                    );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final buttons = [
                PrimaryButton(
                  done ? 'Deshacer' : 'Completar',
                  kind: done ? ButtonKind.undo : ButtonKind.complete,
                  icon: done ? Icons.undo : Icons.check,
                  onPressed: onToggle,
                ),
                OutlinedButton(
                  onPressed: onDetail,
                  child: const Text('Ver detalle'),
                ),
              ];
              if (c.maxWidth < 300 ||
                  MediaQuery.textScalerOf(context).scale(16) > 20) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buttons[0],
                    const SizedBox(height: 10),
                    buttons[1],
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: buttons[0]),
                  const SizedBox(width: 12),
                  Expanded(child: buttons[1]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class FlowNavigation extends StatelessWidget {
  const FlowNavigation({
    super.key,
    required this.index,
    required this.onChanged,
  });
  final int index;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 2,
    shadowColor: const Color(0x33245599),
    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (context, c) {
            final labels = ['Hoy', 'Agenda', 'Mis actividades', 'Mis rutinas'];
            final icons = [
              Icons.wb_sunny_outlined,
              Icons.calendar_today_outlined,
              Icons.format_list_bulleted_rounded,
              Icons.layers_outlined,
            ];
            final large = MediaQuery.textScalerOf(context).scale(16) > 20;
            final items = List.generate(
              4,
              (i) => Semantics(
                selected: index == i,
                child: TextButton(
                  onPressed: () => onChanged(i),
                  style: TextButton.styleFrom(
                    foregroundColor: FlowTheme.ink,
                    backgroundColor: index == i
                        ? const Color(0xFFDDF1FF)
                        : Colors.transparent,
                    minimumSize: const Size(48, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[i],
                        size: 30,
                        color: index == i ? FlowTheme.teal : FlowTheme.muted,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            return large
                ? Wrap(
                    children: items
                        .map((w) => SizedBox(width: c.maxWidth / 2, child: w))
                        .toList(),
                  )
                : Row(children: items.map((w) => Expanded(child: w)).toList());
          },
        ),
      ),
    ),
  );
}

class FlowField extends StatelessWidget {
  const FlowField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
  });
  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: FlowTheme.ink,
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: label,
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: const InputDecoration(errorMaxLines: 8),
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
      ],
    ),
  );
}
