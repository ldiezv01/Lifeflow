# LifeFlow — Semana 4 — 13.4 Controles y lenguaje

Revisión del diseño Morning Aero definitivo en Figma (archivo `vyEhW8AzVwyBElAFsbVdYE`, página «Alta fidelidad»; sección «LifeFlow — Semana 4 — Controles y lenguaje»). Fecha: 2026-11-15.

**Alcance y límites.** Se revisa el diseño, no la aplicación. Los tamaños son los de los marcos de Figma (aproximación de diseño) y no sustituyen una prueba táctil real en Flutter. El modo presentación de Figma no se ha ejecutado. No se ha modificado ningún componente, pantalla ni conexión.

## 1. Resumen

| Indicador | Resultado |
|---|---|
| Controles analizados | 180 apariciones (175 en 17 pantallas y variantes + 5 en P01-V2 al 200 %), 15 tipos |
| Cumplen 48 × 48 px en el diseño | 180 / 180 |
| De ellos, condicionales | 30 (25 radios/casillas y 5 interruptores): el control visual mide 24 px o 56 × 32 px; cumplen si la fila completa es el área táctil |
| Separación mínima entre controles distintos | 8 px (las 4 pestañas de navegación son contiguas, 0 px) |
| Solapes | 1, intencionado: aviso «Deshacer» de P01-V1 sobre 25 px de los botones de la tarjeta |
| Reacciones de prototipo | 68 (52 navegación + 16 «Atrás»), 68 / 68 con destino existente |
| Incidencias | 14: 0 altas, 3 medias, 11 bajas o informativas |
| Correcciones aplicadas | Ninguna |

Detalle por control: `controles_tamanos.csv` (separador `;`).

## 2. Controles y tamaños (mínimos medidos)

| Tipo | Apariciones | Mínimo (ancho × alto) | ≥ 48 × 48 |
|---|---|---|---|
| Botón destacado (Guardar, Nueva actividad, Crear rutina) | 14 | 173 × 56 | 14 / 14 |
| Botón primario (Completar) | 14 | 151 × 56 | 14 / 14 |
| Botón secundario (Ver detalle, Deshacer, Cancelar, Editar, Anterior, Siguiente) | 39 | 153 × 56 | 39 / 39 |
| Navegación inferior (pestaña) | 32 | 95 × 93 | 32 / 32 |
| Botón Volver | 9 | 102 × 48 | 9 / 9 |
| Deshacer del aviso (P01-V1) | 1 | 132 × 48 | 1 / 1 |
| Fila de actividad | 8 | 358 × 125 | 8 / 8 |
| Tarjeta de rutina | 2 | 358 × 223 | 2 / 2 |
| Campo de formulario (entrada: 358 × 56) | 18 | 358 × 112 | 18 / 18 |
| Opción de selección — radio | 15 | 358 × 56 | 15 / 15 (fila) |
| Opción de selección — casilla | 10 | 358 × 72 | 10 / 10 (fila) |
| Botón de día | 7 | 80 × 52 | 7 / 7 |
| Interruptor de recordatorio (visual 56 × 32) | 5 | 358 × 95 | 5 / 5 (fila) |
| Aviso con Deshacer (contenedor no interactivo) | 1 | 358 × 90 | — |
| P01-V2: pestaña de navegación | 4 | 194 × 96 | 4 / 4 |
| P01-V2: «Nueva actividad» | 1 | 366 × 80 | 1 / 1 |

## 3. Separación y solapamientos

- Botones contiguos en fila: 11–12 px. Opciones y casillas apiladas: 8 px. Botones de día: 12 px.
- Pestañas de navegación: contiguas (0 px), sin solape. Informativa.
- P01-V1: el aviso flotante (y 566–656) cubre 25 px de los botones de la 2.ª tarjeta. Baja; su botón Deshacer (132 × 48) queda libre.
- Controles desplazables bajo las barras fijas (P01: 8, P04: 2, P01-V1: 8, P04-V1: 5…): contenido que se desplaza, no un solape de diseño; el recorte real se comprueba en Flutter.
- Solapes no intencionados entre controles de la misma capa: 0.

