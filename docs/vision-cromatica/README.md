# LifeFlow — Semana 4 — 13.3 Visión cromática

Sección Figma: «LifeFlow — Semana 4 — Visión cromática» (archivo `vyEhW8AzVwyBElAFsbVdYE`, página «Alta fidelidad», debajo de la auditoría de contraste). Tabla de evaluación completa en esa sección.

- `simulaciones/`: PNG 1× (390×844) de P01, P04V2 (P04-V2), P05 y P06 en `original`, `gris`, `protanopia`, `deuteranopia`. En Figma solo están P01 y P04-V2.
- `herramienta/sim.py`: simulación (Python + NumPy + Pillow). `meas.py`, `m2.py`: mediciones de luminancia/contraste sobre las simulaciones.
- Método: protanopía/deuteranopía = Machado, Oliveira y Fernandes (2009), severidad 1,0, en RGB lineal; gris = luminancia Rec. 709 en RGB lineal.
- Uso: `python sim.py original.png prefijo` → `prefijo_{gris,protanopia,deuteranopia}.png` y `prefijo_hoja.png`.
- Resultado: sin pérdida de significado detectada; sin cambios de diseño. Observación baja: el borde del campo con error se distingue poco sin color (1,35–2,32:1 de luminancia frente a un campo normal), compensado por grosor 3 px, icono «!» y texto.
- Limitaciones: dicromacia completa solamente, imágenes 1× de la vista inicial, sin pruebas con personas.
