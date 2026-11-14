import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../widgets/flow_widgets.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key, this.activity, required this.date});
  final Activity? activity;
  final DateTime date;
  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final form = GlobalKey<FormState>();
  late TextEditingController name;
  late TimeOfDay time;
  late DateTime date;
  late String frequency;
  late bool reminder;
  late Set<int> days;
  String? error;
  @override
  void initState() {
    super.initState();
    final a = widget.activity;
    name = TextEditingController(text: a?.name);
    time = a?.time ?? const TimeOfDay(hour: 9, minute: 0);
    date = a?.date ?? widget.date;
    frequency = a?.frequency ?? 'Diariamente';
    reminder = a?.reminder ?? false;
    days = {...?a?.days};
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  void save() {
    final valid = form.currentState!.validate();
    if (!valid || (frequency == 'Días concretos' && days.isEmpty)) {
      setState(
        () => error =
            'Revisa los campos indicados.${days.isEmpty && frequency == 'Días concretos' ? ' Selecciona al menos un día.' : ''}',
      );
      return;
    }
    final a =
        widget.activity ??
        Activity(
          id: DateTime.now().microsecondsSinceEpoch,
          name: name.text.trim(),
          time: time,
          date: date,
        );
    a.name = name.text.trim();
    a.time = time;
    a.frequency = frequency;
    a.days = days.toList();
    a.date = date;
    a.reminder = reminder;
    Navigator.pop(context, a);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const FlowPageBar(),
    body: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Form(
          key: form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeading(
                  widget.activity == null
                      ? 'Nueva actividad'
                      : 'Editar actividad',
                ),
                const Text(
                  'Organiza un momento para ti',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                if (error != null)
                  Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Error: $error',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                FlowField(
                  controller: name,
                  label: 'Nombre de la actividad',
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Escribe el nombre de la actividad.'
                      : null,
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final value = await showTimePicker(
                      context: context,
                      initialTime: time,
                      builder: (context, child) => MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      ),
                    );
                    if (value != null) setState(() => time = value);
                  },
                  icon: const Icon(Icons.schedule),
                  label: Text(
                    'Hora: ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Frecuencia',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                ...['Diariamente', 'Días concretos', 'Una sola vez'].map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => frequency = f),
                      icon: Icon(
                        frequency == f
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                      ),
                      label: Text(f),
                    ),
                  ),
                ),
                if (frequency == 'Días concretos') ...[
                  const SizedBox(height: 12),
                  ...List.generate(
                    7,
                    (i) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        const [
                          'Lunes',
                          'Martes',
                          'Miércoles',
                          'Jueves',
                          'Viernes',
                          'Sábado',
                          'Domingo',
                        ][i],
                      ),
                      value: days.contains(i + 1),
                      onChanged: (v) => setState(
                        () => v! ? days.add(i + 1) : days.remove(i + 1),
                      ),
                    ),
                  ),
                ],
                if (frequency == 'Una sola vez')
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text('Fecha: ${dateLabel(date)} de ${date.year}'),
                      onPressed: () async {
                        final value = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (value != null) setState(() => date = value);
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Recordatorio opcional'),
                  subtitle: const Text('Solo simulación visual en esta fase'),
                  value: reminder,
                  onChanged: (v) => setState(() => reminder = v),
                ),
                const SizedBox(height: 24),
                PrimaryButton('Guardar', icon: Icons.check, onPressed: save),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class RoutineForm extends StatefulWidget {
  const RoutineForm({super.key, required this.activities, this.routine});
  final List<Activity> activities;
  final Routine? routine;
  @override
  State<RoutineForm> createState() => _RoutineFormState();
}

class _RoutineFormState extends State<RoutineForm> {
  final form = GlobalKey<FormState>();
  late TextEditingController name;
  late Set<int> ids;
  String? error;
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.routine?.name);
    ids = {...?widget.routine?.ids};
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const FlowPageBar(),
    body: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Form(
          key: form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeading(
                  widget.routine == null ? 'Crear rutina' : 'Editar rutina',
                ),
                FlowField(
                  controller: name,
                  label: 'Nombre de la rutina',
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Escribe el nombre de la rutina.'
                      : null,
                ),
                const Text(
                  'Selecciona actividades existentes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                if (widget.activities.isEmpty)
                  const Text(
                    'Crea primero una actividad desde Mis actividades.',
                  ),
                ...widget.activities.map(
                  (a) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(a.name),
                    subtitle: Text('${a.hour} · ${a.frequency}'),
                    value: ids.contains(a.id),
                    onChanged: (v) =>
                        setState(() => v! ? ids.add(a.id) : ids.remove(a.id)),
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    '${ids.length} actividades seleccionadas',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (error != null)
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      'Error: $error',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                PrimaryButton(
                  'Guardar',
                  icon: Icons.check,
                  onPressed: () {
                    final valid = form.currentState!.validate();
                    if (!valid || ids.isEmpty) {
                      setState(
                        () => error = 'Escribe un nombre y selecciona al menos una actividad.',
                      );
                      return;
                    }
                    Navigator.pop(context, Routine(name.text.trim(), ids));
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