## 4. Iconografía y lenguaje

- Iconos de actividad: píldora, figura caminando y teléfono, reconocibles. El de «Leer 15 minutos» no se vio en la vista inicial (pendiente). Toda actividad lleva su nombre.
- Acciones críticas con texto: Guardar, Cancelar, Volver, Deshacer, Completar, Editar, Nueva actividad, Crear rutina. El icono nunca es la única vía.
- «Pendiente» / «Completada»: texto, forma (pastilla rellena frente a contorno) e icono (check frente a círculo vacío) distintos; confirmado en gris, protanopía y deuteranopía (13.3).
- Etiquetas coherentes entre pantallas. Texto mínimo de 16 px en todas las pantallas revisadas.
- Mejorable: «Anterior» / «Siguiente» (P02) sin sustantivo (propuesta: «Día anterior» / «Día siguiente»).
- Una mano: las acciones principales están en la mitad inferior; «Volver» está arriba a la izquierda (zona más lejana del pulgar). En P04/P07 lo compensa «Cancelar»; P05 solo tiene «Volver».

## 5. Formularios y errores (P04, P04-V2)

- Obligatorios identificados («(obligatorio)» en Nombre, Hora y Frecuencia; «(opcional)» en Recordatorio). Etiquetas siempre visibles sobre el campo.
- Mensajes: «Falta el nombre de la actividad» y «Escribe un nombre para la actividad, por ejemplo: «Paseo de la tarde»»; indica cómo corregir («Escríbelo y vuelve a pulsar «Guardar»»).
- En la variante simulada se conservan Hora 18:00 y Frecuencia «Diariamente»; el aviso lo declara.
- «Guardar» (relleno + check) y «Cancelar» (contorno) distinguibles. El error no depende solo del color: borde de 3 px, icono «!» y texto.
- **Observación de 13.3 (se mantiene baja):** sin color, la diferencia de luminancia entre el borde del campo erróneo y el de un campo normal es 1,62 (gris), 2,32 (protanopía) y 1,35 (deuteranopía). El campo se identifica por grosor, icono y texto; no hay evidencia para reclasificarla.
- Latente (baja): los campos Hora y Avisar llevan por defecto el mensaje «Escribe un nombre para la actividad.» (oculto en estado Normal).
- P04-V2 y sus controles no tienen reacciones ni enlace de entrada (existe copia estática en la sección E).

## 6. P01-V2 al 200 %

En la maqueta: sin desplazamiento horizontal (0 elementos fuera de 0–390 px); etiquetas completas (fecha y «Mis actividades» en dos líneas); «Nueva actividad» accesible (366 × 80, etiqueta de 32 px); lista de 3 449 px con 5 tarjetas de 600–649 px recorrible en vertical. Problemas: las dos barras fijas suman 336 px (40 % de 844) y la vista inicial no muestra ninguna tarjeta (cabecera 292 + resumen 243); la rejilla 2 × 2 de navegación tiene alturas desiguales (96, 99, 138, 99) y termina 3 px fuera del marco (847 frente a 844).

Solo con Flutter: scroll real y recorte, fuentes reales, altura de la barra de gestos, orden de lectura con lector de pantalla.

Propuestas (no aplicadas, afectan al diseño aprobado): limitar el escalado de la navegación (≈ 1,3–1,5×), cabecera que se contrae al desplazar, o «Nueva actividad» al final de la lista al 200 %.

## 7. Conexiones (estructurales)

68 reacciones, todas con destino existente en la página. Sin entrada: P01-R1-Inicial (inicio de R1), P01-V2, P04-V2 y P01-V3 (variantes de evaluación).

- **R1:** P01-R1-Inicial → P04 («Nueva actividad») → P05-V1 («Guardar») → P01-R1-Guardado («Volver a Hoy»). «Cancelar» y «Volver» → Atrás. Ramas: «Días concretos» → P04-V1; «Una sola vez» → P04-V4 (su «Guardar» no tiene enlace).
- **R2:** P01 → P05 (solo «Ver detalle» de la 4.ª tarjeta, bajo scroll), P02 y P03 → P05 (fila «Paseo de la tarde»), P05 → Atrás / P04-V3.
- **R3:** P01 → P01-V1 («Completar» de «Caminar 20 minutos») → P01 («Deshacer» del aviso o de la tarjeta).
- Navegación inferior: P01, P02, P03 y P06 enlazan entre sí.

