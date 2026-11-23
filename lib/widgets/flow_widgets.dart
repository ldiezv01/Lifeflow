import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../models/activity.dart';
import '../theme/flow_theme.dart';

enum ButtonKind { primary, complete, undo }

class PrimaryButton extends StatefulWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon = Icons.add_rounded,
    this.kind = ButtonKind.primary,
    this.semanticsLabel,
    this.focusNode,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final ButtonKind kind;

  /// Nombre accesible si el texto visible no basta (debe empezar por [label]).
  final String? semanticsLabel;

  /// Permite a la pantalla mover el foco a este botón (p. ej. tras completar).
  final FocusNode? focusNode;

  /// Clave del anillo de foco (para las pruebas).
  static const focusRingKey = Key('primary-button-focus-ring');

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    final kind = widget.kind;
    final undo = kind == ButtonKind.undo;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: kind == ButtonKind.primary
            ? FlowTheme.gradient
            : kind == ButtonKind.complete
            ? const LinearGradient(colors: [Color(0xFF007F8A), FlowTheme.teal])
            : null,
        color: undo ? Colors.white : null,
        border: undo ? Border.all(color: FlowTheme.teal, width: 2) : null,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        // passthrough: el botón conserva el ancho que le da su contenedor.
        fit: StackFit.passthrough,
        children: [
          // Material propio dentro del degradado: sin él, hover y pulsación se
          // pintan en el Material de la pantalla, por debajo del degradado, y
          // no se ven (1.4.11).
          Material(
            type: MaterialType.transparency,
            child: Focus(
              canRequestFocus: false,
              skipTraversal: true,
              onFocusChange: (f) => setState(() => focused = f),
              child: TextButton(
                focusNode: widget.focusNode,
                onPressed: widget.onPressed,
                style:
                    TextButton.styleFrom(
                      foregroundColor: undo ? FlowTheme.teal : Colors.white,
                      minimumSize: const Size(48, 56),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ).copyWith(
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        final base = undo ? FlowTheme.teal : Colors.white;
                        if (states.contains(WidgetState.pressed)) {
                          return base.withValues(alpha: .28);
                        }
                        if (states.contains(WidgetState.focused) ||
                            states.contains(WidgetState.hovered)) {
                          return base.withValues(alpha: .16);
                        }
                        return null;
                      }),
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.label,
                        semanticsLabel: widget.semanticsLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Indicador de foco (2.4.7, 1.4.11) dentro de los límites del botón,
          // así no cambia su tamaño. Doble anillo: azul oscuro (frente al
          // fondo de la página, >= 3:1) y blanco (frente al degradado, >= 3:1).
          if (focused)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  key: PrimaryButton.focusRingKey,
                  decoration: BoxDecoration(
                    border: Border.all(color: FlowTheme.ink, width: 3),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LifeFlowLogo extends StatelessWidget {
  const LifeFlowLogo({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'LifeFlow, organiza tu día a tu ritmo',
    image: true,
    child: ExcludeSemantics(
      child: SizedBox(
        width: 188,
        height: 49,
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 300,
              height: 78,
              child: Stack(
                children: [
                  Positioned(
                    left: -163,
                    top: -85,
                    width: 1024,
                    height: 1536,
                    child: Image.asset(
                      'assets/reference.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class FlowHeader extends StatelessWidget {
  const FlowHeader(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF00D4D8), Color(0xFF247DF0), Color(0xFF793CF0)],
            ),
          ),
        ),
      ),
      Positioned.fill(child: CustomPaint(painter: _Waves())),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LifeFlowLogo(), const SizedBox(height: 16),
            // An opaque dark plate retains the bright reference palette without low-contrast white text.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF143B78),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    // Android (Flutter 3.50) solo marca encabezado si hay headingLevel.
                    headingLevel: 1,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Waves extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint();
    Path wave(double y, double depth) => Path()
      ..moveTo(0, s.height - y)
      ..cubicTo(
        s.width * .32,
        s.height + depth,
        s.width * .62,
        s.height - y - 68,
        s.width,
        s.height - y - 12,
      )
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    p.color = const Color(0xFFAAF0F3);
    canvas.drawPath(wave(34, 20), p);
    p.color = const Color(0xFFD7DEFF);
    canvas.drawPath(wave(17, 22), p);
    p.color = FlowTheme.background;
    canvas.drawPath(wave(5, 12), p);
  }

  @override
  bool shouldRepaint(_Waves oldDelegate) => false;
}

/// Shared secondary-page identity; title wraps at 200% rather than clipping in AppBar.
class FlowPageBar extends StatelessWidget implements PreferredSizeWidget {
  const FlowPageBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(72);
  @override
  // El logo es decorativo y se repite en cada pantalla secundaria: fuera de
  // la semántica para que TalkBack no lo lea antes del título real.
  Widget build(BuildContext context) => AppBar(
    toolbarHeight: 72,
    title: const ExcludeSemantics(child: LifeFlowLogo()),
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: FlowTheme.gradient,
        borderRadius: BorderRadius.circular(24),
      ),
      // El título nombra la ruta: es lo que se anuncia al entrar en la pantalla.
      child: Semantics(
        header: true,
        // Android (Flutter 3.50) solo marca encabezado si hay headingLevel.
        headingLevel: 1,
        namesRoute: true,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
  );
}

/// Estado con icono y texto. Sin liveRegion: el cambio ya lo anuncia el SnackBar
/// de completar/deshacer y una región viva por tarjeta producía anuncios dobles.
class StatusBadge extends StatelessWidget {
  const StatusBadge(this.done, {super.key});
  final bool done;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: done ? const Color(0xFFDCF6E6) : const Color(0xFFDDF1FF),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          done ? Icons.check_circle_outline : Icons.radio_button_unchecked,
          size: 20,
          color: done ? FlowTheme.green : FlowTheme.teal,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            done ? 'Completada' : 'Pendiente',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: done ? FlowTheme.green : FlowTheme.ink,
            ),
          ),
        ),
      ],
    ),
  );
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    required this.date,
    required this.onToggle,
    required this.onDetail,
    this.routine,
  });
  final Activity activity;
  final DateTime date;
  final VoidCallback onToggle, onDetail;
  final String? routine;
  @override
  Widget build(BuildContext context) {
    final done = activity.completed(date);
    final subtitle =
        '${activity.frequency}${routine == null ? '' : ' · $routine'}';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: done
              ? [const Color(0xFFF0FCF6), const Color(0xFFE0F8EF)]
              : [Colors.white, const Color(0xFFF5F8FF)],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border(
          left: BorderSide(
            color: done ? FlowTheme.green : FlowTheme.teal,
            width: 6,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15245599),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hallado con TalkBack real: hora y estado se leían antes que el
          // nombre, en paradas sueltas. La parte informativa es un único nodo
          // que empieza por el nombre y sigue siendo encabezado de nivel 3
          // para saltar de actividad en actividad.
          Semantics(
            container: true,
            header: true,
            // Android (Flutter 3.50) solo marca encabezado si hay headingLevel.
            headingLevel: 3,
            label:
                '${activity.name}, ${activity.hour}, '
                '${done ? 'Completada' : 'Pendiente'}, $subtitle',
            child: ExcludeSemantics(
              child: LayoutBuilder(
                builder: (context, c) {
                  final large =
                      MediaQuery.textScalerOf(context).scale(16) > 20 ||
                      c.maxWidth < 310;
                  final symbol = ExcludeSemantics(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: activity.icon == Icons.directions_walk_rounded
                            ? const Color(0xFFDCF8E5)
                            : activity.icon == Icons.restaurant_rounded
                            ? const Color(0xFFFFE8D9)
                            : const Color(0xFFECE3FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        activity.icon,
                        size: 42,
                        color: activity.icon == Icons.directions_walk_rounded
                            ? FlowTheme.green
                            : activity.icon == Icons.restaurant_rounded
                            ? const Color(0xFFB83C17)
                            : FlowTheme.purple,
                      ),
                    ),
                  );
                  final info = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(
                                Icons.schedule,
                                size: 22,
                                color: FlowTheme.ink,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                activity.hour,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: FlowTheme.ink,
                                ),
                              ),
                            ],
                          ),
                          StatusBadge(done),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activity.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: FlowTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: FlowTheme.muted,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                  return large
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [symbol, const SizedBox(height: 12), info],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            symbol,
                            const SizedBox(width: 14),
                            Expanded(child: info),
                          ],
                        );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final buttons = [
                // El nombre accesible empieza por el texto visible y añade la
                // actividad para distinguir los botones de cada tarjeta (2.4.4, 2.5.3).
                PrimaryButton(
                  done ? 'Deshacer' : 'Completar',
                  semanticsLabel:
                      '${done ? 'Deshacer' : 'Completar'}: ${activity.name}',
                  kind: done ? ButtonKind.undo : ButtonKind.complete,
                  icon: done ? Icons.undo : Icons.check,
                  onPressed: onToggle,
                ),
                OutlinedButton(
                  onPressed: onDetail,
                  child: Text(
                    'Ver detalle',
                    semanticsLabel: 'Ver detalle: ${activity.name}',
                  ),
                ),
              ];
              if (c.maxWidth < 300 ||
                  MediaQuery.textScalerOf(context).scale(16) > 20) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buttons[0],
                    const SizedBox(height: 10),
                    buttons[1],
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: buttons[0]),
                  const SizedBox(width: 12),
                  Expanded(child: buttons[1]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Distribuciones de la barra inferior, de la más compacta a la más holgada.
enum NavLayout { fourColumns, twoColumns, oneColumnRow, oneColumn }

class FlowNavigation extends StatelessWidget {
  const FlowNavigation({
    super.key,
    required this.index,
    required this.onChanged,
  });
  final int index;
  final ValueChanged<int> onChanged;

  static const labels = ['Hoy', 'Agenda', 'Mis actividades', 'Mis rutinas'];
  static const _icons = [
    Icons.wb_sunny_outlined,
    Icons.calendar_today_outlined,
    Icons.format_list_bulleted_rounded,
    Icons.layers_outlined,
  ];
  static const _iconSize = 30.0;
  static const _iconGap = 8.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 4, vertical: 8);
  static const _rowPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  /// Estilo de las etiquetas; se usa igual para pintarlas y para medirlas.
  static TextStyle labelStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!
          .merge(const TextStyle(fontSize: 14, fontWeight: FontWeight.w700));

  /// Elige la distribución más compacta en la que ninguna palabra de las
  /// etiquetas tenga que partirse (1.4.4, 1.4.10). Se decide por el ancho
  /// disponible y el tamaño real del texto, no solo por la escala.
  static NavLayout layoutFor(double width, TextStyle style, TextScaler scaler) {
    var longest = 0.0;
    for (final word in labels.expand((l) => l.split(' '))) {
      final painter = TextPainter(
        text: TextSpan(text: word, style: style),
        textDirection: TextDirection.ltr,
        textScaler: scaler,
      )..layout();
      if (painter.width > longest) longest = painter.width;
      painter.dispose();
    }
    if (longest <= width / 4 - _padding.horizontal) {
      return NavLayout.fourColumns;
    }
    if (longest <= width / 2 - _padding.horizontal) {
      return NavLayout.twoColumns;
    }
    if (longest <= width - _rowPadding.horizontal - _iconSize - _iconGap) {
      return NavLayout.oneColumnRow;
    }
    return NavLayout.oneColumn;
  }

  @override
  Widget build(BuildContext context) {
    final style = labelStyle(context);
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x33245599),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: LayoutBuilder(
            builder: (context, c) {
              final layout = layoutFor(
                c.maxWidth,
                style,
                MediaQuery.textScalerOf(context),
              );
              final row = layout == NavLayout.oneColumnRow;
              Widget item(int i) {
                final selected = index == i;
                final icon = Icon(
                  _icons[i],
                  size: _iconSize,
                  color: selected ? FlowTheme.teal : FlowTheme.muted,
                );
                final text = Text(
                  labels[i],
                  textAlign: row ? TextAlign.start : TextAlign.center,
                );
                // MergeSemantics: sin él, `selected` queda en un nodo padre
                // distinto del botón y Android/TalkBack no dice qué pestaña
                // está activa (comprobado con uiautomator en el emulador).
                return MergeSemantics(
                  child: Semantics(
                    selected: selected,
                    child: TextButton(
                      onPressed: () => onChanged(i),
                      style: TextButton.styleFrom(
                        foregroundColor: FlowTheme.ink,
                        backgroundColor: selected
                            ? const Color(0xFFDDF1FF)
                            : Colors.transparent,
                        minimumSize: Size(48, row ? 56 : 64),
                        padding: row ? _rowPadding : _padding,
                        textStyle: style,
                        alignment: row
                            ? Alignment.centerLeft
                            : Alignment.center,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: row
                          ? Row(
                              children: [
                                icon,
                                const SizedBox(width: _iconGap),
                                Flexible(child: text),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [icon, const SizedBox(height: 6), text],
                            ),
                    ),
                  ),
                );
              }

              final items = List.generate(4, item);
              return switch (layout) {
                NavLayout.fourColumns => Row(
                  children: items.map((w) => Expanded(child: w)).toList(),
                ),
                NavLayout.twoColumns => Wrap(
                  children: items
                      .map((w) => SizedBox(width: c.maxWidth / 2, child: w))
                      .toList(),
                ),
                _ => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: items,
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class FlowField extends StatelessWidget {
  const FlowField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.focusNode,
    this.isRequired = false,
  });
  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    final visibleLabel = isRequired ? '$label (obligatorio)' : label;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // La etiqueta visible se excluye porque ese mismo texto es el nombre
          // del campo (Semantics de abajo): un solo nombre, leído una vez.
          ExcludeSemantics(
            child: Text(
              visibleLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: FlowTheme.ink,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            label: visibleLabel,
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              validator: validator,
              // Revalida al escribir para quitar el error en cuanto se corrige.
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error de un grupo de opciones (días, actividades), junto al grupo: icono y
/// texto, no solo color. Como el error de un TextField, es liveRegion solo donde
/// el sistema no admite anuncios; en el resto lo anuncia el formulario.
class FieldError extends StatelessWidget {
  const FieldError(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    liveRegion: !MediaQuery.supportsAnnounceOf(context),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: FlowTheme.error, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              semanticsLabel: 'Error: $message',
              style: const TextStyle(
                color: FlowTheme.error,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Mensaje de estado para el lector de pantalla (4.1.3). Donde el sistema
/// desaconseja los anuncios (Android 16+), no hace nada y el mismo mensaje
/// llega por un nodo liveRegion (`liveRegion: !MediaQuery.supportsAnnounceOf`),
/// igual que hace Flutter con los errores de formulario: un solo anuncio.
void announce(BuildContext context, String message) {
  if (!MediaQuery.supportsAnnounceOf(context)) return;
  SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    Directionality.of(context),
  );
}
