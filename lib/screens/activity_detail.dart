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
    this.routine,
  });
  final Activity activity;
  final DateTime date;
  final VoidCallback onToggle;
  final Future<bool> Function() onEdit;
  final bool saved;

  /// Nombre de la rutina a la que pertenece la actividad, si tiene.
  final String? routine;
  @override
  State<ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  /// Confirmación visible tras crear o editar; liveRegion para que se anuncie.
  late String? status = widget.saved ? 'Actividad guardada' : null;

  /// Foco del botón Completar/Deshacer: al cambiar de estado, el botón cambia
  /// de nombre y el foco debe seguir en él, sin saltar a otra parte.
  final toggleFocus = FocusNode(debugLabel: 'Completar o deshacer');

  @override
  void dispose() {
    toggleFocus.dispose();
    super.dispose();
  }

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
                if (status != null)
                  Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        status!,
                        style: const TextStyle(
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
                if (widget.routine != null) Text('Rutina: ${widget.routine}'),
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
                  focusNode: toggleFocus,
                  onPressed: () {
                    widget.onToggle();
                    setState(() {});
                    // Tras reconstruir, el foco queda en el botón con su nuevo
                    // nombre (Deshacer / Completar).
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) toggleFocus.requestFocus();
                    });
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    final saved = await widget.onEdit();
                    if (mounted) {
                      setState(() {
                        if (saved) status = 'Cambios guardados';
                      });
                    }
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
