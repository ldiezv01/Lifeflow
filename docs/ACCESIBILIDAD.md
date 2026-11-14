# LifeFlow · Accesibilidad y sistema visual · Iteración 2

## Diseño implementado y diferencias justificadas
Las siete pantallas comparten Roboto empaquetado, logo original, fondo #F3F7FF, degradados, radios amplios, botones y jerarquía tipográfica. Las cuatro secciones tienen cabecera luminosa con tres ondas superpuestas; formularios y detalle usan una barra con el mismo logo y título en panel degradado, con regreso explícito. Los títulos secundarios se sitúan dentro del contenido desplazable para permitir varias líneas al 200 %, en lugar de recortarse en una AppBar de altura fija.

El logo se muestra mediante una ventana de recorte en Flutter sobre `assets/reference.png`, la imagen original aportada: zona x=163, y=85, tamaño 300×78; se presenta a 188×49. No se sustituye por Material ni se ha inventado un archivo transparente: conserva el fondo rasterizado de la referencia. Un archivo original independiente permitiría sustituir este recurso sin ese fondo ni el coste de cargar la imagen completa. Semantics aporta su nombre y evita anunciar contenido decorativo.

Cabecera: #00D4D8 → #247DF0 → #793CF0; ondas #AAF0F3, #D7DEFF y fondo #F3F7FF. Como el blanco sobre las zonas luminosas no asegura contraste, título/fecha van sobre #143B78 opaco. Esta base oscura es la principal diferencia respecto a la referencia y conserva el fondo luminoso sin oscurecer toda la cabecera. El texto no se coloca sobre las ondas claras.

Tarjetas: icono de 42 en bloque 64×64 con fondo asociado a la actividad; hora 26 con reloj, nombre 20, frecuencia 16 y estado textual con icono 13. A tamaño normal el icono y la información comparten fila; los botones están debajo en dos columnas. Con anchura interna <310 o texto >125 %, la información cambia a columna. Los botones pasan a columna con anchura interna <300 o texto >125 %. No se fuerza altura fija, no se trunca contenido ni se limita el escalado. Los iconos de actividad siguen siendo Material, con tamaño y colores diferenciados; no son las ilustraciones exactas de la referencia.

Completar usa degradado turquesa, Deshacer fondo blanco y borde turquesa de 2, Ver detalle borde oscuro. Nueva actividad/rutina y Guardar usan degradado violeta/azul/turquesa. Se omiten acciones de notificaciones que no tienen función en esta fase. La navegación blanca tiene esquinas superiores de 32, iconos 30 y selección celeste; al ampliar texto cambia a dos columnas. Se permite desplazamiento: no se intenta incluir tres tarjetas y todas las acciones en una única imagen.

## Colores y contraste comprobado
Cálculo con luminancia relativa sRGB, opacidad 100 %, antes de antialiasing. Valores redondeados para presentación. Texto normal: objetivo >=4,5:1; componentes relevantes: >=3:1.

| Elemento | Frente | Fondo | Ratio | Resultado de cálculo |
|---|---|---|---|---|
| Texto principal | #101D42 | #FFFFFF | 16,45:1 | Cumple texto normal |
| Texto secundario | #465A77 | #FFFFFF | 7,03:1 | Cumple texto normal |
| Texto secundario/lienzo | #465A77 | #F3F7FF | 6,54:1 | Cumple texto normal |
| Título y fecha en cabecera | #FFFFFF | #143B78 | 10,90:1 | Cumple texto normal |
| Completar, extremo más claro | #FFFFFF | #007F8A | 4,77:1 | Cumple texto normal |
| Deshacer y su borde | #006D80 | #FFFFFF | 6,00:1 | Cumple texto y componente |
| Estado completada | #087D38 | #DCF6E6 | 4,59:1 | Cumple texto normal |
| Estado pendiente | #101D42 | #DDF1FF | 14,18:1 | Cumple texto normal |
| Icono seleccionado | #006D80 | #DDF1FF | 5,17:1 | Cumple componente |
| Error | #B3261E | #F3F7FF | 6,09:1 | Cumple texto normal |
| Texto secundario/tarjeta verde | #465A77 | #E0F8EF | 6,30:1 | Cumple texto normal |
| Icono medicación | #6331CE | #ECE3FF | 5,94:1 | Cumple componente |
| Icono paseo | #087D38 | #DCF8E5 | 4,65:1 | Cumple componente |
| Icono comida | #B83C17 | #FFE8D9 | 4,81:1 | Cumple componente |

