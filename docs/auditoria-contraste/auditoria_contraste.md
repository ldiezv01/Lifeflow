# LifeFlow — Semana 4 — Auditoría de contraste (apartado 13.2)

Evaluación **exclusivamente del contraste del diseño visual en Figma** (versión definitiva «Luz de mañana»). No es una declaración de conformidad WCAG de la aplicación.

## 1. Alcance
- Pantallas prioritarias: P01 — Hoy, P04 — Nueva actividad, P04-V2 — Error de validación, P05 — Detalle de actividad y P06 — Mis rutinas.
- Componentes reutilizables: botones (todos los tipos), estados y mensajes, formularios (campos, opciones, interruptor, botón de día), navegación, cabeceras, fila de actividad, tarjeta de rutina y tarjetas de actividad (9 categorías × 2 estados).
- Versión analizada: página «LifeFlow — Semana 4 — Alta fidelidad» (no las páginas de referencia v1 y v2).

## 2. Criterios (WCAG 2.2)
| Tipo | Criterio | Umbral |
|---|---|---|
| Texto normal | 1.4.3 Contraste (mínimo) | 4,5:1 |
| Texto grande (≥ 24 px, o ≥ 18,66 px en negrita 700) | 1.4.3 | 3:1 |
| Componentes gráficos necesarios para comprender o utilizar la interfaz | 1.4.11 Contraste no textual | 3:1 |

Criterio sobre la negrita: «Semi Bold» (600) se trata como peso normal; solo «Bold» (700) puede calificar como texto grande.

Elementos **decorativos o exentos** (se miden a título informativo, resultado «N/A»): formas y luces de fondo, filete blanco translúcido de los botones con degradado, bordes de contenedores (tarjetas, paneles, mensajes), bordes de chips de estado, iconos de reloj y de flecha de fila, la hora de la barra de estado del sistema simulada y los componentes deshabilitados (WCAG 1.4.3 y 1.4.11 exentan los componentes inactivos). Los iconos que refuerzan una etiqueta de texto contigua se marcan «redundante» y se evalúan igualmente a 3:1 por prudencia.

## 3. Método de medición
Para no calcular un color semitransparente como si fuera opaco, **se han medido los píxeles reales que Figma dibuja detrás de cada elemento**:
1. Se duplicó cada pantalla y cada muestra de componente en una página temporal (ya eliminada) y se hicieron transparentes (opacidad 0) todos los textos e iconos, conservando el layout.
2. Se exportó cada copia como PNG a escala 1:1. Ese PNG contiene la composición real del fondo: opacidad de cada superficie, desenfoque de fondo, degradados, sombras y luces difusas.
3. De Figma se extrajo, para cada texto, icono y borde: color de primer plano real (opaco), tamaño, peso y rectángulo. En textos de una línea se usó la anchura real de los glifos.
4. Para cada elemento se calculó el contraste (luminancia relativa WCAG) entre su color y **cada píxel** del fondo bajo él (texto e iconos) o del anillo exterior (bordes, a 1,5–4,5 px). Se informa el **peor píxel**, que es el criterio más desfavorable.
5. En bordes con opacidad < 1 se compuso antes el color del trazo sobre el relleno interior.
6. El contenido desplazable de las pantallas que queda tapado por barras fijas o fuera del marco (65 elementos) no se mide en la pantalla; se cubre con las muestras de componentes.

**Limitaciones:** PNG de 8 bits a escala 1:1 con suavizado de bordes; no se modela el renderizado del dispositivo real (otro motor de desenfoque, modo de color o ajustes de contraste); no se miden indicadores de foco (no están diseñados), modo oscuro ni texto ampliado.

## 4. Resultados globales
- Mediciones realizadas: **555** (277 textos, 162 iconos, 113 bordes y 3 rellenos).
- Evaluadas con criterio (PASS/FAIL): **470**; sin criterio (N/A): **85** (sistema: 8, deco: 72, inactivo: 5).
- **PASS: 470 · FAIL: 0** (tras la corrección). Antes de la corrección: PASS 469 · FAIL 1.
- Contraste mínimo encontrado: **3,09:1** (P04-V2 — Error de validación · Borde «Entrada» (2 px); umbral 3:1).
- Texto normal, mínimo: **4,59:1** (P01 — Hoy · Texto «Jueves, 5 de noviembre de 2026» (16 px Regular)). Texto grande, mínimo: **4,22:1**. Iconos, mínimo: **3,60:1**. Bordes, mínimo: **3,09:1**.

## 5. Tabla de resultados representativos
Un renglón por pantalla y por grupo de elementos: el de **menor contraste** del grupo. La tabla completa está en el CSV.