**Esto no prueba que los recorridos funcionen:** el modo presentación no se ha ejecutado.

## 8. Incidencias

| ID | Incidencia | Severidad | Se comprueba en | Propuesta | Estado |
|---|---|---|---|---|---|
| I-01 | P01-V2: barras fijas = 40 % de la pantalla; sin actividades en la vista inicial | Media | Maqueta + Flutter | Ver apartado 6 | Pendiente de decisión |
| I-02 | P04-V2 sin enlace de entrada ni reacciones | Media | Maqueta | Mantener copia estática o enlazar (cambia navegación) | Pendiente de decisión |
| I-03 | Ramas sin cierre: «Guardar» de P04-V1/V4, «Ver detalle» de la 1.ª y 2.ª tarjeta de P01, «Editar rutina» de «Noche» | Media | Maqueta | Enlazar solo si el guion lo requiere | Pendiente de decisión |
| I-04 | Interruptor 56 × 32 y radios/casillas de 24 px | Baja | Flutter | Toda la fila como área táctil | Documentado |
| I-05 | Pestañas de navegación contiguas (0 px) | Informativa | Maqueta | Ninguna | Sin acción |
| I-06 | Aviso de P01-V1 cubre 25 px de botones; duración sin definir | Baja | Flutter | ≥ 10 s o permanente hasta actuar | Pendiente de Flutter |
| I-07 | «Anterior» / «Siguiente» sin contexto | Baja | Maqueta | «Día anterior» / «Día siguiente» | Pendiente de decisión |
| I-08 | «Volver» arriba a la izquierda; P05 sin «Cancelar» | Baja | Flutter | Gesto atrás del sistema; probar con una mano | Pendiente de prueba |
| I-09 | Borde del campo erróneo poco distinguible sin color (13.3) | Baja | Maqueta | Ninguna | Mantenida baja |
| I-10 | Mensaje de error por defecto de Hora/Avisar | Baja | Maqueta | Cambiar el valor al reutilizar | Propuesto |
| I-11 | P01-V2: alturas desiguales en la navegación y 3 px fuera del marco | Baja | Maqueta | Igualar alturas por fila | Propuesto |
| I-12 | Contenido recortado por barras fijas (p. ej. «Completar» de la 2.ª tarjeta) | Informativa | Flutter | Revisar relleno inferior del scroll | Pendiente de Flutter |
| I-13 | Icono de «Leer 15 minutos» no revisado | Informativa | Maqueta | Revisarlo con la lista desplazada | Pendiente |
| I-14 | Solo P01 tiene variante al 200 % | Informativa | Flutter | Ejecutar con el escalado del sistema | Pendiente |

## 9. No comprobado (requiere dispositivo real o Flutter)

Modo presentación de Figma, objetivos táctiles reales, lector de pantalla, foco y orden de lectura, escalado real del sistema, duración de avisos y uso con una mano.

---

## 10. Correcciones aplicadas tras la revisión (2026-11-15)

> Las secciones 1–9 describen la revisión original. Este apartado recoge lo corregido después y actualiza el registro de incidencias. Capturas antes / después en `correcciones/`.

### Elementos modificados realmente (Figma)

