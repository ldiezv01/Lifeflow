import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/main.dart';
import 'package:lifeflow/widgets/flow_widgets.dart';
import 'package:lifeflow/theme/flow_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('R1, R2, R3, seven screens and captures $scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final font = FontLoader('LifeFlow')
        ..addFont(rootBundle.load('assets/fonts/roboto-regular.ttf'))
        ..addFont(rootBundle.load('assets/fonts/roboto-bold.ttf'));
      await tester.runAsync(() => font.load());
      final icons = FontLoader('MaterialIcons')
        ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
      await tester.runAsync(() => icons.load());
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: FlowTheme.data,
            locale: const Locale('es'),
            supportedLocales: const [Locale('es')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            builder: (c, w) => MediaQuery(
              data: MediaQuery.of(c)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: w!,
            ),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.runAsync(
        () => precacheImage(
          const AssetImage('assets/reference.png'),
          boundary.currentContext!,
        ),
      );
      await tester.pumpAndSettle();
      Future<void> capture(String name) async {
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          final image =
              await (boundary.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary)
                  .toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          Directory('docs/capturas').createSync(recursive: true);
          File('docs/capturas/$name${scale == 2 ? '-200' : ''}.png')
              .writeAsBytesSync(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }

      Future<void> tapText(String text, {String? activity}) async {
        await tester.pumpAndSettle();
        final f = activity == null
            ? find.text(text).first
            : find
                  .descendant(
                    of: find.widgetWithText(ActivityCard, activity),
                    matching: find.text(text),
                  )
                  .first;
        await tester.ensureVisible(f);
        await tester.pumpAndSettle();
        await tester.tap(f);
        await tester.pumpAndSettle();
      }

      await capture('01-hoy');
      await tapText('Completar', activity: 'Caminar 20 minutos');
      expect(find.text('Completada'), findsWidgets);
      await capture('01-completada');
      await tapText('Deshacer', activity: 'Caminar 20 minutos');
      final card = tester.widget<ActivityCard>(
        find.widgetWithText(ActivityCard, 'Caminar 20 minutos'),
      );
      expect(card.activity.completed(card.date), isFalse);
      await capture('01-deshacer');
      await tester.pump(const Duration(seconds: 5));
      await tapText('Ver detalle');
      expect(find.text('Detalle de actividad'), findsOneWidget);
      await capture('05-detalle');
      await tapText('Volver');
      await tapText('Nueva actividad');
      await capture('04-nueva-actividad');
      await tapText('Guardar');
      expect(find.text('Escribe un nombre para la actividad.'), findsOneWidget);
      await capture('04-error');
      await tester.enterText(
        find.byType(TextFormField).first,
        'Paseo de la tarde',
      );
      await tapText('Guardar');
      expect(find.text('Actividad guardada'), findsOneWidget);
      await capture('05-guardada');
      await tapText('Editar actividad');
      await capture('04-editar-actividad');
      await tester.enterText(
        find.byType(TextFormField).first,
        'Nombre descartado',
      );
      await tapText('Cancelar');
      expect(find.text('Paseo de la tarde'), findsOneWidget);
      await tapText('Editar actividad');
      await tapText('Días concretos');
      await capture('04-dias-concretos');
      await tapText('Una sola vez');
      await capture('04-fecha-unica');
      await tapText('Cancelar');
      await tapText('Volver');
      expect(find.text('Paseo de la tarde'), findsOneWidget);
      await tapText('Agenda');
      await capture('02-agenda');
      await tapText('Mis actividades');
      await capture('03-mis-actividades');
      await tapText('Mis rutinas');
      await capture('06-mis-rutinas');
      await tapText('Nueva rutina');
      await capture('07-crear-rutina');
      await tapText('Guardar');
      await capture('07-error-rutina');
      await tester.enterText(
        find.byType(TextFormField).first,
        'Rutina de prueba',
      );
      await tapText('Caminar 20 minutos');
      await capture('07-seleccion-rutina');
      await tapText('Guardar');
      await tapText('Editar rutina');
      await capture('07-editar-rutina');
      await tapText('Cancelar');
      await tapText('Agenda');
      for (final item in find.byType(Scrollable).evaluate()) {
        final state = (item as StatefulElement).state as ScrollableState;
        state.position.jumpTo(0);
      }
      await tester.pumpAndSettle();
      await capture('02-agenda-inicio');
      for (final name in [
        'Tomar la medicación',
        'Caminar 20 minutos',
        'Paseo de la tarde',
      ]) {
        await tapText('Mis actividades');
        await tapText('Ver detalle', activity: name);
        await tapText('Editar actividad');
        await tapText('Una sola vez');
        await tapText('Guardar');
        await tapText('Volver');
      }
      await tapText('Agenda');
      await tapText('Día siguiente');
      expect(find.text('No hay actividades para este día.'), findsOneWidget);
      await capture('02-agenda-vacia');
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('200 percent text has no layout exceptions', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: FlowTheme.data,
        home: MediaQuery(
          data: const MediaQueryData(
            textScaler: TextScaler.linear(2),
            size: Size(360, 800),
          ),
          child: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
