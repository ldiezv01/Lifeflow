import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/main.dart';
import 'package:lifeflow/widgets/flow_widgets.dart';
import 'package:lifeflow/screens/activity_detail.dart';
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
      expect(find.text('Elige al menos un día de la semana.'), findsOneWidget);
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
      expect(
        find.text('Elige al menos una actividad para la rutina.'),
        findsOneWidget,
      );
      await tap(t, 'Caminar 20 minutos');
      expect(find.text('1 actividad seleccionada'), findsOneWidget);
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
      await tap(t, 'Día anterior');
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
      expect(find.text('1 actividad seleccionada'), findsOneWidget);
      await t.pumpWidget(const SizedBox());
    },
  );

  group('I1 foco visible del botón principal', () {
    double contrast(Color a, Color b) {
      final l1 = a.computeLuminance(), l2 = b.computeLuminance();
      final hi = l1 > l2 ? l1 : l2, lo = l1 > l2 ? l2 : l1;
      return (hi + .05) / (lo + .05);
    }

    for (final kind in ButtonKind.values) {
      testWidgets('el anillo aparece al dar foco con el teclado ($kind)', (
        t,
      ) async {
        final node = FocusNode();
        addTearDown(node.dispose);
        await t.pumpWidget(
          harness(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: PrimaryButton(
                  'Guardar',
                  kind: kind,
                  focusNode: node,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );
        final button = find.byType(PrimaryButton);
        final before = t.getSize(button);
        expect(find.byKey(PrimaryButton.focusRingKey), findsNothing);
        // Tab desde fuera de cualquier botón: lo alcanza solo el teclado.
        await t.sendKeyEvent(LogicalKeyboardKey.tab);
        await t.pumpAndSettle();
        expect(node.hasFocus, isTrue);
        expect(find.byKey(PrimaryButton.focusRingKey), findsOneWidget);
        // El anillo va dentro de los límites: ni el tamaño ni el objetivo
        // táctil cambian.
        expect(t.getSize(button), before);
        expect(before.height, greaterThanOrEqualTo(48));
        // El anillo tiene al menos 3 dp: el exterior mide 3 y el interior 2.
        final ring = t.widget<DecoratedBox>(
          find.byKey(PrimaryButton.focusRingKey),
        );
        final border = (ring.decoration as BoxDecoration).border! as Border;
        expect(border.top.width, greaterThanOrEqualTo(3));
        // Quitar el foco lo oculta.
        node.unfocus();
        await t.pumpAndSettle();
        expect(find.byKey(PrimaryButton.focusRingKey), findsNothing);
      });
    }

    test('contraste del anillo: >= 3:1 frente al fondo y frente al degradado', () {
      // Anillo exterior (azul oscuro) frente al fondo de página y a la tarjeta.
      expect(
        contrast(FlowTheme.ink, FlowTheme.background),
        greaterThanOrEqualTo(3),
      );
      expect(contrast(FlowTheme.ink, Colors.white), greaterThanOrEqualTo(3));
      // Anillo interior (blanco) frente a cada color del degradado.
      for (final c in [...FlowTheme.gradient.colors, const Color(0xFF007F8A)]) {
        expect(
          contrast(Colors.white, c),
          greaterThanOrEqualTo(3),
          reason: '$c',
        );
      }
    });
  });

  group('U5 foco tras Completar / Deshacer', () {
    testWidgets('el foco pasa a Deshacer y vuelve a Completar', (t) async {
      final a = Activity(
        id: 1,
        name: 'Caminar',
        time: const TimeOfDay(hour: 9, minute: 30),
        date: DateTime(2026, 11, 19),
      );
      final day = DateTime(2026, 11, 19);
      await t.pumpWidget(
        harness(
          home: ActivityDetail(
            activity: a,
            date: day,
            onToggle: () => a.toggle(day),
            onEdit: () async => false,
          ),
        ),
      );
      await t.pumpAndSettle();
      final button = find.byType(PrimaryButton);
      FocusNode nodeOf() => t.widget<PrimaryButton>(button).focusNode!;
      expect(
        find.descendant(of: button, matching: find.text('Completar')),
        findsOneWidget,
      );
      await t.ensureVisible(button);
      await t.tap(find.text('Completar'));
      await t.pumpAndSettle();
      expect(
        find.descendant(of: button, matching: find.text('Deshacer')),
        findsOneWidget,
      );
      expect(nodeOf().hasPrimaryFocus, isTrue);
      await t.tap(find.text('Deshacer'));
      await t.pumpAndSettle();
      expect(
        find.descendant(of: button, matching: find.text('Completar')),
        findsOneWidget,
      );
      expect(nodeOf().hasPrimaryFocus, isTrue);
    });
  });

  group('U6 rutina en el detalle', () {
    Future<void> openDetail(WidgetTester t, double scale) async {
      t.view.physicalSize = const Size(430, 932);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(harness(scale: scale));
      await t.pumpAndSettle();
      await tap(t, 'Ver detalle', activity: 'Tomar la medicación');
    }

    for (final scale in [1.0, 2.0]) {
      testWidgets('el detalle muestra la rutina a escala $scale', (t) async {
        final semantics = t.ensureSemantics();
        await openDetail(t, scale);
        expect(find.text('Detalle de actividad'), findsOneWidget);
        final line = find.text('Rutina: Rutina Mañana');
        expect(line, findsOneWidget);
        await t.ensureVisible(line);
        await t.pumpAndSettle();
        expect(t.takeException(), isNull);
        expect(find.bySemanticsLabel('Rutina: Rutina Mañana'), findsOneWidget);
        // Sin recorte: el texto cabe en el ancho de la pantalla.
        expect(t.getRect(line).right, lessThanOrEqualTo(430));
        semantics.dispose();
      });
    }

    testWidgets('una actividad sin rutina no muestra la línea', (t) async {
      final semantics = t.ensureSemantics();
      await openDetail(t, 1);
      await tap(t, 'Volver');
      await tap(t, 'Ver detalle', activity: 'Comida');
      expect(find.text('Detalle de actividad'), findsOneWidget);
      expect(find.textContaining('Rutina:'), findsNothing);
      semantics.dispose();
    });
  });

  group('A01 guía de contraste de texto de Flutter', () {
    Future<void> setUp(WidgetTester t) async {
      t.view.physicalSize = const Size(430, 932);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      final font = FontLoader('LifeFlow')
        ..addFont(rootBundle.load('assets/fonts/roboto-regular.ttf'))
        ..addFont(rootBundle.load('assets/fonts/roboto-bold.ttf'));
      await t.runAsync(() => font.load());
    }

    testWidgets('Hoy', (t) async {
      await setUp(t);
      final semantics = t.ensureSemantics();
      await t.pumpWidget(harness());
      await t.pumpAndSettle();
      await expectLater(t, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });

    testWidgets('Nueva actividad, sin y con el error visible', (t) async {
      await setUp(t);
      final semantics = t.ensureSemantics();
      await t.pumpWidget(harness());
      await t.pumpAndSettle();
      await tap(t, 'Nueva actividad');
      await expectLater(t, meetsGuideline(textContrastGuideline));
      await tap(t, 'Días concretos');
      await tap(t, 'Guardar');
      expect(find.text('Elige al menos un día de la semana.'), findsOneWidget);
      await expectLater(t, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });

    testWidgets('Detalle', (t) async {
      await setUp(t);
      final semantics = t.ensureSemantics();
      await t.pumpWidget(harness());
      await t.pumpAndSettle();
      await tap(t, 'Ver detalle', activity: 'Tomar la medicación');
      expect(find.text('Detalle de actividad'), findsOneWidget);
      await expectLater(t, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  });
}
