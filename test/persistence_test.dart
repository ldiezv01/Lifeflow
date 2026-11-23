// Evidencia de RNF-R01: los datos se conservan tras cerrar y reabrir la app.
// Misma deprecación conocida que el resto del proyecto (migración a material_ui).
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/data/local_store.dart';
import 'package:lifeflow/main.dart';
import 'package:lifeflow/widgets/flow_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Arranca la app igual que `main()`: primero carga, luego monta.
Future<void> openApp(WidgetTester t) async {
  final saved = await LocalStore.load();
  await t.pumpWidget(LifeFlowApp(saved: saved, persist: true));
  await t.pumpAndSettle();
}

/// Cierra la app y descarta la caché de SharedPreferences: la siguiente
/// apertura vuelve a leer del almacenamiento, como tras reiniciar.
Future<void> closeApp(WidgetTester t) async {
  await t.pumpWidget(const SizedBox());
  SharedPreferences.resetStatic();
}

Future<void> tapVisible(WidgetTester t, Finder f) async {
  await t.ensureVisible(f);
  await t.pumpAndSettle();
  await t.tap(f);
  await t.pumpAndSettle();
}

/// Texto dentro de la tarjeta de una actividad concreta.
Finder inCard(String activity, String text) => find.descendant(
  of: find.widgetWithText(ActivityCard, activity),
  matching: find.text(text),
);

void main() {
  setUp(() {
    SharedPreferences.resetStatic();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('RNF-R01: guardar, reiniciar y cotejar', (t) async {
    t.view.physicalSize = const Size(430, 932);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);

    // (a) Primera ejecución: sin datos guardados, datos de ejemplo.
    await openApp(t);
    expect(find.text('Caminar 20 minutos'), findsOneWidget);

    // Crear «Clase de yoga» (puntual, 09:00) desde el formulario.
    await tapVisible(t, find.text('Nueva actividad').first);
    await t.enterText(find.byType(TextFormField).first, 'Clase de yoga');
    await tapVisible(t, find.text('Una sola vez'));
    await tapVisible(t, find.text('Guardar'));
    expect(find.text('Actividad guardada'), findsOneWidget);
    await tapVisible(t, find.text('Volver'));

    // Completar otra actividad.
    await tapVisible(t, inCard('Caminar 20 minutos', 'Completar'));
    expect(inCard('Caminar 20 minutos', 'Completada'), findsOneWidget);

    // El estado ya está en el almacenamiento bajo la clave versionada.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(LocalStore.key), contains('Clase de yoga'));

    // (b) Reiniciar: se desmonta todo y se abre una app nueva.
    await closeApp(t);
    expect(find.text('Clase de yoga'), findsNothing);
    await openApp(t);

    // (c) La actividad creada sigue, con su hora y su frecuencia...
    await tapVisible(t, find.text('Mis actividades').last);
    expect(inCard('Clase de yoga', '09:00'), findsOneWidget);
    expect(inCard('Clase de yoga', 'Una sola vez'), findsOneWidget);
    // ...y la otra sigue completada.
    expect(inCard('Caminar 20 minutos', 'Completada'), findsOneWidget);
    expect(inCard('Caminar 20 minutos', 'Deshacer'), findsOneWidget);

    await closeApp(t);
  });

  for (final corrupt in ['{esto no es JSON', '{"activities": 3}']) {
    testWidgets('JSON corrupto ($corrupt): datos de ejemplo', (t) async {
      SharedPreferences.setMockInitialValues({LocalStore.key: corrupt});
      await openApp(t);
      expect(t.takeException(), isNull);
      expect(find.text('Tomar la medicación'), findsOneWidget);
      expect(find.text('Caminar 20 minutos'), findsOneWidget);
      await closeApp(t);
    });
  }
}
