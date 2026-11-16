# LifeFlow — Semana 4 — Verificación de revisión cruzada

Fecha de la verificación: 16 de noviembre de 2026. Fecha del cierre: 16 de noviembre de 2026 (Parte C).

Estado final: la verificación (Partes A y B) no modificó nada. Tras las decisiones del Grupo J (Parte C) **solo se ha cambiado P01-V2 al 200 %** (1 corrección: I-01). Las otras cuatro incidencias se mantienen sin cambios en el diseño. No se han tocado P01 normal, las demás pantallas, los componentes, la paleta, Flutter ni la memoria. Las Partes A y B se conservan tal como se redactaron antes de las decisiones; donde hablan de «propuestas», lo vigente es la Parte C.

Las observaciones del Grupo F (apartados 1–3) se separan de nuestras conclusiones técnicas (apartados 4 en adelante).

---

## Parte A — Lo que dice el Grupo F

### 1. Equipo revisor

Grupo F — Fair Share. Según su documento, Sergio Martínez Álvarez (Grupo F) encargó la revisión; el recorrido y las capturas los hizo Claude (IA) en el navegador de un integrante, sin personas usuarias, y queda pendiente de validación por integrantes del Grupo F. Fecha: 16 de noviembre de 2026. Es una revisión asistida por IA, no una prueba con personas usuarias.

### 2. Resultados originales de R1, R2 y R3 (Grupo F)

| Tarea | ¿Sin ayuda? | Observado por el Grupo F |
|---|---|---|
| R1 — crear actividad recurrente diaria | Sí | Hoy → «Nueva actividad» (3 pulsaciones tras desplazarse hasta el final de la lista) → «Guardar» → «Actividad guardada». El formulario venía con datos de ejemplo. Incidencia 1. |
| R2 — abrir el detalle de «Caminar 20 minutos» y volver | Sí | 2 pulsaciones; el detalle se entiende y la vuelta es clara. Sin dudas. |
| R3 — completar «Caminar 20 minutos» y deshacer | Sí | Aviso con «Deshacer»; contador «2 completadas · 3 pendientes»; «Deshacer» devuelve el estado. Tras «Completar» la pantalla volvió arriba y la tarjeta quedó fuera de la vista (incidencia 4). |

### 3. Las cinco incidencias recibidas (clasificación original del Grupo F)

| ID | Pantalla | Punto | Severidad (F) | Qué vio el Grupo F |
|---|---|---|---|---|
| I-01 | Hoy (R1) | 1 Jerarquía | Medio | «Nueva actividad» está al final de la lista; con 5 actividades y una ventana de unos 625 px hay que desplazarse; no hay otro acceso visible. |
| I-02 | Hoy | 2 Color | Bajo | El borde rojo de «Llamar al centro de salud» puede leerse como urgencia o error; no hay leyenda. El estado sí se indica con texto e icono. |
| I-03 | Hoy (cabecera) | 3 Contraste | Medio | El texto blanco «Jueves, 5 de noviembre de 2026» mide ≈ 4,3:1 (sobre una captura JPEG, valor aproximado). |
| I-04 | Hoy tras «Completar» | 5 Consistencia | Bajo | Al completar «Caminar 20 minutos» la pantalla volvió al principio de la lista y la tarjeta quedó fuera de la vista. |
| I-05 | Hoy, aviso «Deshacer» | 4 Targets | Bajo | El botón «Deshacer» mide ≈ 47–48 px de alto en la captura, en el límite; riesgo pendiente de comprobar. |

Sus capturas E1–E6 son de 390 × 625 px (una ventana de 625 px de alto sobre un marco de 844 px).

---

## Parte B — Verificación técnica (Grupo J)

### 4.1 ¿El prototipo revisado es la versión actual?

- El enlace de diseño del Grupo F apunta al archivo `vyEhW8AzVwyBElAFsbVdYE`, página «Alta fidelidad». Es **el mismo archivo** que usamos, no una copia distinta. El prototipo se abre sin sesión, así que el Grupo F vio lo que Figma sirve ahora.
- Las capturas del Grupo F coinciden con el estado posterior a las correcciones del 13.4: el aviso «Deshacer» aparece **dentro del flujo, bajo el resumen** (E6), no flotando sobre las tarjetas. E1 muestra «4 actividades hoy», que corresponde a `P01-R1-Inicial`, el inicio de R1.
- Diferencias entre la copia revisada y el archivo principal: **no se ha identificado ninguna**. Limitación: no podemos consultar el historial de versiones de Figma desde nuestras herramientas.
- El Grupo F no menciona P01-V2 (200 %): no es alcanzable desde el prototipo (no tiene enlace de entrada).