| Pantalla | Elemento | Color de primer plano | Color de fondo efectivo | Ratio de contraste | Umbral exigido | PASS / FAIL | Observaciones |
|---|---|---|---|---|---|---|---|
| P01 — Hoy | **Texto principal sobre fondos claros** — Texto «Caminar 20 minutos» (18 px Semi Bold) · Información | #142B51 | #E5F1EE | 12,15:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E8F5EF y #E5F1EE |
| P01 — Hoy | **Texto principal sobre fondos claros** — Texto «09:30» (20 px Bold) · Fila hora | #142B51 | #E5F1EE | 12,15:1 | 3:1 (texto grande) | PASS | Fondo real entre #E8F3EF y #E5F1EE |
| P01 — Hoy | **Texto secundario sobre tarjetas y paneles** — Texto «1 completada · 4 pendientes» (16 px Regular) · Resumen del día (cristal) | #46587A | #E1F0FC | 6,15:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E9F4FD y #E1F0FC |
| P01 — Hoy | **Texto blanco sobre cabecera con degradado** — Texto «Jueves, 5 de noviembre de 2026» (16 px Regular) · Cabecera | #FFFFFF | #107FA2 | 4,59:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #107FA2 y #3F69C9 |
| P01 — Hoy | **Texto blanco sobre cabecera con degradado** — Texto «Hoy» (28 px Bold) · Cabecera | #FFFFFF | #107FA2 | 4,59:1 | 3:1 (texto grande) | PASS | Fondo real entre #107FA2 y #1579A8 |
| P01 — Hoy | **Texto blanco sobre botón con degradado** — Texto «Nueva actividad» (16 px Semi Bold) · Botón principal | #FFFFFF | #2675BA | 4,84:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #2675BA y #3F69C9 |
| P01 — Hoy | **Texto de botón secundario sobre superficie translúcida** — Texto «Deshacer» (16 px Semi Bold) · Botón acción | #6446B2 | #E6EAFB | 5,73:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EBECFC y #E6EAFB |
| P01 — Hoy | **Estado «Pendiente» (texto azul sobre celeste)** — Texto «Pendiente» (16 px Semi Bold) · Estado: Pendiente | #2557A7 | #E6F7FB | 6,35:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E6F7FB y #E6F7FB |
| P01 — Hoy | **Estado «Completada» (texto blanco sobre verde)** — Texto «Completada» (16 px Semi Bold) · Estado: Completada | #FFFFFF | #17663F | 6,98:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #17663F y #17663F |
| P01 — Hoy | **Etiqueta de navegación inferior (activa)** — Texto «Hoy» (16 px Semi Bold) · Navegación principal | #142B51 | #E9F1FA | 12,33:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EBF3FB y #E9F1FA |
| P01 — Hoy | **Icono de categoría sobre su círculo pastel** — Icono «Icono Ejercicio» · Fila superior | #17663F | #E5F1EE | 6,03:1 | 3:1 (componente gráfico) | PASS | Icono de categoría de la actividad (refuerza el nombre escrito). Fondo real entre #E6F1EF y #E5F1EE |
| P01 — Hoy | **Icono de navegación** — Icono «Icono sun» · Navegación principal | #0E7490 | #E6F7FB | 4,86:1 | 3:1 (componente gráfico) | PASS | Icono de navegación (acompaña a la etiqueta de texto). Fondo real entre #E6F7FB y #E6F7FB |
| P01 — Hoy | **Borde de botón secundario** — Borde «Botón Ver detalle» (2 px) · Tarjeta — Tomar la medicación | #6446B2 | #E1EDE9 | 5,71:1 | 3:1 (componente gráfico) | PASS | Borde del botón secundario (delimita el control). Fondo exterior real entre #E8F7EC y #E1EDE9 |
| P04 — Nueva actividad | **Texto principal sobre fondos claros** — Texto «Frecuencia (obligatorio)» (16 px Medium) · Selector de frecuencia | #142B51 | #EDEAFE | 11,91:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #FCFFFF y #EDEAFE |
| P04 — Nueva actividad | **Texto secundario sobre tarjetas y paneles** — Texto «Formato de 24 horas. Puedes escribirla c» (16 px Regular) · Campo Hora | #46587A | #BEEDF7 | 5,67:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #FCFFFF y #BEEDF7 |
| P04 — Nueva actividad | **Texto blanco sobre cabecera con degradado** — Texto «Volver» (16 px Semi Bold) · Botón Volver | #FFFFFF | #177CAA | 4,67:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #177CAA y #1C76AF |
| P04 — Nueva actividad | **Texto blanco sobre cabecera con degradado** — Texto «Nueva actividad» (28 px Bold) · Cabecera | #FFFFFF | #107FA2 | 4,59:1 | 3:1 (texto grande) | PASS | Fondo real entre #107FA2 y #316DC4 |
| P04 — Nueva actividad | **Texto blanco sobre botón con degradado** — Texto «Guardar» (16 px Semi Bold) · Botón Guardar | #FFFFFF | #2874BD | 4,86:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #2874BD y #4368CB |
| P04 — Nueva actividad | **Texto de botón secundario sobre superficie translúcida** — Texto «Cancelar» (16 px Semi Bold) · Botón Cancelar | #6446B2 | #E4EBFD | 5,75:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #ECECFE y #E4EBFD |
| P04 — Nueva actividad | **Indicador de control seleccionado / activado** — Icono «Punto» · Control | #6446B2 | #FFFFFF | 6,86:1 | 3:1 (componente gráfico) | PASS | Indicador de estado del control (seleccionado / activado). Fondo real entre #FFFFFF y #FFFFFF |
| P04 — Nueva actividad | **Borde de campo de formulario** — Borde «Entrada» (2 px) · Campo Hora | #6F7F9C | #BFECF8 | 3,19:1 | 3:1 (componente gráfico) | PASS | Borde del campo de formulario (único indicador visual de su límite). Fondo exterior real entre #F8FEFF y #BFECF8 |
| P04 — Nueva actividad | **Borde de control (radio / casilla)** — Borde «Control» (2 px) · Opción Días concretos | #6F7F9C | #F6FAFF | 3,86:1 | 3:1 (componente gráfico) | PASS | Borde del control de selección (radio / casilla). Fondo exterior real entre #F6FAFF y #F6FAFF |
| P04 — Nueva actividad | **Borde de fila de opción (refuerzo)** — Borde «Opción Días concretos» (2 px) · Selector de frecuencia | #5F6F8C | #D6D1F2 | 3,45:1 | 3:1 (componente gráfico) | PASS | Borde de la fila de opción; el control interior ya tiene su borde. Fondo exterior real entre #FFFEFD y #D6D1F2 |
| P04 — Nueva actividad | **Borde de botón secundario** — Borde «Botón Cancelar» (2 px) · Barra de acciones | #6446B2 | #E1E5F6 | 5,47:1 | 3:1 (componente gráfico) | PASS | Borde del botón secundario (delimita el control). Fondo exterior real entre #F5F9FD y #E1E5F6 |
| P04 — Nueva actividad | **Borde de interruptor / botón de día** — Borde «Interruptor» (2 px) · Interruptor de recordatorio | #6446B2 | #E9EFF8 | 5,94:1 | 3:1 (componente gráfico) | PASS | Borde de la pista del interruptor. Fondo exterior real entre #F1F6F9 y #E9EFF8 |
| P04-V2 — Error de validación | **Texto principal sobre fondos claros** — Texto «Frecuencia (obligatorio)» (16 px Medium) · Selector de frecuencia | #142B51 | #E4DBFA | 10,58:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #F2EAF8 y #E4DBFA |
| P04-V2 — Error de validación | **Texto secundario sobre tarjetas y paneles** — Texto «Formato de 24 horas. Puedes escribirla c» (16 px Regular) · Campo Hora | #46587A | #E5DCFD | 5,44:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #FFFFFE y #E5DCFD |
| P04-V2 — Error de validación | **Texto blanco sobre cabecera con degradado** — Texto «Volver» (16 px Semi Bold) · Botón Volver | #FFFFFF | #177CAA | 4,67:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #177CAA y #1C76AF |
| P04-V2 — Error de validación | **Texto blanco sobre cabecera con degradado** — Texto «Nueva actividad» (28 px Bold) · Cabecera | #FFFFFF | #107FA2 | 4,59:1 | 3:1 (texto grande) | PASS | Fondo real entre #107FA2 y #316DC4 |
| P04-V2 — Error de validación | **Texto blanco sobre botón con degradado** — Texto «Guardar» (16 px Semi Bold) · Botón Guardar | #FFFFFF | #2874BD | 4,86:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #2874BD y #4368CB |
| P04-V2 — Error de validación | **Texto de botón secundario sobre superficie translúcida** — Texto «Cancelar» (16 px Semi Bold) · Botón Cancelar | #6446B2 | #E4EBFD | 5,75:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #ECECFE y #E4EBFD |
| P04-V2 — Error de validación | **Mensaje de error (texto rojo oscuro)** — Texto «Escribe un nombre para la actividad, por» (16 px Semi Bold) · Fila de error | #B42318 | #BFEDF7 | 5,22:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #FDFFFF y #BFEDF7 |
| P04-V2 — Error de validación | **Icono de mensaje o error** — Icono «Icono mensaje» · Resumen de errores | #B42318 | #FFF0EF | 5,94:1 | 3:1 (componente gráfico) | PASS | Icono de mensaje o campo (acompaña a texto). Fondo real entre #FFF0EF y #FFF0EF |
| P04-V2 — Error de validación | **Indicador de control seleccionado / activado** — Icono «Punto» · Control | #6446B2 | #FFFFFF | 6,86:1 | 3:1 (componente gráfico) | PASS | Indicador de estado del control (seleccionado / activado). Fondo real entre #FFFFFF y #FFFFFF |
| P04-V2 — Error de validación | **Borde de campo de formulario** — Borde «Entrada» (2 px) · Campo Hora | #6F7F9C | #E3DDFE | 3,09:1 | 3:1 (componente gráfico) | PASS | Borde del campo de formulario (único indicador visual de su límite). Fondo exterior real entre #FDFFFF y #E3DDFE |
| P04-V2 — Error de validación | **Borde de control (radio / casilla)** — Borde «Control» (2 px) · Opción Diariamente | #6446B2 | #F2EBFF | 5,91:1 | 3:1 (componente gráfico) | PASS | Borde del control de selección (radio / casilla). Fondo exterior real entre #F2EBFF y #F2EBFF |
| P04-V2 — Error de validación | **Borde de fila de opción (refuerzo)** — Borde «Opción Diariamente» (2 px) · Selector de frecuencia | #6446B2 | #D5CDEB | 4,50:1 | 3:1 (componente gráfico) | PASS | Borde de la fila de opción; el control interior ya tiene su borde. Fondo exterior real entre #FFEFE0 y #D5CDEB |
| P04-V2 — Error de validación | **Borde de botón secundario** — Borde «Botón Cancelar» (2 px) · Barra de acciones | #6446B2 | #E1E5F6 | 5,47:1 | 3:1 (componente gráfico) | PASS | Borde del botón secundario (delimita el control). Fondo exterior real entre #F5F9FD y #E1E5F6 |
| P05 — Detalle de actividad | **Texto principal sobre fondos claros** — Texto «Actividad individual · no pertenece a ni» (18 px Semi Bold) · Dato — Tipo | #142B51 | #E0EBFC | 11,68:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E6F1FC y #E0EBFC |
| P05 — Detalle de actividad | **Texto secundario sobre tarjetas y paneles** — Texto «Tipo» (16 px Medium) · Dato — Tipo | #46587A | #E2ECFC | 6,00:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E4EFFD y #E2ECFC |
| P05 — Detalle de actividad | **Texto blanco sobre cabecera con degradado** — Texto «Volver» (16 px Semi Bold) · Botón Volver | #FFFFFF | #177CAA | 4,67:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #177CAA y #1C76AF |
| P05 — Detalle de actividad | **Texto blanco sobre cabecera con degradado** — Texto «Paseo de la tarde» (28 px Bold) · Cabecera | #FFFFFF | #4F79D0 | 4,22:1 | 3:1 (texto grande) | PASS | Fondo real entre #4F79D0 y #316DC4 |
| P05 — Detalle de actividad | **Texto de botón secundario sobre superficie translúcida** — Texto «Editar» (16 px Semi Bold) · Botón Editar | #6446B2 | #E6E9F8 | 5,68:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EDEBFB y #E6E9F8 |
| P05 — Detalle de actividad | **Estado «Pendiente» (texto azul sobre celeste)** — Texto «Pendiente» (16 px Semi Bold) · Estado: Pendiente | #2557A7 | #E6F7FB | 6,35:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E6F7FB y #E6F7FB |
| P05 — Detalle de actividad | **Icono de categoría sobre su círculo pastel** — Icono «Icono Ejercicio» | #17663F | #E5F6FE | 6,30:1 | 3:1 (componente gráfico) | PASS | Icono de categoría de la actividad (refuerza el nombre escrito). Fondo real entre #EEFAFF y #E5F6FE |
| P05 — Detalle de actividad | **Borde de botón secundario** — Borde «Botón Editar» (2 px) | #6446B2 | #D9D3F3 | 4,76:1 | 3:1 (componente gráfico) | PASS | Borde del botón secundario (delimita el control). Fondo exterior real entre #F4EDF4 y #D9D3F3 |
| P06 — Mis rutinas | **Texto principal sobre fondos claros** — Texto «20:30» (16 px Regular) · Fila horario | #142B51 | #E9F1FD | 12,36:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #ECF4FD y #E9F1FD |
| P06 — Mis rutinas | **Texto secundario sobre tarjetas y paneles** — Texto «Mis actividades» (16 px Regular) · Navegación principal | #46587A | #E8EFF6 | 6,16:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EDF3F9 y #E8EFF6 |
| P06 — Mis rutinas | **Texto blanco sobre cabecera con degradado** — Texto «Mis rutinas» (28 px Bold) · Fila de título | #FFFFFF | #107FA2 | 4,59:1 | 3:1 (texto grande) | PASS | Fondo real entre #107FA2 y #2771BB |
| P06 — Mis rutinas | **Texto blanco sobre botón con degradado** — Texto «Crear rutina» (16 px Semi Bold) · Botón principal | #FFFFFF | #2874BD | 4,86:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #2874BD y #3F69C9 |
| P06 — Mis rutinas | **Texto de botón secundario sobre superficie translúcida** — Texto «Editar rutina» (16 px Semi Bold) · Botón Editar rutina | #6446B2 | #E6E9FD | 5,70:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EBECFE y #E6E9FD |
| P06 — Mis rutinas | **Etiqueta de navegación inferior (activa)** — Texto «Mis rutinas» (16 px Semi Bold) · Navegación principal | #142B51 | #E9EFF6 | 12,14:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EDF2F8 y #E9EFF6 |
| P06 — Mis rutinas | **Icono de navegación** — Icono «Icono layers» · Navegación principal | #0E7490 | #E6F7FB | 4,86:1 | 3:1 (componente gráfico) | PASS | Icono de navegación (acompaña a la etiqueta de texto). Fondo real entre #E6F7FB y #E6F7FB |
| P06 — Mis rutinas | **Borde de botón secundario** — Borde «Botón Editar rutina» (2 px) · Tarjeta — Rutina Noche | #6446B2 | #D5DEF5 | 5,10:1 | 3:1 (componente gráfico) | PASS | Borde del botón secundario (delimita el control). Fondo exterior real entre #E6F4FD y #D5DEF5 |
| Componentes — Botones, estados y mensajes | **Texto principal sobre fondos claros** — Texto «Se ha añadido a tu planificación.» (16 px Regular) · Mensaje éxito | #142B51 | #E8F7EC | 12,68:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E8F7EC y #E8F7EC |
| Componentes — Botones, estados y mensajes | **Texto blanco sobre botón con degradado** — Texto «Destacado» (16 px Semi Bold) · Botón Destacado (Ninguno) | #FFFFFF | #197BAC | 4,70:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #197BAC y #4368CB |
| Componentes — Botones, estados y mensajes | **Texto de botón secundario sobre superficie translúcida** — Texto «Secundario» (16 px Semi Bold) · Botón Secundario (Ninguno) | #6446B2 | #E5EBFD | 5,76:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EBEDFE y #E5EBFD |
| Componentes — Botones, estados y mensajes | **Estado «Pendiente» (texto azul sobre celeste)** — Texto «Pendiente» (16 px Semi Bold) · Estado: Pendiente | #2557A7 | #E6F7FB | 6,35:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E6F7FB y #E6F7FB |
| Componentes — Botones, estados y mensajes | **Estado «Completada» (texto blanco sobre verde)** — Texto «Completada» (16 px Semi Bold) · Estado: Completada | #FFFFFF | #17663F | 6,98:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #17663F y #17663F |
| Componentes — Botones, estados y mensajes | **Mensaje de error (texto rojo oscuro)** — Texto «Error» (16 px Semi Bold) · Estado: Error | #B42318 | #FFF0EF | 5,94:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #FFF0EF y #FFF0EF |
| Componentes — Botones, estados y mensajes | **Icono de mensaje o error** — Icono «Icono mensaje» · Mensaje error | #B42318 | #FFF0EF | 5,94:1 | 3:1 (componente gráfico) | PASS | Icono de mensaje o campo (acompaña a texto). Fondo real entre #FFF0EF y #FFF0EF |
| Componentes — Botones, estados y mensajes | **Borde de botón secundario** — Borde «Botón Secundario (Ninguno)» (2 px) · Fila | #6446B2 | #E9EFF9 | 5,94:1 | 3:1 (componente gráfico) | PASS | Borde del botón secundario (delimita el control). Fondo exterior real entre #F5FCFF y #E9EFF9 |
| Componentes — Botones, estados y mensajes | **Controles deshabilitados (exentos)** — Texto «Deshabilitado» (16 px Semi Bold) · Botón Deshabilitado (Ninguno) | #5F6F8C | #E9EDF4 | 4,32:1 | 4,5:1 (texto normal) | N/A | Componente deshabilitado: exento de contraste en WCAG 1.4.3. Fondo real entre #E9EDF4 y #E9EDF4 (valor informativo; no aplica el criterio) |
| Componentes — Botones, estados y mensajes | **Controles deshabilitados (exentos)** — Icono «Icono» · Botón Deshabilitado (Marca) | #5F6F8C | #E9EDF4 | 4,32:1 | 3:1 (componente gráfico) | N/A | Componente deshabilitado: exento (WCAG 1.4.11). Fondo real entre #E9EDF4 y #E9EDF4 |
| Componentes — Formularios | **Texto principal sobre fondos claros** — Texto «Opción radio seleccionada» (16 px Semi Bold) · Opción Radio seleccionada | #142B51 | #F2EBFF | 12,12:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #F2EBFF y #F2EBFF |
| Componentes — Formularios | **Texto secundario sobre tarjetas y paneles** — Texto «Detalle» (16 px Regular) · Opción Casilla seleccionada | #46587A | #F2EBFF | 6,16:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #F2EBFF y #F2EBFF |
| Componentes — Formularios | **Texto blanco sobre botón con degradado** — Texto «Lun» (16 px Semi Bold) · Día seleccionado | #FFFFFF | #6446B2 | 6,86:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #6446B2 y #6446B2 |
| Componentes — Formularios | **Mensaje de error (texto rojo oscuro)** — Texto «Escribe un nombre para la actividad.» (16 px Semi Bold) · Fila de error | #B42318 | #ECF8FD | 6,08:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EFFAFF y #ECF8FD |
| Componentes — Formularios | **Icono de categoría sobre su círculo pastel** — Icono «Icono Medicación» · Opción Casilla seleccionada | #6446B2 | #F2EBFF | 5,91:1 | 3:1 (componente gráfico) | PASS | Icono de categoría de la actividad (refuerza el nombre escrito). Fondo real entre #F2EBFF y #F2EBFF |
| Componentes — Formularios | **Icono de navegación** — Icono «Icono calendario» · Campo fecha | #142B51 | #F4FAFF | 13,36:1 | 3:1 (componente gráfico) | PASS | Icono de navegación (acompaña a la etiqueta de texto). Fondo real entre #F4FAFF y #F4FAFF |
| Componentes — Formularios | **Icono de mensaje o error** — Icono «Icono error» · Fila de error | #B42318 | #ECF8FD | 6,08:1 | 3:1 (componente gráfico) | PASS | Icono de mensaje o campo (acompaña a texto). Fondo real entre #EFFAFF y #ECF8FD |
| Componentes — Formularios | **Indicador de control seleccionado / activado** — Icono «Pomo» · Interruptor | #6F7F9C | #EEF2F7 | 3,60:1 | 3:1 (componente gráfico) | PASS | Indicador de estado del control (seleccionado / activado). Fondo real entre #EEF2F7 y #EEF2F7 |
| Componentes — Formularios | **Borde de campo de formulario** — Borde «Entrada» (2 px) · Campo texto normal | #6F7F9C | #E4F5FC | 3,61:1 | 3:1 (componente gráfico) | PASS | Borde del campo de formulario (único indicador visual de su límite). Fondo exterior real entre #E9F8FE y #E4F5FC |
| Componentes — Formularios | **Borde de control (radio / casilla)** — Borde «Control» (2 px) · Opción Radio no seleccionada | #6F7F9C | #F6FAFF | 3,86:1 | 3:1 (componente gráfico) | PASS | Borde del control de selección (radio / casilla). Fondo exterior real entre #F6FAFF y #F6FAFF |
| Componentes — Formularios | **Borde de fila de opción (refuerzo)** — Borde «Opción Días concretos» (2 px) · Selector de frecuencia | #5F6F8C | #EDE9E7 | 4,21:1 | 3:1 (componente gráfico) | PASS | Borde de la fila de opción; el control interior ya tiene su borde. Fondo exterior real entre #FFF9F3 y #EDE9E7 |
| Componentes — Formularios | **Borde de interruptor / botón de día** — Borde «Interruptor» (2 px) · Interruptor desactivado | #6F7F9C | #E9F3FC | 3,60:1 | 3:1 (componente gráfico) | PASS | Borde de la pista del interruptor. Fondo exterior real entre #F0F8FD y #E9F3FC |
| Componentes — Navegación, cabeceras y filas | **Texto principal sobre fondos claros** — Texto «Tomar la medicación» (18 px Semi Bold) · Fila de actividad | #142B51 | #E8F3FD | 12,50:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EDF6FD y #E8F3FD |
| Componentes — Navegación, cabeceras y filas | **Texto principal sobre fondos claros** — Texto «08:00» (20 px Bold) · Fila de actividad | #142B51 | #EDF5FD | 12,77:1 | 3:1 (texto grande) | PASS | Fondo real entre #F3FAFE y #EDF5FD |
| Componentes — Navegación, cabeceras y filas | **Texto secundario sobre tarjetas y paneles** — Texto «Mis actividades» (16 px Regular) · Navegación — Hoy | #46587A | #E4EFFB | 6,14:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EBF4FD y #E4EFFB |
| Componentes — Navegación, cabeceras y filas | **Texto blanco sobre cabecera con degradado** — Texto «Jueves, 5 de noviembre de 2026» (16 px Regular) · Cabecera Principal | #FFFFFF | #107FA2 | 4,59:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #107FA2 y #3F69C9 |
| Componentes — Navegación, cabeceras y filas | **Texto blanco sobre cabecera con degradado** — Texto «Título Con volver» (28 px Bold) · Cabecera Con volver | #FFFFFF | #4E78CE | 4,28:1 | 3:1 (texto grande) | PASS | Fondo real entre #4E78CE y #396BC7 |
| Componentes — Navegación, cabeceras y filas | **Texto de botón secundario sobre superficie translúcida** — Texto «Editar rutina» (16 px Semi Bold) · Botón Editar rutina | #6446B2 | #E3EAFD | 5,70:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EBECFE y #E3EAFD |
| Componentes — Navegación, cabeceras y filas | **Etiqueta de navegación inferior (activa)** — Texto «Mis actividades» (16 px Semi Bold) · Navegación — Mis actividades | #142B51 | #E5F1FB | 12,25:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #ECF5FD y #E5F1FB |
| Componentes — Navegación, cabeceras y filas | **Icono de categoría sobre su círculo pastel** — Icono «Icono Medicación» · Fila de actividad | #6446B2 | #E9F3FD | 6,11:1 | 3:1 (componente gráfico) | PASS | Icono de categoría de la actividad (refuerza el nombre escrito). Fondo real entre #EDF6FD y #E9F3FD |
| Componentes — Navegación, cabeceras y filas | **Icono de navegación** — Icono «Icono sun» · Navegación — Hoy | #0E7490 | #E6F7FB | 4,86:1 | 3:1 (componente gráfico) | PASS | Icono de navegación (acompaña a la etiqueta de texto). Fondo real entre #E6F7FB y #E6F7FB |
| Componentes — Navegación, cabeceras y filas | **Borde de botón secundario** — Borde «Botón Editar rutina» (2 px) · Tarjeta de rutina | #6446B2 | #D8E1F5 | 5,23:1 | 3:1 (componente gráfico) | PASS | Borde del botón secundario (delimita el control). Fondo exterior real entre #EAF4FD y #D8E1F5 |
| Componentes — Tarjeta de actividad (pendiente) | **Texto principal sobre fondos claros** — Texto «Actividad Medicación» (18 px Semi Bold) · Pendiente — Medicación | #142B51 | #ECECFB | 12,02:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EDEDFB y #ECECFB |
| Componentes — Tarjeta de actividad (pendiente) | **Texto principal sobre fondos claros** — Texto «08:00» (20 px Bold) · Pendiente — Medicación | #142B51 | #ECECFB | 12,02:1 | 3:1 (texto grande) | PASS | Fondo real entre #EDEDFC y #ECECFB |
| Componentes — Tarjeta de actividad (pendiente) | **Texto secundario sobre tarjetas y paneles** — Texto «Diariamente · Rutina «Mañana»» (16 px Regular) · Pendiente — Medicación | #46587A | #EDECFB | 6,13:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EDEDFB y #EDECFB |
| Componentes — Tarjeta de actividad (pendiente) | **Texto blanco sobre botón con degradado** — Texto «Completar» (16 px Semi Bold) · Pendiente — Medicación | #FFFFFF | #107097 | 5,55:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #107097 y #0F679C |
| Componentes — Tarjeta de actividad (pendiente) | **Texto de botón secundario sobre superficie translúcida** — Texto «Ver detalle» (16 px Semi Bold) · Pendiente — Medicación | #6446B2 | #E7E9FD | 5,71:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EBECFE y #E7E9FD |
| Componentes — Tarjeta de actividad (pendiente) | **Estado «Pendiente» (texto azul sobre celeste)** — Texto «Pendiente» (16 px Semi Bold) · Pendiente — Medicación | #2557A7 | #E6F7FB | 6,35:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E6F7FB y #E6F7FB |
| Componentes — Tarjeta de actividad (pendiente) | **Icono de categoría sobre su círculo pastel** — Icono «Icono Comida» · Pendiente — Comida | #B54708 | #F6F1EA | 4,83:1 | 3:1 (componente gráfico) | PASS | Icono de categoría de la actividad (refuerza el nombre escrito). Fondo real entre #F7F1EA y #F6F1EA |
| Componentes — Tarjeta de actividad (pendiente) | **Borde de botón secundario** — Borde «Botón Ver detalle» (2 px) · Pendiente — Medicación | #6446B2 | #E5E3F7 | 5,44:1 | 3:1 (componente gráfico) | PASS | Borde del botón secundario (delimita el control). Fondo exterior real entre #EEEDFC y #E5E3F7 |
| Componentes — Tarjeta de actividad (completada) | **Texto principal sobre fondos claros** — Texto «Actividad Medicación» (18 px Semi Bold) · Completada — Medicación | #142B51 | #E8F7EC | 12,68:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E8F7EC y #E8F7EC |
| Componentes — Tarjeta de actividad (completada) | **Texto principal sobre fondos claros** — Texto «08:00» (20 px Bold) · Completada — Medicación | #142B51 | #E8F7EC | 12,68:1 | 3:1 (texto grande) | PASS | Fondo real entre #E8F7EC y #E8F7EC |
| Componentes — Tarjeta de actividad (completada) | **Texto secundario sobre tarjetas y paneles** — Texto «Diariamente · Rutina «Mañana»» (16 px Regular) · Completada — Medicación | #46587A | #E8F7EC | 6,45:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #E8F7EC y #E8F7EC |
| Componentes — Tarjeta de actividad (completada) | **Texto de botón secundario sobre superficie translúcida** — Texto «Deshacer» (16 px Semi Bold) · Completada — Medicación | #6446B2 | #E6EAFB | 5,73:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #EBECFC y #E6EAFB |
| Componentes — Tarjeta de actividad (completada) | **Estado «Completada» (texto blanco sobre verde)** — Texto «Completada» (16 px Semi Bold) · Completada — Medicación | #FFFFFF | #17663F | 6,98:1 | 4,5:1 (texto normal) | PASS | Fondo real entre #17663F y #17663F |
| Componentes — Tarjeta de actividad (completada) | **Icono de categoría sobre su círculo pastel** — Icono «Icono Comida» · Completada — Comida | #B54708 | #E8F7EC | 4,90:1 | 3:1 (componente gráfico) | PASS | Icono de categoría de la actividad (refuerza el nombre escrito). Fondo real entre #E8F7EC y #E8F7EC |
| Componentes — Tarjeta de actividad (completada) | **Borde de botón secundario** — Borde «Botón Ver detalle» (2 px) · Completada — Medicación | #6446B2 | #E1EDE9 | 5,71:1 | 3:1 (componente gráfico) | PASS | Borde del botón secundario (delimita el control). Fondo exterior real entre #E9F8EC y #E1EDE9 |

