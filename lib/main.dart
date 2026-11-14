import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/activity.dart';
import 'theme/flow_theme.dart';
import 'widgets/flow_widgets.dart';
import 'screens/forms.dart';
import 'screens/activity_detail.dart';

void main() => runApp(const LifeFlowApp());

class LifeFlowApp extends StatelessWidget {
  const LifeFlowApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'LifeFlow',
    debugShowCheckedModeBanner: false,
    theme: FlowTheme.data,
    locale: const Locale('es'),
    supportedLocales: const [Locale('es')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.now});
  final DateTime Function()? now;
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

  void toggle(Activity a, DateTime d) {
    setState(() => a.toggle(d));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
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

  Future<void> edit(Activity a) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final result = await Navigator.push<Activity>(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityForm(activity: a, date: day),
      ),
    );
    if (result != null && mounted) setState(() {});
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
    }
  }

  Widget card(Activity a, DateTime d) => ActivityCard(
    activity: a,
    date: d,
    onToggle: () => toggle(a, d),
    onDetail: () => detail(a, d),
    routine: routines
        .where((r) => r.ids.contains(a.id))
        .map((r) => r.name)
        .firstOrNull,
  );
  Widget heading(String text) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 20),
    child: Semantics(
      header: true,
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
                                onPressed: () => setState(
                                  () => day = DateTime(
                                    day.year,
                                    day.month,
                                    day.day - 1,
                                  ),
                                ),
                                icon: const Icon(Icons.chevron_left),
                                label: const Text('Anterior'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => setState(
                                  () => day = DateTime(
                                    day.year,
                                    day.month,
                                    day.day + 1,
                                  ),
                                ),
                                icon: const Icon(Icons.chevron_right),
                                label: const Text('Siguiente'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                        if (index < 2) ...[
                          heading(
                            '${visible.length} actividades ${index == 0 ? 'hoy' : 'este día'}',
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
                          heading('${routines.length} rutinas para tu día'),
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