### 4.2 Verificación individual

#### I-01 — «Nueva actividad» al final de la lista

**Datos de Figma**
- En P01 normal, «Nueva actividad» está en una «Barra de acción fija» (y 668, 80 px de alto) y la navegación (y 748, 96 px) fuera del marco desplazable. El marco de la pantalla mide 844 px y el área que se desplaza («Contenido desplazable») es solo la parte intermedia (y 188–664, desplazamiento vertical). La barra no forma parte de la lista.
- En P01-V2 corregida (200 %), el botón sí está **al final de la lista** (decisión del 13.4); mide 366 × 80 px y **no tiene conexión** (no se puede pulsar en el prototipo). V2 no es alcanzable desde el recorrido.
- Otro acceso a «Nueva actividad» desde Hoy: no hay ninguno. Existe también en P03 (barra fija) y en el estado vacío de Agenda.

**Reproducción en el prototipo (ventana de 430 px de ancho)**
- Ventana de 940 px de alto (el marco entero cabe): «Nueva actividad» es visible desde la vista inicial, sin desplazarse. *(evidencia: I-01_ventana940_inicio_barra_visible)*
- Ventana de 625 px de alto, como la del Grupo F: la barra y la navegación **quedan fuera de la vista inicial**. Hay que desplazar el marco hasta el final; entonces la barra aparece justo debajo de la última tarjeta. *(I-01_ventana625_inicio_sin_barra e I-01_ventana625_tras_desplazar_barra_visible)*

**Resultado**
- En P01 normal el botón no está al final de la lista: es una barra fija que Figma recorta cuando la ventana es más baja que los 844 px del marco. Lo que vio el Grupo F es un artefacto de su ventana (625 px), no un comportamiento de la app. En un teléfono real de ≥ 800 px de alto la barra es visible. **No** está comprobado que lo sea en pantallas pequeñas ni con la barra de gestos: pendiente de Flutter.
- En P01-V2 sí ocurre, y es una decisión de diseño que tomamos en el 13.4 para mostrar actividades en la vista inicial al 200 %. Recorrido y desplazamiento: la lista mide 3 449 px; con una ventana de contenido de 624 px hay que desplazar unos 2 825 px (unas 4,5 pantallas). Empeora con cada actividad añadida: cada tarjeta al 200 % suma 600–650 px (unos 650 px de recorrido adicional por actividad). En P01 normal no empeora: la barra no depende de la longitud.

**Decisión de diseño o problema de accesibilidad:** en P01 normal, decisión de diseño correcta; en P01-V2, decisión de diseño con coste de accesibilidad (más desplazamiento para la acción principal). Sin limitar el escalado del texto.

#### I-02 — Borde rojo de «Llamar al centro de salud»

**Datos de Figma** (tarjeta de actividad, 1,5 px de borde)

| Actividad | Categoría | Borde | Relleno |
|---|---|---|---|
| Tomar la medicación | Medicación | verde #689C82 (estado Completada) | #E8F7EC |
| Caminar 20 minutos | Ejercicio | verde #689C82 | #ECF8EF al 86 % |
| Llamar al centro de salud | Salud — llamada | **rojo #CE7069** | #FFF3F2 al 86 % |
| Paseo de la tarde | Ejercicio | verde #689C82 | #ECF8EF al 86 % |
| Leer 15 minutos | Lectura | violeta #9A87CD | #F4EFFF al 86 % |

