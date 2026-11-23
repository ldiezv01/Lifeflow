import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/local_store.dart';
import 'models/activity.dart';
import 'theme/flow_theme.dart';
import 'widgets/flow_widgets.dart';
import 'screens/forms.dart';
import 'screens/activity_detail.dart';

/// Carga los datos guardados antes del primer fotograma: no se ven los de
/// ejemplo y luego otros.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LifeFlowApp(saved: await LocalStore.load(), persist: true));
}

class LifeFlowApp extends StatelessWidget {
  const LifeFlowApp({super.key, this.saved, this.persist = false});

  /// Datos cargados del almacenamiento; null usa los de ejemplo.
  final LifeFlowData? saved;

  /// Si guarda cada cambio de datos (falso en tests que no lo necesitan).
  final bool persist;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'LifeFlow',
    debugShowCheckedModeBanner: false,
    theme: FlowTheme.data,
    locale: const Locale('es'),
    supportedLocales: const [Locale('es')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: HomeScreen(saved: saved, persist: persist),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.now, this.saved, this.persist = false});
  final DateTime Function()? now;
  final LifeFlowData? saved;
  final bool persist;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int index = 0;
  late DateTime day;
  late DateTime today;
  Timer? midnight;
  DateTime get clock => (widget.now ?? DateTime.now)();
  DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  void refreshDay() {
    final next = dateOnly(clock);
    if (next != today) {
      setState(() {
        if (day == today) day = next;
        today = next;
      });
    }
    scheduleMidnight();
  }

  void scheduleMidnight() {
    midnight?.cancel();
    final current = clock;
    final next = DateTime(current.year, current.month, current.day + 1);
    midnight = Timer(next.difference(current), refreshDay);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refreshDay();
  }

  @override
  void dispose() {
    midnight?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late List<Activity> activities;
  late List<Routine> routines;
  @override
  void initState() {
    super.initState();
    today = dateOnly(clock);
    day = today;
    WidgetsBinding.instance.addObserver(this);
    scheduleMidnight();
    final saved = widget.saved;
    if (saved != null) {
      activities = saved.activities;
      routines = saved.routines;
      return;
    }
    activities = [
      Activity(
        id: 1,
        name: 'Tomar la medicación',
        time: const TimeOfDay(hour: 8, minute: 0),
        date: today,
        icon: Icons.medication_outlined,
      ),
      Activity(
        id: 2,
        name: 'Caminar 20 minutos',
        time: const TimeOfDay(hour: 9, minute: 30),
        date: today,
        icon: Icons.directions_walk_rounded,
      ),
      Activity(
        id: 3,
        name: 'Comida',
        time: const TimeOfDay(hour: 14, minute: 30),
        date: today,
        frequency: 'Una sola vez',
        icon: Icons.restaurant_rounded,
      ),
    ];
    activities.first.toggle(today);
    routines = [
      Routine('Rutina Mañana', {1, 2}),
    ];
  }

  /// Guarda tras cada cambio de datos sin esperar: la UI no se bloquea y un
  /// fallo de guardado solo se registra (RNF-R01).
  void save() {
    if (widget.persist) unawaited(LocalStore.save(activities, routines));
  }

  void toggle(Activity a, DateTime d) {
    setState(() => a.toggle(d));
    save();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          // Tiempo suficiente para leer y usar «Deshacer» (2.2.1).
          duration: const Duration(seconds: 10),
          content: Text(
            '${a.name}: ${a.completed(d) ? 'Completada' : 'Pendiente'}',
          ),
          action: SnackBarAction(
            label: a.completed(d) ? 'Deshacer' : 'Completar',
            onPressed: () => toggle(a, d),
          ),
        ),
      );
  }

  /// Confirmación visible; el SnackBar es región viva y el lector la anuncia.
  void confirm(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Estado de la Agenda: fecha elegida y número de actividades.
  String agendaStatus(DateTime d) {
    final count = activities.where((a) => a.occurs(d)).length;
    return '${dateLabel(d)}: ${plural(count, 'actividad', 'actividades')} este día';
  }

  /// Cambia el día de la Agenda y anuncia una vez la fecha y cuántas
  /// actividades tiene, porque el cambio ocurre lejos del botón (4.1.3).
  void changeDay(int delta) {
    setState(() => day = DateTime(day.year, day.month, day.day + delta));
    announce(context, agendaStatus(day));
  }

  /// Devuelve si se guardó; la confirmación la muestra el detalle en su
  /// cabecera (un SnackBar taparía «Volver» con texto grande).
  Future<bool> edit(Activity a) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final result = await Navigator.push<Activity>(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityForm(activity: a, date: day),
      ),
    );
    if (result != null && mounted) {
      setState(() {});
      save();
    }
    return result != null;
  }

  Future<void> detail(Activity a, DateTime d, {bool saved = false}) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityDetail(
          activity: a,
          date: d,
          saved: saved,
          routine: routineOf(a),
          onToggle: () => toggle(a, d),
          onEdit: () => edit(a),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> create() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final result = await Navigator.push<Activity>(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityForm(date: index == 1 ? day : today),
      ),
    );
    if (result != null && mounted) {
      setState(() => activities.add(result));
      save();
      await detail(result, index == 1 ? day : today, saved: true);
    }
  }

  Future<void> routine([Routine? r]) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final result = await Navigator.push<Routine>(
      context,
      MaterialPageRoute(
        builder: (_) => RoutineForm(activities: activities, routine: r),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        if (r == null) {
          routines.add(result);
        } else {
          r.name = result.name;
          r.ids = result.ids;
        }
      });
      save();
      confirm(
        '${r == null ? 'Rutina creada' : 'Rutina guardada'}: ${result.name}',
      );
    }
  }

  Widget card(Activity a, DateTime d) => ActivityCard(
    activity: a,
    date: d,
    onToggle: () => toggle(a, d),
    onDetail: () => detail(a, d),
    routine: routineOf(a),
  );

  /// Rutina de la actividad (la primera que la incluye), o null.
  String? routineOf(Activity a) => routines
      .where((r) => r.ids.contains(a.id))
      .map((r) => r.name)
      .firstOrNull;

  /// Encabezado de sección. Con [status], ese es su nombre accesible y, donde
  /// el sistema no admite anuncios, es liveRegion (mismo texto que [announce]).
  Widget heading(String text, {String? status}) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 20),
    child: Semantics(
      container: status != null,
      header: true,
      // Android (Flutter 3.50) solo marca encabezado si hay headingLevel.
      headingLevel: 2,
      liveRegion: status != null && !MediaQuery.supportsAnnounceOf(context),
      label: status,
      excludeSemantics: status != null,
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final titles = ['Hoy', 'Agenda', 'Mis actividades', 'Mis rutinas'];
    final d = index == 1 ? day : today;
    final sorted = [...activities]
      ..sort(
        (a, b) => (a.time.hour * 60 + a.time.minute).compareTo(
          b.time.hour * 60 + b.time.minute,
        ),
      );
    final visible = sorted.where((a) => a.occurs(d)).toList();
    return Scaffold(
      bottomNavigationBar: FlowNavigation(
        index: index,
        onChanged: (v) => setState(() => index = v),
      ),
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
              key: PageStorageKey(index),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FlowHeader(
                    titles[index],
                    index < 2 ? dateLabel(d) : 'Organiza tu día a tu ritmo',
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (index == 1) ...[
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => changeDay(-1),
                                icon: const Icon(Icons.chevron_left),
                                label: const Text('Día anterior'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => changeDay(1),
                                icon: const Icon(Icons.chevron_right),
                                label: const Text('Día siguiente'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                        if (index < 2) ...[
                          heading(
                            '${plural(visible.length, 'actividad', 'actividades')} ${index == 0 ? 'hoy' : 'este día'}',
                            status: index == 1 ? agendaStatus(d) : null,
                          ),
                          if (visible.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.event_available,
                                    size: 56,
                                    color: FlowTheme.teal,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No hay actividades para este día.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Puedes añadir una nueva actividad para organizarlo.',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ...visible.map((a) => card(a, d)),
                          const SizedBox(height: 8),
                          PrimaryButton('Nueva actividad', onPressed: create),
                        ],
                        if (index == 2) ...[
                          heading('Recurrentes'),
                          ...sorted
                              .where((a) => a.frequency != 'Una sola vez')
                              .map((a) => card(a, today)),
                          heading('Puntuales'),
                          ...sorted
                              .where((a) => a.frequency == 'Una sola vez')
                              .map((a) => card(a, a.date)),
                          PrimaryButton('Nueva actividad', onPressed: create),
                        ],
                        if (index == 3) ...[
                          heading(
                            '${plural(routines.length, 'rutina', 'rutinas')} para tu día',
                          ),
                          ...routines.map(
                            (r) => Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x15245599),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      Icons.layers_outlined,
                                      size: 40,
                                      color: FlowTheme.purple,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    r.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  ...sorted
                                      .where((a) => r.ids.contains(a.id))
                                      .map(
                                        (a) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: Text('${a.hour} · ${a.name}'),
                                        ),
                                      ),
                                  OutlinedButton(
                                    onPressed: () => routine(r),
                                    child: const Text('Editar rutina'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PrimaryButton(
                            'Nueva rutina',
                            onPressed: () => routine(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
