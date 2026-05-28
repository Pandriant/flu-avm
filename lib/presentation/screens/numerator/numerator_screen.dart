// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import '../../providers/numerator_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumeratorScreen extends ConsumerWidget {
  const NumeratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int clickNumerator = ref.watch(numeratorProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Numerator',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A7EC2), Color(0xFF1BAEE0), Color(0xFF3ECFA0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Burbujas decorativas
            _buildBubble(left: -40, top: 80, size: 180, opacity: 0.12),
            _buildBubble(right: -60, top: 250, size: 220, opacity: 0.10),
            _buildBubble(left: 40, bottom: 120, size: 160, opacity: 0.09),
            // Contenido central
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Orbe contador
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFF7DD9F5),
                          Color(0xFF1B9FD8),
                        ],
                        center: Alignment(-0.3, -0.4),
                        focal: Alignment(-0.3, -0.4),
                        focalRadius: 0.1,
                        radius: 1.0,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF29B6E8).withValues(alpha: 0.5),
                          blurRadius: 30,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$clickNumerator',
                        style: const TextStyle(
                          color: Color(0xFF0A5A8A),
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Label glass
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.45),
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      'Pulsa + para incrementar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _AeroFAB(
        onPressed: () {
          ref
              .read(numeratorProvider.notifier)
              .update((state) => state + 1);
        },
        icon: Icons.add_rounded,
      ),
    );
  }

  Widget _buildBubble({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withValues(alpha: opacity * 1.5),
              Colors.white.withValues(alpha: opacity * 0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

// FAB estilo Aero
class _AeroFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const _AeroFAB({required this.onPressed, required this.icon});

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
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B9FD8).withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Reflejo gloss
            Positioned(
              top: 4,
              left: 8,
              right: 8,
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white.withValues(alpha: 0.30),
                ),
              ),
            ),
            Center(
              child: Icon(icon, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}