## 6. Correcciones realizadas
Solo se corrigió un componente. Medición anterior y posterior:

| Pantalla | Elemento | Color del trazo | Ratio antes | Ratio después | Resultado antes → después |
|---|---|---|---|---|---|
| P04 — Nueva actividad | Borde «Opción Días concretos» (2 px) · Selector de frecuencia | #6F7F9C → #5F6F8C | 2,75:1 | 3,45:1 | FAIL → PASS |
| P04 — Nueva actividad | Borde «Opción Una sola vez» (2 px) · Selector de frecuencia | #6F7F9C → #5F6F8C | 3,05:1 | 3,83:1 | PASS → PASS |
| Componentes — Formularios | Borde «Opción Radio no seleccionada» (2 px) ·  | #6F7F9C → #5F6F8C | 3,92:1 | 4,92:1 | PASS → PASS |
| Componentes — Formularios | Borde «Opción Casilla no seleccionada» (2 px) ·  | #6F7F9C → #5F6F8C | 3,66:1 | 4,60:1 | PASS → PASS |
| Componentes — Formularios | Borde «Opción Días concretos» (2 px) · Selector de frecuencia | #6F7F9C → #5F6F8C | 3,35:1 | 4,21:1 | PASS → PASS |
| Componentes — Formularios | Borde «Opción Una sola vez» (2 px) · Selector de frecuencia | #6F7F9C → #5F6F8C | 3,73:1 | 4,68:1 | PASS → PASS |

