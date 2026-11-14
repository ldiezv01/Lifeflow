import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/main.dart';
import 'package:lifeflow/widgets/flow_widgets.dart';
import 'package:lifeflow/screens/forms.dart';
import 'package:lifeflow/theme/flow_theme.dart';
import 'package:lifeflow/models/activity.dart';

Future<void> tap(WidgetTester t, String label, {String? activity}) async {
  await t.pumpAndSettle();
  final f = activity == null
      ? find.text(label).first
      : find
            .descendant(
              of: find.widgetWithText(ActivityCard, activity),
              matching: find.text(label),
            )
            .first;
  await t.ensureVisible(f);
  await t.pumpAndSettle();
  await t.tap(f);
  await t.pumpAndSettle();
  expect(t.takeException(), isNull);
  await expectLater(t, meetsGuideline(androidTapTargetGuideline));
  await expectLater(t, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(t, meetsGuideline(labeledTapTargetGuideline));
}

Widget harness({Widget? home, double scale = 1}) => MaterialApp(
  theme: FlowTheme.data,
  locale: const Locale('es'),
  supportedLocales: const [Locale('es')],
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  builder: (c, w) => MediaQuery(
    data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
    child: w!,
  ),
  home: home ?? const HomeScreen(),
);
void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('R1 R2 R3 and touch targets at ${scale * 100} percent', (
      t,
    ) async {
      t.view.physicalSize = const Size(430, 932);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      final semantics = t.ensureSemantics();
      await t.pumpWidget(harness(scale: scale));
      await t.pumpAndSettle();
      await expectLater(t, meetsGuideline(androidTapTargetGuideline));
      await expectLater(t, meetsGuideline(labeledTapTargetGuideline));
      await tap(t, 'Completar', activity: 'Caminar 20 minutos');
      var card = t.widget<ActivityCard>(
        find.widgetWithText(ActivityCard, 'Caminar 20 minutos'),
      );
      expect(card.activity.completed(card.date), isTrue);
      expect(find.text('Completada'), findsWidgets);
      await tap(t, 'Deshacer', activity: 'Caminar 20 minutos');
      card = t.widget<ActivityCard>(
        find.widgetWithText(ActivityCard, 'Caminar 20 minutos'),
      );
      expect(card.activity.completed(card.date), isFalse);
      await tap(t, 'Ver detalle');
      expect(find.text('Detalle de actividad'), findsOneWidget);
      await tap(t, 'Volver');
      await tap(t, 'Nueva actividad');
      await t.enterText(find.byType(TextFormField).first, 'Paseo accesible');
      await tap(t, 'Días concretos');
      await tap(t, 'Guardar');
      expect(
        find.textContaining('Selecciona al menos un día.'),
        findsOneWidget,
      );
      expect(find.text('Paseo accesible'), findsOneWidget);
      await tap(t, 'Lunes');
      await expectLater(t, meetsGuideline(androidTapTargetGuideline));
      await tap(t, 'Guardar');
      expect(find.text('Actividad guardada'), findsOneWidget);
      await tap(t, 'Volver');
      await tap(t, 'Mis actividades');
      await tap(t, 'Ver detalle');
      await tap(t, 'Volver');
      expect(find.text('Mis actividades'), findsWidgets);
      await tap(t, 'Agenda');
      await tap(t, 'Ver detalle');
      await tap(t, 'Volver');
      expect(find.text('Agenda'), findsWidgets);
      await tap(t, 'Mis rutinas');
      await tap(t, 'Nueva rutina');
      await t.enterText(find.byType(TextFormField).first, 'Mi rutina');
      await tap(t, 'Guardar');
      expect(find.textContaining('selecciona al menos'), findsOneWidget);
      await tap(t, 'Caminar 20 minutos');
      expect(find.text('1 actividades seleccionadas'), findsOneWidget);
      await tap(t, 'Guardar');
      expect(find.text('Mi rutina'), findsOneWidget);
      semantics.dispose();
      await t.pumpWidget(const SizedBox());
      await t.pumpAndSettle();
    });
  }
  testWidgets(
    'Today rolls over at midnight and on resume; Agenda retains chosen date',
    (t) async {
      var clock = DateTime(2026, 11, 14, 23, 59, 59);
      await t.pumpWidget(harness(home: HomeScreen(now: () => clock)));
      await t.pumpAndSettle();
      expect(find.text('3 actividades hoy'), findsOneWidget);
      clock = DateTime(2026, 11, 15);
      await t.pump(const Duration(seconds: 1));
      await t.pumpAndSettle();
      expect(find.text('2 actividades hoy'), findsOneWidget);
      expect(find.text(dateLabel(clock)), findsOneWidget);
      await tap(t, 'Agenda');
      await tap(t, 'Anterior');
      clock = DateTime(2026, 11, 16, 8);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await t.pumpAndSettle();
      expect(find.text(dateLabel(DateTime(2026, 11, 14))), findsOneWidget);
      await tap(t, 'Hoy');
      expect(find.text(dateLabel(clock)), findsOneWidget);
      await t.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'Edit cancel preserves original; one-off fields and routine edit',
    (t) async {
      final a = Activity(
        id: 1,
        name: 'Original',
        time: const TimeOfDay(hour: 8, minute: 0),
        date: DateTime(2026, 11, 14),
      );
      await t.pumpWidget(
        harness(
          home: ActivityForm(activity: a, date: a.date),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Original'), findsOneWidget);
      await tap(t, 'Una sola vez');
      expect(find.textContaining('Fecha:'), findsOneWidget);
      await t.enterText(find.byType(TextFormField), 'Cambio sin guardar');
      expect(a.name, 'Original');
      await t.pumpWidget(
        harness(
          home: RoutineForm(
            activities: [a],
            routine: Routine('Rutina existente', {1}),
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('Rutina existente'), findsOneWidget);
      expect(find.text('1 actividades seleccionadas'), findsOneWidget);
      await t.pumpWidget(const SizedBox());
    },
  );
}
