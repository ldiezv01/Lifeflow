// Misma deprecación conocida que el resto del proyecto (migración a material_ui).
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/main.dart';
import 'package:lifeflow/models/activity.dart';
import 'package:lifeflow/screens/forms.dart';
import 'package:lifeflow/theme/flow_theme.dart';
import 'package:lifeflow/widgets/flow_widgets.dart';

/// Jueves 19 de noviembre de 2026: «Comida» es puntual de hoy.
DateTime clock() => DateTime(2026, 11, 19, 10);

Widget harness({
  Widget? home,
  double scale = 1,
  bool supportsAnnounce = true,
}) => MaterialApp(
  theme: FlowTheme.data,
  locale: const Locale('es'),
  supportedLocales: const [Locale('es')],
  // ignore: deprecated_member_use
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  builder: (c, w) => MediaQuery(
    data: MediaQuery.of(c).copyWith(
      textScaler: TextScaler.linear(scale),
      supportsAnnounce: supportsAnnounce,
    ),
    child: w!,
  ),
  home: home ?? HomeScreen(now: clock),
);

void setView(WidgetTester t, Size size) {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

Future<void> tapVisible(WidgetTester t, Finder f) async {
  await t.ensureVisible(f);
  await t.pumpAndSettle();
  await t.tap(f);
  await t.pumpAndSettle();
}

/// Carga Roboto (familia del tema) para medir con métricas reales.
Future<void> loadFonts(WidgetTester t) async {
  final font = FontLoader('LifeFlow')
    ..addFont(rootBundle.load('assets/fonts/roboto-regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/roboto-bold.ttf'));
  await t.runAsync(() => font.load());
}

void main() {
  group('I7 navegación inferior sin palabras partidas', () {
    for (final width in [320.0, 360.0, 402.0, 430.0]) {
      for (final scale in [1.0, 1.3, 2.0]) {
        testWidgets('$width dp al ${(scale * 100).round()} %', (t) async {
          setView(t, Size(width, 900));
          await loadFonts(t);
          await t.pumpWidget(
            harness(
              scale: scale,
              home: Scaffold(
                bottomNavigationBar: FlowNavigation(
                  index: 2,
                  onChanged: (_) {},
                ),
              ),
            ),
          );
          await t.pumpAndSettle();
          expect(t.takeException(), isNull);
          for (final label in FlowNavigation.labels) {
            final p = t.renderObject<RenderParagraph>(find.text(label));
            final style = (p.text as TextSpan).style;
            var start = 0;
            for (final word in label.split(' ')) {
              // 1) La palabra cabe en el ancho del párrafo que la pinta.
              final painter = TextPainter(
                text: TextSpan(text: word, style: style),
                textDirection: TextDirection.ltr,
                textScaler: p.textScaler,
              )..layout();
              expect(
                painter.width,
                lessThanOrEqualTo(p.constraints.maxWidth),
                reason: '«$word» de «$label» no cabe en $width dp × $scale',
              );
              painter.dispose();
              // 2) Y de hecho se pinta en una sola línea (sin corte interno).
              final boxes = p.getBoxesForSelection(
                TextSelection(
                  baseOffset: start,
                  extentOffset: start + word.length,
                ),
              );
              expect(
                boxes.map((b) => b.top).toSet(),
                hasLength(1),
                reason: '«$word» se parte en $width dp × $scale',
              );
              start += word.length + 1;
            }
          }
        });
      }
    }
  });

  testWidgets('B1 Frecuencia: opciones excluyentes con estado marcado', (
    t,
  ) async {
    setView(t, const Size(430, 932));
    final semantics = t.ensureSemantics();
    await t.pumpWidget(harness(home: ActivityForm(date: clock())));
    await t.pumpAndSettle();
    const options = ['Diariamente', 'Días concretos', 'Una sola vez'];
    void expectChecked(String chosen) {
      for (final f in options) {
        final node = t.getSemantics(find.text(f));
        expect(
          node,
          isSemantics(
            label: f,
            isButton: true,
            hasTapAction: true,
            isInMutuallyExclusiveGroup: true,
            hasCheckedState: true,
            isChecked: f == chosen,
          ),
        );
        expect(node.parent!.getSemanticsData().role, SemanticsRole.radioGroup);
      }
    }

    expect(
      t.getSemantics(find.text('Frecuencia')),
      isSemantics(label: 'Frecuencia', isHeader: true),
    );
    expectChecked('Diariamente');
    await tapVisible(t, find.text('Días concretos'));
    expectChecked('Días concretos');
    await tapVisible(t, find.text('Una sola vez'));
    expectChecked('Una sola vez');
    semantics.dispose();
  });

  testWidgets('I2 botones de tarjeta nombran la actividad', (t) async {
    setView(t, const Size(430, 932));
    final semantics = t.ensureSemantics();
    await t.pumpWidget(harness());
    await t.pumpAndSettle();
    expect(
      t.getSemantics(find.bySemanticsLabel('Completar: Caminar 20 minutos')),
      isSemantics(
        label: 'Completar: Caminar 20 minutos',
        isButton: true,
        hasTapAction: true,
      ),
    );
    expect(
      t.getSemantics(find.bySemanticsLabel('Ver detalle: Caminar 20 minutos')),
      isSemantics(label: 'Ver detalle: Caminar 20 minutos', isButton: true),
    );
    expect(
      find.bySemanticsLabel('Deshacer: Tomar la medicación'),
      findsOneWidget,
    );
    // Ningún botón queda con el nombre genérico repetido.
    expect(find.bySemanticsLabel('Ver detalle'), findsNothing);
    expect(find.bySemanticsLabel('Completar'), findsNothing);
    semantics.dispose();
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'I4 I6 errores: foco y vista en el primer campo, un anuncio, datos '
      'conservados (${scale * 100} %)',
      (t) async {
        setView(t, const Size(430, 932));
        final semantics = t.ensureSemantics();
        await t.pumpWidget(
          harness(
            scale: scale,
            home: ActivityForm(date: clock()),
          ),
        );
        await t.pumpAndSettle();
        const label = 'Nombre de la actividad (obligatorio)';
        // Un único nombre accesible, asociado al campo de texto.
        expect(find.bySemanticsLabel(label), findsOneWidget);
        expect(
          t.getSemantics(find.byType(TextField)),
          isSemantics(label: label, isTextField: true),
        );

        await tapVisible(t, find.text('Guardar'));
        const nameError = 'Escribe un nombre para la actividad.';
        expect(
          t.getSemantics(find.byType(TextField)),
          isSemantics(label: label, isTextField: true, isFocused: true),
        );
        final viewport = Offset.zero & t.view.physicalSize;
        expect(find.text(nameError), findsOneWidget);
        expect(
          viewport.contains(t.getRect(find.text(nameError)).center),
          isTrue,
        );
        expect(t.takeAnnouncements().map((a) => a.message), [nameError]);

        await t.enterText(find.byType(TextFormField), 'Paseo accesible');
        await t.pumpAndSettle();
        expect(find.text(nameError), findsNothing);
        await tapVisible(t, find.text('Días concretos'));
        await tapVisible(t, find.text('Guardar'));
        const daysError = 'Elige al menos un día de la semana.';
        expect(find.text(daysError), findsOneWidget);
        expect(
          viewport.contains(t.getRect(find.text(daysError)).center),
          isTrue,
        );
        expect(
          t.getSemantics(find.text('Lunes')),
          isSemantics(label: 'Lunes', isFocused: true),
        );
        expect(t.takeAnnouncements().map((a) => a.message), [daysError]);
        expect(find.text('Paseo accesible'), findsOneWidget);
        semantics.dispose();
      },
    );
  }

  testWidgets('I4 rutina: error junto a la lista y foco en ella', (t) async {
    setView(t, const Size(430, 932));
    final semantics = t.ensureSemantics();
    final a = Activity(
      id: 1,
      name: 'Caminar',
      time: const TimeOfDay(hour: 9, minute: 0),
      date: clock(),
    );
    await t.pumpWidget(harness(home: RoutineForm(activities: [a])));
    await t.pumpAndSettle();
    await tapVisible(t, find.text('Guardar'));
    expect(
      t.getSemantics(find.byType(TextField)),
      isSemantics(isTextField: true, isFocused: true),
    );
    expect(t.takeAnnouncements().map((x) => x.message), [
      'Escribe un nombre para la rutina.',
    ]);
    await t.enterText(find.byType(TextFormField), 'Mañana');
    await tapVisible(t, find.text('Guardar'));
    const error = 'Elige al menos una actividad para la rutina.';
    // El error va entre el encabezado de la lista y su primera casilla.
    final heading = t.getRect(find.textContaining('Selecciona actividades'));
    final message = t.getRect(find.text(error));
    final first = t.getRect(find.text('Caminar'));
    expect(heading.bottom, lessThanOrEqualTo(message.top));
    expect(message.bottom, lessThanOrEqualTo(first.top));
    expect(find.bySemanticsLabel('Error: $error'), findsOneWidget);
    expect(t.getSemantics(find.text('Caminar')), isSemantics(isFocused: true));
    expect(t.takeAnnouncements().map((x) => x.message), [error]);
    expect(find.text('Mañana'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('I5 Agenda: «Día siguiente» anuncia fecha y actividades', (
    t,
  ) async {
    setView(t, const Size(430, 932));
    final semantics = t.ensureSemantics();
    await t.pumpWidget(harness());
    await t.pumpAndSettle();
    await tapVisible(t, find.text('Agenda'));
    expect(find.bySemanticsLabel('Día anterior'), findsOneWidget);
    t.takeAnnouncements();
    await tapVisible(t, find.text('Día siguiente'));
    final status =
        '${dateLabel(DateTime(2026, 11, 20))}: 2 actividades este día';
    expect(t.takeAnnouncements().map((a) => a.message), [status]);
    // El encabezado lleva el mismo estado; aquí no es liveRegion (no duplica).
    expect(
      t.getSemantics(find.text('2 actividades este día')),
      allOf(
        isSemantics(label: status, isHeader: true),
        isNot(isSemantics(isLiveRegion: true)),
      ),
    );
    semantics.dispose();
  });

  testWidgets('I5 Agenda sin anuncios del sistema: liveRegion', (t) async {
    setView(t, const Size(430, 932));
    final semantics = t.ensureSemantics();
    await t.pumpWidget(harness(supportsAnnounce: false));
    await t.pumpAndSettle();
    await tapVisible(t, find.text('Agenda'));
    await tapVisible(t, find.text('Día anterior'));
    final status =
        '${dateLabel(DateTime(2026, 11, 18))}: 2 actividades este día';
    expect(t.takeAnnouncements(), isEmpty);
    expect(
      t.getSemantics(find.text('2 actividades este día')),
      isSemantics(label: status, isHeader: true, isLiveRegion: true),
    );
    semantics.dispose();
  });

  testWidgets('I5 confirmaciones y SnackBar de Deshacer ≥ 10 s; M2', (t) async {
    setView(t, const Size(430, 932));
    final semantics = t.ensureSemantics();
    await t.pumpWidget(harness());
    await t.pumpAndSettle();
    // M2: la insignia de estado de la tarjeta no es región viva.
    expect(
      t.getSemantics(find.text('Pendiente').first),
      isNot(isSemantics(isLiveRegion: true)),
    );
    await tapVisible(t, find.bySemanticsLabel('Completar: Caminar 20 minutos'));
    final snack = t.widget<SnackBar>(find.byType(SnackBar));
    expect(snack.duration, greaterThanOrEqualTo(const Duration(seconds: 10)));
    await t.pump(const Duration(seconds: 8));
    expect(find.text('Caminar 20 minutos: Completada'), findsOneWidget);
    await t.pumpAndSettle(const Duration(seconds: 5));

    // Editar desde el detalle: confirmación visible en una región viva.
    await tapVisible(t, find.bySemanticsLabel('Ver detalle: Comida'));
    await tapVisible(t, find.text('Editar actividad'));
    await t.enterText(find.byType(TextFormField), 'Comida familiar');
    await tapVisible(t, find.text('Guardar'));
    expect(
      t.getSemantics(find.text('Cambios guardados')),
      isSemantics(label: 'Cambios guardados', isLiveRegion: true),
    );
    await tapVisible(t, find.text('Volver'));

    // Crear rutina: SnackBar (región viva) con el nombre.
    await tapVisible(t, find.text('Mis rutinas'));
    await tapVisible(t, find.text('Nueva rutina'));
    await t.enterText(find.byType(TextFormField), 'Tarde');
    await tapVisible(t, find.text('Comida familiar'));
    await tapVisible(t, find.text('Guardar'));
    expect(find.text('Rutina creada: Tarde'), findsOneWidget);
    expect(find.text('2 rutinas para tu día'), findsOneWidget);
    semantics.dispose();
  });

  // Encontrado en el emulador (uiautomator): `selected` quedaba en un nodo
  // distinto del botón y Android no decía qué pestaña estaba activa.
  testWidgets(
    'Navegación: la pestaña activa es un único nodo botón seleccionado',
    (t) async {
      setView(t, const Size(430, 932));
      final semantics = t.ensureSemantics();
      await t.pumpWidget(harness());
      await t.pumpAndSettle();
      final hoy = t.getSemantics(find.text('Hoy').last);
      expect(
        hoy,
        isSemantics(
          label: 'Hoy',
          isButton: true,
          hasTapAction: true,
          isSelected: true,
        ),
      );
      expect(
        t.getSemantics(find.text('Agenda')),
        isSemantics(label: 'Agenda', isButton: true, isSelected: false),
      );
      await tapVisible(t, find.text('Agenda'));
      expect(
        t.getSemantics(find.text('Agenda').last),
        isSemantics(label: 'Agenda', isButton: true, isSelected: true),
      );
      semantics.dispose();
    },
  );

  // Hallado con TalkBack real: en Android (Flutter 3.50) un encabezado solo
  // llega como tal si tiene headingLevel; `header: true` no basta.
  testWidgets('Encabezados con headingLevel para Android', (t) async {
    setView(t, const Size(430, 932));
    final semantics = t.ensureSemantics();
    await t.pumpWidget(harness());
    await t.pumpAndSettle();
    int level(Finder f) => t.getSemantics(f).getSemanticsData().headingLevel;
    expect(level(find.text('Hoy').first), 1);
    expect(level(find.text('3 actividades hoy')), 2);
    expect(level(find.text('Caminar 20 minutos')), 3);
    await t.pumpWidget(harness(home: ActivityForm(date: clock())));
    await t.pumpAndSettle();
    expect(level(find.text('Nueva actividad').first), 1);
    expect(level(find.text('Frecuencia')), 2);
    semantics.dispose();
  });

  // Hallado con TalkBack real: la tarjeta tenía 6 paradas y la hora y el
  // estado sonaban antes que el nombre de la actividad.
  testWidgets('Tarjeta: 3 paradas y la información empieza por el nombre', (
    t,
  ) async {
    setView(t, const Size(430, 932));
    final semantics = t.ensureSemantics();
    await t.pumpWidget(harness());
    await t.pumpAndSettle();
    final card = t.widget<ActivityCard>(
      find.widgetWithText(ActivityCard, 'Tomar la medicación'),
    );
    final a = card.activity;
    final info =
        'Tomar la medicación, ${a.hour}, Completada, '
        '${a.frequency}${card.routine == null ? '' : ' · ${card.routine}'}';
    final node = t.getSemantics(find.bySemanticsLabel(info));
    expect(node, isSemantics(label: info, isHeader: true));
    expect(node.getSemanticsData().headingLevel, 3);

    // Todas las paradas que mencionan la actividad: información + 2 botones.
    final labels = <String>[];
    void visit(SemanticsNode n) {
      if (n.label.contains('Tomar la medicación')) labels.add(n.label);
      n.visitChildren((c) {
        visit(c);
        return true;
      });
    }

    visit(
      RendererBinding
          .instance
          .renderViews
          .first
          .owner!
          .semanticsOwner!
          .rootSemanticsNode!,
    );
    expect(labels, [
      info,
      'Deshacer: Tomar la medicación',
      'Ver detalle: Tomar la medicación',
    ]);
    // Hora y estado ya no son paradas sueltas.
    expect(find.bySemanticsLabel(a.hour), findsNothing);
    expect(find.bySemanticsLabel('Completada'), findsNothing);
    semantics.dispose();
  });

  // Hallado con TalkBack real: el logo de la barra se leía dos veces antes
  // del título de la pantalla.
  testWidgets('Pantalla secundaria: sin logo y el título nombra la ruta', (
    t,
  ) async {
    setView(t, const Size(430, 932));
    final semantics = t.ensureSemantics();
    await t.pumpWidget(harness(home: ActivityForm(date: clock())));
    await t.pumpAndSettle();
    expect(
      find.bySemanticsLabel('LifeFlow, organiza tu día a tu ritmo'),
      findsNothing,
    );
    final title = t.getSemantics(find.text('Nueva actividad').first);
    expect(
      title,
      isSemantics(label: 'Nueva actividad', isHeader: true, namesRoute: true),
    );
    expect(title.getSemanticsData().headingLevel, 1);
    expect(find.text('Esta versión no envía avisos al móvil'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('M1 plurales', (t) async {
    expect(plural(0, 'actividad', 'actividades'), '0 actividades');
    expect(plural(1, 'actividad', 'actividades'), '1 actividad');
    expect(plural(2, 'rutina', 'rutinas'), '2 rutinas');
    setView(t, const Size(430, 932));
    await t.pumpWidget(harness());
    await t.pumpAndSettle();
    expect(find.text('3 actividades hoy'), findsOneWidget);
    await tapVisible(t, find.text('Mis rutinas'));
    expect(find.text('1 rutina para tu día'), findsOneWidget);
    await t.pumpWidget(
      harness(
        home: RoutineForm(
          activities: [
            Activity(
              id: 1,
              name: 'Caminar',
              time: const TimeOfDay(hour: 9, minute: 0),
              date: clock(),
            ),
          ],
          routine: Routine('Mañana', {1}),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(find.text('1 actividad seleccionada'), findsOneWidget);
    await tapVisible(t, find.text('Caminar'));
    expect(find.text('0 actividades seleccionadas'), findsOneWidget);
  });
}