- **P01-V2 al 200 %.** Nueva variante «propuesta corregida»; la anterior se conserva como «versión anterior» (también las copias de la sección E). Cabecera sin fila de identidad ni banda decorativa (237 px frente a 292); «Nueva actividad» y el resumen pasan al final del flujo; navegación 2 × 2 con filas de igual altura (89 y 128 px). Barras fijas: 220 px (26 %) frente a 336 px (40 %). Contenido visible: 624 px. Actividad visible en la vista inicial: 375 px (antes 0). 0 elementos fuera del marco, sin desplazamiento horizontal; texto sin reducir (28–56 px). Celdas de navegación de 194 × 89 y 194 × 128 px; «Nueva actividad» de 366 × 80 px.
- **P01-V1.** El aviso «Deshacer» pasa al flujo, bajo el resumen. Solape con controles: 0 (antes 25 px). Botón Deshacer: 132 × 48 px.
- **P02 y P02-V1.** «Día anterior» / «Día siguiente» (156 × 56 px, sin cambios de tamaño).
- **Componente Campo de formulario.** Valor por defecto del mensaje de error neutro («Revisa este campo e inténtalo de nuevo.»). Mensajes propios en Hora, Avisar, Fecha y Nombre de la rutina (18 instancias).
- **Variantes nuevas (9):** P01-V2 corregida, P04-V5 (formulario vacío), P05-V2…V5 (detalle de Tomar la medicación, Caminar 20 minutos, Llamar al centro de salud y Leer 15 minutos), P05-V6 y P05-V7 (confirmaciones de creación de Leer 15 minutos y Llamar al centro de salud) y P07-V2 (editar rutina «Noche»).
- **Enlaces añadidos:**
  - P02-V1 «Nueva actividad» → P04-V5 → «Guardar» → P04-V2 (error). En P04-V2, «Volver» y «Cancelar» → Atrás.
  - «Guardar» de P04-V1 → P05-V6 y de P04-V4 → P05-V7.
  - «Ver detalle» de cada tarjeta de P01 (y de P01-V1, P01-R1-Inicial, P01-R1-Guardado) → detalle de su propia actividad.
  - Añadido por coherencia, no pedido: cada fila de P02 y P03 → el detalle de su propia actividad.
  - «Editar rutina» de «Noche» (P06) → P07-V2.
- **No modificado:** paleta, transparencias y resto de componentes; R1, R2 y R3 conservan su inicio y su recorrido.

### Verificación (diseño)

- 107 reacciones (80 de navegación y 27 «Atrás»), 107 / 107 con destino existente (antes 68). 0 destinos rotos.
- Cada «Ver detalle» y cada fila de P01, P02 y P03 abre un detalle cuyo título coincide con su actividad (0 discrepancias).
- Frames sin enlace de entrada: P01-R1-Inicial (inicio de R1), P01-V2 (ambas versiones) y P01-V3 (variantes de evaluación).
- Nuevos controles medidos: todos ≥ 48 × 48 px; sin solapes en P01-V1 ni en P01-V2.
- «Editar» de los detalles nuevos no tiene enlace: los formularios de edición existentes contienen los datos de otra actividad (P04-V3) y enlazarlos haría que una actividad abriera los datos de otra.

### Registro de incidencias actualizado

| ID | Estado |
|---|---|
| I-01 | Corregida en el diseño (P01-V2 corregida). Comprobar en Flutter. |
| I-02 | Corregida (P04-V5 → P04-V2). |
| I-03 | Corregida (destinos propios). «Editar» de otras actividades sigue sin enlace. |
| I-04 | Documentada; pendiente de Flutter. |
| I-05 | Sin acción. |
| I-06 | Aviso reubicado en el flujo (solape 0). Duración: pendiente de Flutter. |
| I-07 | Corregida («Día anterior» / «Día siguiente»). |
| I-08 | Pendiente de prueba real. |
| I-09 | Mantenida como baja. |
| I-10 | Corregida (mensaje propio por campo; valor por defecto neutro). |
| I-11 | Corregida en la nueva P01-V2. |
| I-12 a I-14 | Sin cambios (pendientes de Flutter o informativas). |

### Sigue pendiente (requiere Flutter o dispositivo real)

Modo presentación (no ejecutado: las herramientas disponibles no lo permiten, por lo que los enlaces están verificados solo estructuralmente), scroll real y barra fija al 200 %, ubicación definitiva de «Nueva actividad» al final de la lista, duración del aviso, objetivos táctiles reales, lector de pantalla y uso con una mano. Los datos de los nuevos detalles (horas de recordatorio, etc.) son de muestra.
