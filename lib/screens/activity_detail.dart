import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../widgets/flow_widgets.dart';

class ActivityDetail extends StatefulWidget {
  const ActivityDetail({
    super.key,
    required this.activity,
    required this.date,
    required this.onToggle,
    required this.onEdit,
    this.saved = false,
  });
  final Activity activity;
  final DateTime date;
  final VoidCallback onToggle;
  final Future<void> Function() onEdit;
  final bool saved;
  @override
  State<ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  @override
  Widget build(BuildContext context) {
    final a = widget.activity;
    return Scaffold(
      appBar: const FlowPageBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PageHeading('Detalle de actividad'),
                if (widget.saved)
                  Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text(
                        'Actividad guardada',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                Icon(
                  a.icon,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(a.name, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                StatusBadge(a.completed(widget.date)),
                const SizedBox(height: 24),
                Text(
                  'Horario: ${a.hour}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Frecuencia: ${a.frequency}'),
                if (a.frequency == 'Días concretos')
                  Text(
                    'Días: ${a.days.map((i) => const ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'][i - 1]).join(', ')}',
                  ),
                if (a.frequency == 'Una sola vez')
                  Text('Fecha: ${dateLabel(a.date)} de ${a.date.year}'),
                const SizedBox(height: 16),
                Text(
                  a.reminder
                      ? 'Recordatorio activado (simulado)'
                      : 'Sin recordatorio',
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  a.completed(widget.date) ? 'Deshacer' : 'Completar',
                  icon: a.completed(widget.date) ? Icons.undo : Icons.check,
                  onPressed: () {
                    widget.onToggle();
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    await widget.onEdit();
                    if (mounted) setState(() {});
                  },
                  child: const Text('Editar actividad'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
