import '../../../presentation/providers/providers.dart';
import '../../../presentation/widgets/wirget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../config/helper/coloris_forma.dart';

class ChartaScreen extends ConsumerStatefulWidget {
  const ChartaScreen({super.key});

  @override
  ConsumerState<ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends ConsumerState<ChartaScreen> {
  CircleAnnotationManager? _circleAnnotationManager;
  Cancelable? _dragCancelable;

  void _initializeCiecleAnnotations(MapboxMap mapBoxMap) {
    mapBoxMap.annotations.createCircleAnnotationManager().then((manager) {
      _circleAnnotationManager = manager;
      _addVelRenovareMarker();
    });
  }

  void _setupDragListener(CircleAnnotationManager manager) {
    _dragCancelable?.cancel();
    final socketService = ref.read(socketServiceProvider);

    _dragCancelable = manager.dragEvents(
      onChanged: (CircleAnnotation annotation) {
        final pos = annotation.geometry.coordinates;
        ref.read(coordsMarkerProvider.notifier).state = pos;
        socketService.miterePositio(pos);
      },
      onEnd: (CircleAnnotation annotation) {
        final pos = annotation.geometry.coordinates;
        ref.read(coordsMarkerProvider.notifier).state = pos;
        socketService.miterePositio(pos);
      },
    );
  }

  Future<void> _addVelRenovareMarker() async {
    final manager = _circleAnnotationManager;
    if (manager == null) return;

    await manager.deleteAll();
    _setupDragListener(manager);

    final placed = ref.read(markerPositumProvider);

    if (placed) {
      final situs = ref.read(coordsMarkerProvider);
      final color = ref.read(formColorProvider);
      final optiones = CircleAnnotationOptions(
        geometry: Point(coordinates: situs),
        circleColor: color.toARGB32(),
        circleRadius: 14,
        circleStrokeColor: Colors.white.toARGB32(),
        circleStrokeWidth: 2,
        isDraggable: true,
      );
      try {
        await manager.create(optiones);
      } catch (e) {
        debugPrint('Error al crear el marcador: $e');
      }
    }

    final aliiRudi = ref.read(aliiUsoresProvider).value ?? [];
    final meusId = ref.read(socketServiceProvider).meusSocketId;
    final alii = aliiRudi.where((u) => u.id != meusId).toList();

    for (final usor in alii) {
      final usorColor = adHexExColor(usor.colorHex);
      final aliaOptionen = CircleAnnotationOptions(
        geometry: Point(coordinates: usor.positio),
        circleColor: usorColor.toARGB32(),
        circleRadius: 14,
        circleStrokeColor: Colors.white.toARGB32(),
        circleStrokeWidth: 2,
        isDraggable: false,
      );
      try {
        await manager.create(aliaOptionen);
      } catch (e) {
        debugPrint('Error al crear el marcador de otro usuario: $e');
      }
    }
  }

  @override
  void dispose() {
    _dragCancelable?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(markerPositumProvider, (prev, next) {
      if (next) _addVelRenovareMarker();
    });
    ref.listen(aliiUsoresProvider, (prev, next) {
      _addVelRenovareMarker();
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Forzamos que el AppBar pinte su área con glass
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0A7EC2).withValues(alpha: 0.75),
                const Color(0xFF1BAEE0).withValues(alpha: 0.55),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
          ),
        ),
        title: const Text(
          'Mapa',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Indicador de usuarios conectados
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: _ConnectedUsersOrb(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Mapa de fondo
          MapWidget(
            key: const ValueKey('main_mapa'),
            cameraOptions: CameraOptions(
              center: Point(coordinates: initialisMarkerPositio),
              zoom: 14.5,
            ),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _initializeCiecleAnnotations,
          ),

          // Panel de info/form en esquina superior derecha
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 90, right: 12),
              child: _GlassPanel(
                child: ref.watch(markerPositumProvider)
                    ? InformaUsoris(
                        nomen: ref.watch(formNomenProvider),
                        color: ref.watch(formColorProvider),
                        positio: ref.watch(coordsMarkerProvider),
                      )
                    : const ComplereForm(),
              ),
            ),
          ),

          // Badge de usuarios en esquina inferior izquierda
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 32),
              child: _UsersCountBadge(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Panel glass reutilizable ─────────────────────────────────────────────────
class _GlassPanel extends StatelessWidget {
  final Widget child;
  const _GlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Reflejo gloss superior
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.22),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Orbe de usuarios conectados (AppBar) ─────────────────────────────────────
class _ConnectedUsersOrb extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aliiAsync = ref.watch(aliiUsoresProvider);
    final count = aliiAsync.value?.length ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withValues(alpha: 0.50), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3ECFA0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3ECFA0).withValues(alpha: 0.7),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Badge de usuarios en el mapa (esquina inferior) ──────────────────────────
class _UsersCountBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aliiAsync = ref.watch(aliiUsoresProvider);
    final users = aliiAsync.value ?? [];

    if (users.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B9FD8), Color(0xFF0D6EA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B9FD8).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people_outline_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            '${users.length} usuario${users.length == 1 ? '' : 's'} conectado${users.length == 1 ? '' : 's'}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}