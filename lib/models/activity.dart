import 'package:flutter/material.dart';

class Activity {
  Activity({
    required this.id,
    required this.name,
    required this.time,
    this.frequency = 'Diariamente',
    this.days = const [],
    required this.date,
    this.reminder = false,
    this.icon = defaultActivityIcon,
  });
  final int id;
  String name;
  TimeOfDay time;
  String frequency;
  List<int> days;
  DateTime date;
  bool reminder;
  IconData icon;
  final Set<String> completedDates = {};
  String key(DateTime d) => '${d.year}-${d.month}-${d.day}';
  bool completed(DateTime d) => completedDates.contains(key(d));
  void toggle(DateTime d) =>
      completed(d) ? completedDates.remove(key(d)) : completedDates.add(key(d));
  bool occurs(DateTime d) =>
      frequency == 'Diariamente' ||
      (frequency == 'Días concretos'
          ? days.contains(d.weekday)
          : key(date) == key(d));
  String get hour =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  /// El icono se guarda por clave de texto, no por codePoint, para no romper
  /// el tree-shaking de iconos en release.
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'hour': time.hour,
    'minute': time.minute,
    'frequency': frequency,
    'days': days,
    'date': date.toIso8601String(),
    'reminder': reminder,
    'icon': iconKey(icon),
    'completedDates': completedDates.toList(),
  };

  /// Lanza si el JSON no tiene la forma esperada; quien carga decide qué hacer.
  factory Activity.fromJson(Map<String, Object?> json) =>
      Activity(
          id: json['id'] as int,
          name: json['name'] as String,
          time: TimeOfDay(
            hour: json['hour'] as int,
            minute: json['minute'] as int,
          ),
          frequency: json['frequency'] as String,
          days: [for (final d in json['days'] as List) d as int],
          date: DateTime.parse(json['date'] as String),
          reminder: json['reminder'] as bool,
          icon: activityIcons[json['icon']] ?? defaultActivityIcon,
        )
        ..completedDates.addAll([
          for (final d in json['completedDates'] as List) d as String,
        ]);
}

/// Iconos de actividad que la app puede guardar y recuperar.
const defaultActivityIcon = Icons.event_note_rounded;
const activityIcons = <String, IconData>{
  'nota': defaultActivityIcon,
  'medicacion': Icons.medication_outlined,
  'caminar': Icons.directions_walk_rounded,
  'comida': Icons.restaurant_rounded,
};
String iconKey(IconData icon) =>
    activityIcons.entries.where((e) => e.value == icon).firstOrNull?.key ??
    'nota';

class Routine {
  Routine(this.name, this.ids);
  String name;
  Set<int> ids;

  Map<String, Object?> toJson() => {'name': name, 'ids': ids.toList()};

  factory Routine.fromJson(Map<String, Object?> json) => Routine(
    json['name'] as String,
    {for (final id in json['ids'] as List) id as int},
  );
}

String dateLabel(DateTime d) {
  const days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
  const months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  return '${days[d.weekday - 1]}, ${d.day} de ${months[d.month - 1]}';
}

/// Cantidad con el sustantivo en singular o plural: «1 actividad», «3 actividades».
String plural(int n, String singular, String pluralForm) =>
    '$n ${n == 1 ? singular : pluralForm}';