- **Componente:** «Opción de selección», variantes «Seleccionado = No» (radio y casilla), borde de la fila.
- **Motivo:** el borde #6F7F9C medía 2,75:1 frente al fondo lavanda de las luces difusas (umbral 3:1). Es un refuerzo no obligatorio (el control interior y el texto ya identifican la opción), pero se midió como incumplimiento por prudencia.
- **Modificación mínima:** nueva variable «Borde/Control reforzado» (#5F6F8C) aplicada solo a esas dos variantes. Mantiene el aspecto Morning Aero. Las páginas de referencia v1 y v2 conservan el color anterior.
- **Reclasificación (no es un cambio de diseño):** la primera pasada marcó FAIL (1,04:1) el relleno pálido de la pista del interruptor desactivado. Era un error del método: el límite del control lo marca su borde (3,60:1, PASS) y el relleno es decorativo. Se reclasificó como N/A y la tabla «antes» ya lo refleja.

## 7. Márgenes ajustados (aprobados, pero a vigilar)
- Texto blanco sobre el extremo turquesa de la cabecera: 4,59:1 frente a 4,5:1.
- Bordes de campos de formulario: 3,09:1 frente a 3:1. Mejora opcional no aplicada: oscurecer «Borde/Control» a #5F6F8C también en campos.
- Los valores dependen del fondo que haya detrás del cristal; se han medido con las luces difusas actuales.

## 8. Pendiente de comprobación manual
- Renderizado en dispositivo real (Flutter): el desenfoque, los brillos y la gestión de color pueden cambiar los píxeles finales.
- Los 65 elementos del contenido desplazable que quedan fuera de la vista inicial (se asumen cubiertos por los mismos componentes medidos).
- Indicador de foco del teclado, estados de pulsación y de hover (no están diseñados).
- Texto ampliado al 200 % (P01-V2 es solo una propuesta), alto contraste del sistema y modo oscuro.
- Contraste de los textos dentro de imágenes (el logotipo se considera decorativo junto al nombre escrito).
