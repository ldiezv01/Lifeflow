import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.dart';

/// Datos de la app que se conservan entre ejecuciones (RNF-R01).
typedef LifeFlowData = ({List<Activity> activities, List<Routine> routines});

/// Persistencia local mínima: todo el estado en un JSON bajo una sola clave.
class LocalStore {
  /// Clave versionada: si cambia el formato, se cambia la clave.
  static const key = 'lifeflow_state_v1';

  /// Devuelve null si no hay nada guardado o el JSON no es válido; entonces la
  /// app arranca con los datos de ejemplo.
  static Future<LifeFlowData?> load() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(key);
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, Object?>;
      return (
        activities: [
          for (final a in json['activities'] as List)
            Activity.fromJson(a as Map<String, Object?>),
        ],
        routines: [
          for (final r in json['routines'] as List)
            Routine.fromJson(r as Map<String, Object?>),
        ],
      );
    } catch (e) {
      debugPrint('LocalStore: no se pudieron cargar los datos: $e');
      return null;
    }
  }

  /// Guarda una foto del estado actual. No lanza: un fallo se registra y la app
  /// sigue funcionando con los datos en memoria.
  static Future<void> save(
    List<Activity> activities,
    List<Routine> routines,
  ) async {
    try {
      // Se serializa antes de la primera espera: se guarda este estado exacto.
      final raw = jsonEncode({
        'activities': [for (final a in activities) a.toJson()],
        'routines': [for (final r in routines) r.toJson()],
      });
      await (await SharedPreferences.getInstance()).setString(key, raw);
    } catch (e) {
      debugPrint('LocalStore: no se pudieron guardar los datos: $e');
    }
  }
}
