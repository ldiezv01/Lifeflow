import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../models/activity.dart';
import '../theme/flow_theme.dart';
import '../widgets/flow_widgets.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key, this.activity, required this.date});
  final Activity? activity;
  final DateTime date;
  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  static const frequencies = ['Diariamente', 'Días concretos', 'Una sola vez'];
  static const nameError = 'Escribe un nombre para la actividad.';
  static const daysError = 'Elige al menos un día de la semana.';
  final form = GlobalKey<FormState>();
  final nameKey = GlobalKey();
  final daysKey = GlobalKey();
  final nameFocus = FocusNode();
  final firstDayFocus = FocusNode();
  late TextEditingController name;
  late TimeOfDay time;
  late DateTime date;
  late String frequency;
  late bool reminder;
  late Set<int> days;

  /// Tras el primer intento de guardar, los errores se muestran y se actualizan
  /// al corregir; los datos escritos no se borran.
  bool submitted = false;
  String? get dayError =>
      submitted && frequency == 'Días concretos' && days.isEmpty
      ? daysError
      : null;
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
    nameFocus.dispose();
    firstDayFocus.dispose();
    super.dispose();
  }

  void save() {
    setState(() => submitted = true);
    // Form.validate() ya anuncia el primer error de texto (o lo marca como
    // liveRegion donde el sistema no admite anuncios): no se repite aquí.
    final nameOk = form.currentState!.validate();
    final daysOk = dayError == null;
    if (!nameOk || !daysOk) {
      // Vista y foco al primer campo con error; los datos escritos se conservan.
      revealError(
        context,
        nameOk ? firstDayFocus : nameFocus,
        nameOk ? daysKey : nameKey,
      );
      if (nameOk) announce(context, daysError);
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

  Widget frequencyOption(String f) {
    final checked = frequency == f;
    // Semantics explícito: OutlinedButton no expone rol de radio ni estado marcado.
    return MergeSemantics(
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        checked: checked,
        child: OutlinedButton.icon(
          onPressed: () => setState(() => frequency = f),
          // Elegida: borde grueso y negrita además del icono, no solo color.
          style: OutlinedButton.styleFrom(
            backgroundColor: checked ? const Color(0xFFDDF1FF) : Colors.white,
            side: checked
                ? const BorderSide(color: FlowTheme.teal, width: 3)
                : const BorderSide(color: FlowTheme.muted),
            textStyle: TextStyle(
              fontFamily: 'LifeFlow',
              fontSize: 16,
              fontWeight: checked ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
          icon: ExcludeSemantics(
            child: Icon(
              checked
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
            ),
          ),
          label: Text(f),
        ),
      ),
    );
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
                FlowField(
                  key: nameKey,
                  controller: name,
                  focusNode: nameFocus,
                  label: 'Nombre de la actividad',
                  isRequired: true,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? nameError : null,
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
                // Grupo de opciones excluyentes; su encabezado visible lo nombra.
                Semantics(
                  container: true,
                  role: SemanticsRole.radioGroup,
                  explicitChildNodes: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        header: true,
                        // Android (Flutter 3.50) solo marca encabezado si hay headingLevel.
                        headingLevel: 2,
                        child: const Text(
                          'Frecuencia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      for (final f in frequencies)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: frequencyOption(f),
                        ),
                    ],
                  ),
                ),
                if (frequency == 'Días concretos') ...[
                  const SizedBox(height: 16),
                  Semantics(
                    key: daysKey,
                    header: true,
                    // Android (Flutter 3.50) solo marca encabezado si hay headingLevel.
                    headingLevel: 2,
                    child: const Text(
                      'Días de la semana (obligatorio)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (dayError != null) FieldError(dayError!),
                  ...List.generate(
                    7,
                    (i) => CheckboxListTile(
                      focusNode: i == 0 ? firstDayFocus : null,
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
                  subtitle: const Text('Esta versión no envía avisos al móvil'),
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
  static const nameError = 'Escribe un nombre para la rutina.';
  static const activitiesError = 'Elige al menos una actividad para la rutina.';
  final form = GlobalKey<FormState>();
  final nameKey = GlobalKey();
  final activitiesKey = GlobalKey();
  final nameFocus = FocusNode();
  final firstActivityFocus = FocusNode();
  late TextEditingController name;
  late Set<int> ids;
  bool submitted = false;
  String? get idsError => submitted && ids.isEmpty ? activitiesError : null;
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.routine?.name);
    ids = {...?widget.routine?.ids};
  }

  @override
  void dispose() {
    name.dispose();
    nameFocus.dispose();
    firstActivityFocus.dispose();
    super.dispose();
  }

  void save() {
    setState(() => submitted = true);
    final nameOk = form.currentState!.validate(); // anuncia el error de texto
    final idsOk = idsError == null;
    if (!nameOk || !idsOk) {
      revealError(
        context,
        nameOk ? firstActivityFocus : nameFocus,
        nameOk ? activitiesKey : nameKey,
      );
      if (nameOk) announce(context, activitiesError);
      return;
    }
    Navigator.pop(context, Routine(name.text.trim(), ids));
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
                  key: nameKey,
                  controller: name,
                  focusNode: nameFocus,
                  label: 'Nombre de la rutina',
                  isRequired: true,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? nameError : null,
                ),
                Semantics(
                  key: activitiesKey,
                  header: true,
                  // Android (Flutter 3.50) solo marca encabezado si hay headingLevel.
                  headingLevel: 2,
                  child: const Text(
                    'Selecciona actividades existentes (obligatorio)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
                // El error va junto a la lista afectada, no al final del formulario.
                if (idsError != null) FieldError(idsError!),
                if (widget.activities.isEmpty)
                  const Text(
                    'Crea primero una actividad desde Mis actividades.',
                  ),
                for (final (i, a) in widget.activities.indexed)
                  CheckboxListTile(
                    focusNode: i == 0 ? firstActivityFocus : null,
                    contentPadding: EdgeInsets.zero,
                    title: Text(a.name),
                    subtitle: Text('${a.hour} · ${a.frequency}'),
                    value: ids.contains(a.id),
                    onChanged: (v) =>
                        setState(() => v! ? ids.add(a.id) : ids.remove(a.id)),
                  ),
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    plural(
                      ids.length,
                      'actividad seleccionada',
                      'actividades seleccionadas',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
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

/// Mueve el foco al primer control con error y desplaza la vista hasta su
/// bloque (etiqueta incluida) para que el error se vea junto al campo (3.3.1).
void revealError(BuildContext context, FocusNode focus, GlobalKey target) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    focus.requestFocus();
    final ctx = target.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  });
}
