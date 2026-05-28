import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SatusScreen extends StatefulWidget {
  const SatusScreen({super.key});

  @override
  State<SatusScreen> createState() => _SatusScreenState();
}

class _SatusScreenState extends State<SatusScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );

    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _ctrl.forward();

    // Redirige a DomusScreen tras 2.8 segundos
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A7EC2),
              Color(0xFF1BAEE0),
              Color(0xFF3ECFA0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Burbujas decorativas
            _bubble(left: -50, top: 60,   size: 200, opacity: 0.12),
            _bubble(right: -70, top: 200, size: 250, opacity: 0.09),
            _bubble(left: 40,  bottom: 80, size: 180, opacity: 0.10),
            _bubble(right: 20, bottom: 200, size: 130, opacity: 0.08),

            // Contenido central
            Center(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) => Opacity(
                  opacity: _opacityAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: child,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Orbe principal Aero
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Colors.white,
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
                            color: const Color(0xFF29B6E8).withValues(alpha: 0.55),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.water_drop_rounded,
                        color: Color(0xFF0A5A8A),
                        size: 52,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Título
                    const Text(
                      'Flu Avm App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtítulo glass
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.40),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Frutiger Aero',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Indicador de carga
                    SizedBox(
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white.withValues(alpha: 0.20),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                          minHeight: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble({
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