Botón principal y título de página: #6331CE → #2455CF → #006D80, blanco; mínimo muestreado 6,00:1. Completar: #007F8A → #006D80, blanco; mínimo muestreado 4,77:1. Se muestrearon 1001 posiciones por segmento interpolando canales sRGB. No se usa blanco directamente sobre el degradado luminoso de cabecera. Las sombras y ondas son decorativas y no comunican estado.

Pendiente: medir la salida rasterizada en Android/iOS, focos, pulsación, controles de diálogos de fecha/hora, estados inactivos y todos los colores derivados de Material. El cálculo de las combinaciones anteriores no certifica la aplicación completa. El logo es un recurso de marca de la referencia, no una combinación tipográfica evaluada en esta tabla.

## Medidas reutilizables
Roboto regular y bold local con licencia en assets/fonts/LICENSE.txt. Cuerpo 16–18; navegación 14 escalable; título principal 38; título secundario 28; secciones 24; nombre de tarjeta 20; hora 26; estado 13. El estado pequeño mantiene contraste >=4,5:1 y se amplía con el sistema.

Botón principal mínimo 48×56; secundario 48×52; IconButton 48×48; navegación 48×64. Separación de acciones 10–12. Tarjetas radio 26, relleno 18, separación 16, borde lateral 6. Botones principales radio 22 y secundarios 16. Márgenes 20–24. Anchos máximos 760 para secciones y 680 para formularios/detalle. No confundir tamaño del dibujo del icono con superficie interactiva.

## Fecha y estado
Hoy se recalcula a medianoche local y al recibir AppLifecycleState.resumed, con temporizador cancelado al destruir la pantalla. La prueba usa reloj inyectado y no cambia el reloj del sistema. Si Agenda estaba en el día actual, avanza con él; si se consultaba otro día, lo conserva. La navegación entre días usa fechas de calendario para evitar saltos por cambios de horario de verano. El estado de completada sigue asociado a cada fecha; la actividad puntual de ejemplo no se traslada al nuevo día. Los datos continúan en memoria.

## Evidencia automatizada de esta iteración
Ejecutar `flutter analyze` y `flutter test --concurrency=1`.

- R1/R2/R3 completos al 100 % y al 200 %, con creación, confirmación, consulta, regreso y completar/deshacer; sin excepciones de disposición en los pasos ejecutados.
- Validación de días concretos sin selección y conservación del nombre; selección de días y guardado.
- Rutinas: error sin selección, conservación del nombre, selección, resumen y guardado. Edición precargada de rutina y actividad, cancelación sin guardar, guardado de edición, variante de fecha única y Agenda vacía.
- Cambio de fecha con la aplicación abierta y al reanudarla; Agenda conserva fecha elegida.
- Flutter Accessibility Guideline API: androidTapTargetGuideline (48×48), iOSTapTargetGuideline (44×44) y labeledTapTargetGuideline, comprobados después de los pasos de navegación/formulario del archivo accessibility_test.dart al 100 % y 200 %. La regla Android es la referencia del mínimo 48×48 del proyecto.
- Capturas reales de widgets con fuentes locales y logo precargado, a 430×932; variantes normales y sufijo -200. Prueba adicional de Hoy a 360×800 con texto 200 %.

Las guías inspeccionan nodos semánticos visibles en los estados recorridos; no prueban todos los píxeles ni todos los controles que pueden abrirse. No se ha ejecutado la Guideline API de contraste de texto: los contrastes declarados se calculan en la tabla anterior. Las pruebas de widgets no equivalen a pruebas con TalkBack/VoiceOver ni a validación de binarios nativos.

## Conservado y pendiente
Se conservan encabezados Semantics, nombres de acciones, estado seleccionado, regiones liveRegion, errores visibles y confirmación. Estados con texto e icono además del color. Acciones críticas por toque simple y botones Volver/Cancelar explícitos. No hay Firebase, notificaciones reales ni persistencia.

Pendiente: TalkBack y VoiceOver reales (orden y retorno del foco, anuncios, errores y estados), teclado y orientación horizontal, diálogos fecha/hora a texto ampliado, todos los tamaños de pantalla, auditoría de contraste de estados de plataforma, ejecución nativa Android e iOS y pruebas con usuarios. No se afirma conformidad WCAG global.

Las etiquetas de campos se sitúan encima del control y pueden ocupar varias líneas. Los errores de campo admiten hasta ocho líneas: se evita la elipsis predeterminada observada durante la revisión de capturas al 200 %. El campo conserva su nombre accesible mediante Semantics.
