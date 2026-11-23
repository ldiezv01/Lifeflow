# LifeFlow · Semana 5
Aplicación Flutter/Dart para Android e iOS. Siete pantallas navegables con datos de ejemplo. Los datos se guardan en el dispositivo (persistencia local mínima con `shared_preferences`); no hay servidores ni notificaciones reales. La semana 5 añade la implementación accesible: semántica, foco, errores y pruebas; el detalle está en la memoria v5 y en docs/ACCESIBILIDAD.md.

## Ejecutar
Desde esta carpeta, con Flutter instalado:
```sh
flutter pub get
flutter devices
flutter run -d <identificador>
```
Para revisión en navegador: `flutter run -d chrome`. Para Android: inicia un emulador o conecta un móvil con depuración USB y ejecuta `flutter run`. Para iOS se requiere macOS, Xcode y un simulador o dispositivo configurado: `flutter run`. El identificador `com.example.lifeflow` es provisional para esta entrega académica.

## Organización
- lib/models: actividad, recurrencia, estado por fecha y rutina, con su conversión a JSON.
- lib/data: guardado y carga del estado en el dispositivo (`local_store.dart`).
- lib/theme: paleta y tema reutilizable.
- lib/widgets: encabezado con onda, tarjeta, botón (con foco visible), campo, estado y navegación.
- lib/screens: formularios de actividad/rutina y detalle.
- lib/main.dart: aplicación, cuatro destinos principales y estado compartido.
- test: recorridos y guías de accesibilidad (`accessibility_test.dart`), semántica (`semantics_test.dart`), persistencia (`persistence_test.dart`) y capturas (`widget_test.dart`).

R1: Hoy → Nueva actividad → nombre, hora y frecuencia → Guardar → detalle con «Actividad guardada» → Volver. R2: Ver detalle → Volver conserva el origen. R3: Completar → Completada → Deshacer. Los errores conservan el contenido, llevan el foco al campo y se anuncian una vez. Los días concretos se seleccionan mediante casillas; una sola vez permite elegir fecha. Agenda filtra por fecha. Completar afecta a la ocurrencia de ese día. Las rutinas agrupan actividades existentes y pueden editarse.

## Capturas de widget
`flutter test --concurrency=1` genera PNG en `docs/capturas` de las siete pantallas y estados de error, guardado, completada, edición, días concretos, fecha única, selección de rutina y Agenda vacía, a 430 × 932. El sufijo `-200` identifica texto al 200 %. Son capturas de widget desplazables, sin marco ni barra de sistema. Roboto y su licencia están en assets/fonts; no hay rutas de fuentes de Windows. El logo es la zona correspondiente de la imagen original, recortada en Flutter, conservando su fondo rasterizado. Se incluye la referencia completa como recurso.

Para capturas definitivas: ejecutar en móvil/emulador y usar su función de captura. Capturar Hoy, Agenda, Mis actividades, Nueva actividad, Detalle, Mis rutinas y Crear rutina; añadir formulario vacío guardado (error), días concretos, una sola vez, edición de actividad/rutina y confirmación. Para Agenda vacía, seleccionar un día no cubierto por actividades: editar las recurrentes a días concretos y avanzar a otro día. Obtener también cada tramo desplazado de las pantallas largas. No reducir el texto para que quepa todo en una imagen.

## Validación
`flutter analyze` (0 errores; 11 avisos informativos por la deprecación de `package:flutter/material.dart`), `flutter test --concurrency=1` (46 pruebas) y `flutter build web --no-pub`. Para Android hace falta el Android Gradle Plugin 9.1.1 (ya fijado en `android/settings.gradle.kts`) con Flutter 3.50.
Pruebas automatizadas: recorridos R1–R3 al 100 % y 200 %, formularios y navegación, guías de áreas táctiles Android/iOS y etiquetas, guía de contraste de texto en Hoy, Nueva actividad y Detalle, semántica (rol, estado, encabezados, pestaña activa), foco visible y foco tras completar, persistencia (guardar, reiniciar, cotejar), cambio de día a medianoche/al reanudar y captura de las siete pantallas con variantes. No equivalen a una auditoría completa de accesibilidad ni a pruebas nativas Android/iOS. Consultar docs/ACCESIBILIDAD.md.
