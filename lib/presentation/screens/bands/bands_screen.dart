import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../providers/bands_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/entities/band.dart';
import '../../../config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';

// ─── Paleta compartida Aero ──────────────────────────────────────────────────
class _AeroColors {
  static const grad1 = Color(0xFF0A7EC2);
  static const grad2 = Color(0xFF1BAEE0);
  static const grad3 = Color(0xFF3ECFA0);

  static const cardGradients = [
    [Color(0xFF1B9FD8), Color(0xFF0D6EA8)],
    [Color(0xFF27C48A), Color(0xFF0F8F63)],
    [Color(0xFF5B8FE8), Color(0xFF2E5CC4)],
    [Color(0xFF39C9B0), Color(0xFF1A8E7A)],
    [Color(0xFF60B8F0), Color(0xFF1E7FC4)],
    [Color(0xFF4DD9A0), Color(0xFF1CA872)],
  ];

  static const pieColors = [
    Color(0xFF29B6E8),
    Color(0xFF3ECFA0),
    Color(0xFF5B8FE8),
    Color(0xFF60B8F0),
    Color(0xFF27C48A),
    Color(0xFF39C9B0),
  ];
}

// ─── Burbuja decorativa reutilizable ────────────────────────────────────────
Widget _aeroBubble({
  double? left, double? right, double? top, double? bottom,
  required double size, required double opacity,
}) {
  return Positioned(
    left: left, right: right, top: top, bottom: bottom,
    child: Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(opacity * 1.5),
            Colors.white.withOpacity(opacity * 0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
      ),
    ),
  );
}

// ─── Screen principal ────────────────────────────────────────────────────────
class BandsScreen extends ConsumerWidget {
  const BandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bandsState = ref.watch(bandsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Bandas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: _StatusOrb(
              online: bandsState.serverStatus == ServerStatus.Online,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_AeroColors.grad1, _AeroColors.grad2, _AeroColors.grad3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _aeroBubble(left: -40, top: 100, size: 180, opacity: 0.12),
            _aeroBubble(right: -60, top: 280, size: 200, opacity: 0.10),
            _aeroBubble(left: 30, bottom: 100, size: 150, opacity: 0.09),
            SafeArea(
              child: Column(
                children: [
                  // Gráfico de tarta en panel glass
                  _AeroPiePanel(bands: bandsState.bands),
                  const SizedBox(height: 12),
                  // Lista de bandas
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                      itemCount: bandsState.bands.length,
                      itemBuilder: (context, i) => _BandTile(
                        band: bandsState.bands[i],
                        index: i,
                        ref: ref,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: bandsState.bands.length < 7
          ? _AeroFAB(onPressed: () => _addereNovumBand(context, ref))
          : null,
    );
  }

  void _addereNovumBand(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('New band name'),
        content: CupertinoTextField(
          controller: controller,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Add'),
            onPressed: () {
              final nomen = controller.text;
              if (nomen.length > 1) {
                ref.read(bandsProvider.notifier).addereBand(nomen);
              }
              context.pop();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Close'),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

// ─── Indicador de estado del servidor ───────────────────────────────────────
class _StatusOrb extends StatelessWidget {
  final bool online;
  const _StatusOrb({required this.online});

  @override
  Widget build(BuildContext context) {
    final color = online ? const Color(0xFF3ECFA0) : const Color(0xFFE85555);
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.20),
        border: Border.all(color: Colors.white.withOpacity(0.45), width: 1),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.6), blurRadius: 8, spreadRadius: 2),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Panel glass con PieChart ────────────────────────────────────────────────
class _AeroPiePanel extends StatelessWidget {
  final List<Band> bands;
  const _AeroPiePanel({required this.bands});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> dataMap = {
      for (final b in bands) b.nomen: b.numerusVotum.toDouble(),
    };

    if (dataMap.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            backgroundColor: Colors.white.withOpacity(0.20),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: Container(
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.45), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 800),
          colorList: _AeroColors.pieColors,
          chartType: ChartType.ring,
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValues: dataMap.length <= 6,
            showChartValueBackground: false,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            chartValueStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Tile de banda ───────────────────────────────────────────────────────────
class _BandTile extends StatelessWidget {
  final Band band;
  final int index;
  final WidgetRef ref;

  const _BandTile({required this.band, required this.index, required this.ref});

  List<Color> get _gradient =>
      _AeroColors.cardGradients[index % _AeroColors.cardGradients.length];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (_) => ref.read(bandsProvider.notifier).delereBand(band.id),
        background: Container(
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFE85555).withOpacity(0.85),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
                SizedBox(width: 8),
                Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => ref.read(bandsProvider.notifier).addereVotum(band.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.40), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: _gradient[0].withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar glass
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.22),
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                  ),
                  child: Center(
                    child: Text(
                      band.nomen.substring(0, 2).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Nombre
                Expanded(
                  child: Text(
                    band.nomen,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                // Votos en orbe
                Container(
                  constraints: const BoxConstraints(minWidth: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white.withOpacity(0.45), width: 1),
                  ),
                  child: Text(
                    '${band.numerusVotum}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── FAB Aero ────────────────────────────────────────────────────────────────
class _AeroFAB extends StatelessWidget {
  final VoidCallback onPressed;
  const _AeroFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF60D0F0), Color(0xFF1B8FD0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B9FD8).withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 4, left: 8, right: 8,
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white.withOpacity(0.28),
                ),
              ),
            ),
            const Center(
              child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}