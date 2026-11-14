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
    this.icon = Icons.event_note_rounded,
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
}

class Routine {
  Routine(this.name, this.ids);
  String name;
  Set<int> ids;
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