- El borde codifica la **categoría** de la actividad (cada una de las 9 categorías tiene su color), no la urgencia ni un error. No hay leyenda: la categoría se comunica con el icono (teléfono) y el nombre.
- El estado se comunica sin color: chip con texto e icono («Pendiente» con círculo, «Completada» con check) y franja lateral. *(Captura: I-02_tarjeta_Llamar_borde_rojo_ventana940)*
- Los mensajes de error usan otro rojo: borde de 2 px en #B42318 («Estado/Error») sobre fondo #FFF0EF, con icono «!» y título. El rojo de la categoría (#CE7069, más claro y rosado, 1,5 px) **no es el mismo** que el de los errores.
- Observación propia, no señalada por el Grupo F: el **verde se usa con dos significados**: categoría Ejercicio (borde #689C82 mientras está pendiente) y estado Completada (el mismo verde). El chip y la franja (azul si está pendiente, verde si está completada) evitan que se pierda el estado, pero el color de la tarjeta no distingue por sí solo.

**Resultado:** **riesgo de interpretación**, no un problema real: hay señales suficientes (icono de teléfono, nombre, chip con texto e icono) y el rojo no coincide con el de los errores. Falta una leyenda de categorías. Severidad nuestra: Bajo.

#### I-03 — Contraste de la fecha

**Datos originales de Figma** (nodo `I2006:1559;2004:1646`)
1. Color real del texto: `#FFFFFF`, opacidad 1, ligado a la variable «Superficie/Blanco»; fusión normal; sin efectos; texto «Jueves, 5 de noviembre de 2026», Inter Regular 16 px; caja en (16, 146), 358 × 22 px; los glifos ocupan x 16–262, y 151–165.
2. Degradado de la cabecera (390 × 188 px): lineal horizontal (transformación identidad), `#0C7F9E` al 0 % → `#2F6FC4` al 55 % → `#7A5BE0` al 100 %. En la franja del texto (x 16–262) corresponde a posiciones 4 %–67 %, es decir, del turquesa al azul.
3. Capas superpuestas (todas dentro de la cabecera, debajo del texto): «Luz matinal» (círculo blanco 38 %, desenfoque de capa 40, en x 230–420, y −60–130), «Forma translúcida 1 y 2» (blanco 14 %, x ≥ 270 y x ≥ 305), «Ola de luz» (blanco 20 %, desenfoque 18, y 176–286) y «Brillo inferior» (degradado blanco 0–32 %, y 172–188). El texto no tiene opacidad propia ni la cadena de capas padre.
4. Fondo efectivo: se obtuvo renderizando la cabecera **sin** el texto (copia temporal, ya borrada) y leyendo los píxeles reales debajo de cada letra, con la cobertura de cada píxel (diferencia entre el render con y sin texto).

**Resultados** (renderizado PNG sin pérdida a 1×; contraste WCAG con texto `#FFFFFF`)

| Medida | Contraste |
|---|---|
| Degradado puro (sin capas) en x 16 / 100 / 200 / 263 | 4,66 / 4,84 / 4,99 / 5,06 |
| **Mínimo bajo el núcleo de las letras** (píxeles con cobertura ≥ 90 %) | **4,64:1** (x 19, y 162, fondo `#0F7EA2`) |
| Mínimo bajo cualquier píxel con cobertura > 30 % | 4,61:1 |
| Mínimo del fondo en las filas del texto (y 144–168, incluye márgenes) | 4,59:1 (x 16–19) |
| Mínimo del fondo en toda la caja (hasta y 171, bajo el texto) | 4,36:1 (y 171, x 153; es el brillo de «Ola de luz», **no** está bajo las letras) |

- **Resultado: PASS** frente a 4,5:1 (texto normal de 16 px Regular). El punto más ajustado es el extremo izquierdo, el turquesa.
- Comparación con la auditoría 13.2: la auditoría registró **4,59:1** para este mismo texto (fondo `#107FA2`). Coincide con el valor de las filas del texto (4,59) y es 0,05 inferior al mínimo bajo los glifos (4,64): la diferencia es la ventana de muestreo (márgenes de la caja frente a píxeles bajo las letras). No hay contradicción.
- **Causa del 4,3 del Grupo F:** su método (el color del núcleo del trazo frente a la mediana del fondo, sobre JPEG). Al reproducirlo con este mismo render comprimido a JPEG (calidad 60–95) sale **4,31–4,42**: la compresión (submuestreo de color) tiñe de cian los píxeles blancos (`#CDFFFF`–`#D5FFFF`) y la mediana del fondo se toma de la zona central, más clara. Es un artefacto de la medición, no una propiedad del diseño.
- **Margen:** el margen sobre 4,5:1 es estrecho (0,09–0,14). Ya estaba anotado como margen ajustado en la auditoría 13.2.

**Limitaciones:** render 1× de 8 bits del propio Figma; no reproduce el desenfoque ni la gestión de color de un dispositivo ni de Flutter; la cobertura de los glifos es una estimación por diferencia de imágenes.

**Resultado:** **falso positivo** (la medición del Grupo F es un artefacto de JPEG), con un riesgo potencial por el margen estrecho.

#### I-04 — Pérdida de posición tras completar

**Reproducido** (ventana de 430 × 940 px): se desplazó la lista, se pulsó «Completar» en «Caminar 20 minutos» y la pantalla pasó a P01-V1 **en la parte superior**. El aviso aparece arriba y «Caminar 20 minutos» queda debajo (su chip «Completada» asoma en el borde inferior). *(I-04_tras_Completar_desde_scroll_vuelve_arriba)*

**Datos de Figma**
- «Completar» tiene una conexión «Al hacer clic → Navegar a» P01-V1 (otro marco), sin transición y **sin** «conservar la posición de desplazamiento» (la propiedad no está activada). Cada marco empieza con su propio desplazamiento en 0, y por eso se reinicia.
- Existe la opción «Preservar posición de desplazamiento» en las acciones de navegación. No se ha probado activarla (no se debe modificar nada todavía); su efecto entre marcos distintos depende de la estructura y habría que ensayarlo.
- El aviso permanece visible al llegar (arriba) y «Deshacer» (132 × 48 px) se pulsa sin buscar la tarjeta. Pero está **dentro de la lista**: si se desplaza hacia abajo desaparece.
- Antecedente propio: antes del 13.4 el aviso flotaba cerca de la barra inferior; el reinicio ya ocurría, pero la tarjeta quedaba a la vista porque «Caminar» es la 2.ª tarjeta. Al mover el aviso al flujo para evitar tapar botones, la tarjeta cambiada queda más abajo.

**Resultado:** **limitación de Figma / del patrón de prototipo** (un cambio de estado se simula con un marco nuevo), no una dificultad esperable en Flutter, donde el estado cambia en su sitio y la posición se mantiene. Riesgo para Flutter: dónde mostrar la confirmación (arriba, abajo o como mensaje) y que se anuncie a los lectores de pantalla; pendiente de probar.

#### I-05 — Tamaño de «Deshacer»

**Datos de Figma** (instancia `Botón Deshacer (aviso)` dentro de «Aviso con Deshacer» en P01-V1)
- Es un marco (`FRAME`) de **132 × 48 px**, auto-layout horizontal, relleno blanco, radio 12, sin trazo, con icono de 20 × 20 y etiqueta de 74 × 21 px.
- La conexión («Al hacer clic → P01») está **en ese mismo marco**; el contenedor «Aviso con Deshacer» (358 × 90 px) no tiene conexiones y no existe una capa invisible más grande. La zona de interacción del prototipo coincide con el botón visible.
- Criterio de 48 × 48 px: **cumple en el diseño**, exactamente en el límite (alto = 48, sin margen).
- La captura del Grupo F (E6) corresponde a la versión corregida (aviso arriba). Su estimación de ≈ 47–48 px es compatible con 48 px dentro del error de una captura reescalada (±1 px).
- Tamaño visual y área táctil real: son lo mismo en Figma; en Flutter el área depende de `minimumSize`/margen del botón y no está comprobada.

**Resultado:** **falso positivo** como incumplimiento; **riesgo potencial** por el margen nulo.

---

## 5. Clasificación

| ID | Pantalla | Descripción (Grupo F) | Sev. F | Evidencia revisada | Resultado | Tipo | Decisión recomendada |
|---|---|---|---|---|---|---|---|
| I-01 | Hoy | «Nueva actividad» al final de la lista | Medio | Estructura P01 y P01-V2; prototipo a 940 y 625 px | En P01 normal es una barra fija recortada por la ventana; en P01-V2 está al final de la lista | **Falso positivo** en P01; **riesgo potencial** en P01-V2 | P01: mantener justificadamente. P01-V2: corregir (opción propuesta abajo), a decidir por el grupo |
| I-02 | Hoy | Borde rojo = ¿error o urgencia? | Bajo | Variantes de tarjeta; render; colores de error | Codifica la categoría; el rojo no es el del error; estado con texto e icono | **Riesgo de interpretación** (nuestra valoración: Bajo) | Mantener justificadamente; leyenda opcional |
| I-03 | Hoy (cabecera) | Fecha ≈ 4,3:1 | Medio | Datos de Figma; render con y sin texto | 4,64:1 bajo las letras (PASS); 4,3 reproducido solo con JPEG | **Falso positivo** (artefacto de JPEG); riesgo potencial por margen | Mantener justificadamente; ajuste opcional del extremo turquesa |
| I-04 | Hoy tras «Completar» | Pérdida de posición | Bajo | Conexión; reproducción a 940 px | Reinicio real en el prototipo; aviso visible y reversible | **Limitación de Figma** (anticipa una cuestión de diseño en Flutter) | Mantener justificadamente; posponer a Flutter |
| I-05 | Hoy, aviso | «Deshacer» ≈ 47–48 px | Bajo | Nodo 132 × 48; captura del Grupo F | 48 px exactos; zona = botón visible | **Falso positivo**; riesgo potencial por margen nulo | Mantener; comprobar en Flutter |

La clasificación original del Grupo F se conserva en las columnas «Descripción» y «Sev. F». Ninguna incidencia se elimina del registro por resultar justificada.

## 6. Posibles correcciones (propuestas, sin aplicar)

1. **I-01 (solo P01-V2):** mover «Nueva actividad» justo debajo de la cabecera, antes de las tarjetas (80 px + separación). Es la opción más simple; la porción visible de la primera tarjeta bajaría de ≈ 375 a ≈ 280 px, que sigue mostrando su nombre y estado. No limita el escalado del texto. Alternativa: mantenerla al final y registrar la decisión.
2. **I-02:** leyenda o ayuda de categorías en el detalle, o documentar que el borde codifica la categoría. No se propone cambiar colores.
3. **I-03:** sin cambio obligatorio. Opcional: oscurecer ligeramente el inicio turquesa (`#0C7F9E`) para ganar margen (afecta a la paleta aprobada: requiere decisión).
4. **I-04:** mantener; si se quiere mitigar en Figma, ensayar «preservar posición de desplazamiento» en esa conexión (cambia la navegación: requiere decisión). En Flutter, actualizar el estado en el mismo sitio y anunciarlo.
5. **I-05:** opcional, dar 52 px de alto al botón para tener margen; no es obligatorio.

## 7. Evidencias (`evidencias/`)

- `grupoF/`: documento original y capturas E1–E6 del Grupo F (`GrupoF_capturas_E1-E6.png` las reúne).
- `prototipo_LifeFlow/`: capturas propias del prototipo en presentación (ventanas de 625 y 940 px de alto; tarjeta de «Llamar»; tras «Completar»).
- `I-03_contraste_fecha/`: render de la cabecera con y sin el texto, `medicion_I03.py` y su salida `salida_medicion_I03.txt` (reproducible).
- Existentes: `docs/auditoria-contraste/`, `docs/controles-lenguaje/` (incluye las capturas antes/después de P01-V1 y P01-V2) y `docs/vision-cromatica/`.

## 8. Limitaciones

- Sin historial de versiones de Figma: la equivalencia entre la copia revisada y la actual se deduce del mismo archivo y de las capturas.
- Las reproducciones se hicieron en un navegador a 430 px de ancho, no en un teléfono; el modo presentación recorta de forma distinta según la ventana.
- Las medidas del contraste son del renderizador de Figma (8 bits, 1×); no son las de Flutter ni las de un dispositivo.
- La cobertura de glifos es una estimación por diferencia de imágenes.
- Para I-04 no se ha probado el efecto de activar «preservar posición» (no se modificó el prototipo).
- Se usó una página y copias temporales en Figma solo para la medición; se eliminaron y no se tocó el contenido del archivo (cuatro páginas, dos puntos de inicio de flujo, igual que antes).
- Esperamos la decisión del grupo antes de cambiar nada.

---

## Parte C — Decisiones del Grupo J y cierre (apartado 13.5)

Las observaciones del Grupo F y su severidad original se conservan sin cambios. Las decisiones y justificaciones son del Grupo J.

| ID | Severidad original (F) | Observación del Grupo F | Resultado de nuestra verificación | Decisión del Grupo J | Justificación | Evidencia |
|---|---|---|---|---|---|---|
| I-01 | Medio | «Nueva actividad» al final de la lista; hay que desplazarse. | En P01 normal es una barra fija recortada por la ventana de 625 px del Grupo F (falso positivo). En P01-V2 sí estaba al final de la lista (riesgo potencial). | **Corregir solo P01-V2** (hecho). P01 normal se mantiene. | P01-V2 mostraba la acción principal al final de 3 449 px de lista. En P01 la barra fija es una decisión de diseño correcta. | Corrección: `evidencias/I-01_P01-V2/` (antes, después, comparativa). Mantenimiento de P01: `evidencias/prototipo_LifeFlow/I-01_*`. |
| I-02 | Bajo | El borde rojo de «Llamar al centro de salud» puede leerse como urgencia o error. | Riesgo de interpretación. El borde codifica la categoría; su rojo (#CE7069) no es el de los errores (#B42318); el estado va con texto e icono. | **Mantener** el diseño y justificar la codificación por categorías. | Cada categoría tiene su color (violeta: Medicación y Lectura; verde: Ejercicio; rojo: Salud — llamada). Hay icono y nombre en cada tarjeta, y el estado no depende del color. | `evidencias/prototipo_LifeFlow/I-02_tarjeta_Llamar_borde_rojo_ventana940.jpg` y tabla de colores del apartado 4.2. |
| I-03 | Medio | Fecha blanca sobre la cabecera ≈ 4,3:1 (captura JPEG). | Falso positivo. Contraste real **4,64:1** bajo las letras (PASS frente a 4,5:1). | **Mantener** el diseño. | El contraste medido es PASS. La diferencia del Grupo F es un artefacto de la compresión JPEG (ver C.2). | `evidencias/I-03_contraste_fecha/` (renders con y sin texto, script y salida). |
| I-04 | Bajo | Al pulsar «Completar» la pantalla vuelve arriba y la tarjeta queda fuera de la vista. | Reproducido. Es una limitación de Figma: «Completar» navega a otro marco sin conservar el desplazamiento. El aviso queda visible y «Deshacer» es alcanzable. | **Mantener** la transición actual y comprobar la conservación del scroll en Flutter. | En Flutter el estado cambia en su sitio y la posición se mantiene; no se cambia la navegación sin necesidad. | `evidencias/prototipo_LifeFlow/I-04_tras_Completar_desde_scroll_vuelve_arriba.jpg`. |
| I-05 | Bajo | «Deshacer» ≈ 47–48 px de alto. | Falso positivo. El marco mide 132 × 48 px y la zona de interacción coincide con el botón visible. | **Mantener** 132 × 48 px y verificar su área táctil real en Flutter. | Cumple 48 × 48 en el diseño (sin margen). El tamaño en Figma no equivale al área táctil de Flutter. | Datos de Figma del apartado 4.2 y captura E6 del Grupo F. |

### C.1 Corrección de I-01: P01-V2 al 200 %

**Qué se cambió (solo en la variante «P01-V2 … propuesta corregida», nodo `2069:6519`):** el botón «Nueva actividad» pasó de ser el último elemento de la lista a ser el **primero**, justo bajo la cabecera y antes de las tarjetas (12 px de separación con la cabecera y 16 px con la primera tarjeta). Sigue dentro del contenido desplazable, para no restar altura a las actividades; así lo interpretamos de «antes del contenido desplazable de actividades», y es fácil de cambiar si se quería fijo. El resumen del día sigue al final de la lista.

**Conexión:** «Nueva actividad» (antes sin enlace) navega con «Al hacer clic» a `P04 — Nueva actividad` (`2008:2877`), el mismo destino y la misma acción que el botón de P01 normal (flujo R1).

**Antes / después** (`evidencias/I-01_P01-V2/`):

| Medida | Antes (botón al final) | Después (botón bajo la cabecera) |
|---|---|---|
| Acceso a «Nueva actividad» | tras desplazar ≈ 2 825 px | visible en la vista inicial, sin desplazar |
| Primera tarjeta | empieza en y 249; ≈ 375 px visibles | empieza en y 345; **279 px visibles** |
| Botón | 366 × 80 px, sin enlace | 366 × 80 px, con enlace a P04 |
| Navegación fija | 220 px (26 %) | igual |
| Texto | 28–56 px, sin reducir | igual |

**Verificación (diseño de Figma, no dispositivo):**
- Geometría: el botón mide 366 × 80 px (≥ 48 × 48); las celdas de navegación miden 194 × 89 y 194 × 128 px; el área desplazable termina en y 624 y la navegación empieza en y 624 (sin solapamiento); 0 elementos fuera de 0–390 px en horizontal; el desplazamiento vertical se conserva (lista de 3 441 px).
- Primera actividad en la vista inicial: «Tomar la medicación» muestra completos su icono, la hora (08:00) y el estado «Completada», y el nombre solo en parte (se ve «Tomar la…»). Es identificable por icono, hora y estado, pero el nombre completo y los botones «Deshacer» y «Ver detalle» requieren un pequeño desplazamiento.
- Enlaces: 108 reacciones en las pantallas y variantes, las 108 con destino existente (antes 107; la nueva es la de este botón). No se ha ejecutado el modo presentación sobre P01-V2: **no tiene enlace de entrada** y es una variante de documentación.
- Contraste del texto blanco «Nueva actividad» (32 px semibold; texto grande, umbral 3:1) sobre el degradado del botón, con renders sin pérdida con y sin texto: **mínimo 4,64:1** (mediana 4,98:1), que supera también el umbral de texto normal de 4,5:1. El botón es el mismo componente, solo cambia de posición. Método y script: `medicion_boton.py` y `salida_medicion_boton.txt`.
- Colores, componentes y paleta: sin cambios. P01 normal y el resto de pantallas: sin cambios.

**Limitaciones:** no se ha probado en un dispositivo real ni en Flutter. La porción visible de la primera tarjeta (279 px) es menor que antes (375 px).

### C.2 Contraste de la fecha (I-03) y origen de la diferencia

- Contraste real del texto «Jueves, 5 de noviembre de 2026» (blanco `#FFFFFF`, 16 px Regular) sobre el degradado de la cabecera: **4,64:1** como mínimo bajo el núcleo de las letras (4,61:1 con cobertura > 30 %; 4,59:1 como mínimo del fondo en las filas del texto). **PASS** frente a 4,5:1. Coincide con el 4,59:1 de la auditoría 13.2 (diferencia de 0,05 por la ventana de muestreo).
- Origen del 4,3:1 del Grupo F: su método compara el color del núcleo del trazo con la mediana del fondo en una captura JPEG. Aplicado al mismo render comprimido en JPEG (calidad 60–95) da 4,31–4,42:1, porque la compresión tiñe de cian el blanco del texto (`#CDFFFF`–`#D5FFFF`) y la mediana del fondo se toma de la zona central, más clara. Es un artefacto de medición, no una propiedad del diseño.
- El margen sobre 4,5:1 sigue siendo estrecho (0,09–0,14); ya estaba anotado en la 13.2.
- Limitaciones: render de 8 bits del propio Figma; no reproduce el desenfoque ni la gestión de color de Flutter ni de un dispositivo.

### C.3 Limitaciones del prototipo y verificaciones pendientes en Flutter

Limitaciones del prototipo de Figma:
- El cambio de estado se simula con un marco nuevo, por lo que se reinicia el desplazamiento (I-04). No se ha ensayado «preservar posición de desplazamiento».
- En una ventana más baja que los 844 px del marco, el modo presentación recorta la barra y la navegación (I-01).
- P01-V2 y P04-V2 no son alcanzables desde los recorridos; P01-V2 es una variante de documentación.
- Los datos de los detalles nuevos (por ejemplo, las horas de los recordatorios) son de muestra.

Pendiente de comprobar en Flutter (nada de esto se ha probado):
1. Conservación del desplazamiento al completar una actividad, dónde se muestra la confirmación y su anuncio a lectores de pantalla (I-04).
2. Área táctil real de «Deshacer» y de los demás botones, con un mínimo de 48 × 48 px lógicos (I-05).
3. Visibilidad de la barra «Nueva actividad» y la navegación de P01 en pantallas pequeñas y con la barra de gestos (I-01).
4. En P01-V2 con el escalado real del sistema: altura de la navegación, 279 px de primera tarjeta visibles y comportamiento del scroll.
5. Contraste del texto blanco de la cabecera y del botón con el desenfoque y los degradados reales de Flutter (I-03).

### C.4 Evidencias de esta parte

- `evidencias/I-01_P01-V2/`: `P01-V2_antes_boton_al_final.png`, `P01-V2_despues_boton_bajo_cabecera.png`, `P01-V2_comparativa_antes_despues.png`, renders del botón con y sin texto, `medicion_boton.py` y su salida.
- Las evidencias de las Partes A y B siguen en `evidencias/grupoF/`, `evidencias/prototipo_LifeFlow/` y `evidencias/I-03_contraste_fecha/`.
