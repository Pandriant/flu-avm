import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../presentation/providers/modus_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─── Paleta Frutiger Aero (Claro y Oscuro) ──────────────────────────────────
class _AeroPalette {
  // Colores claros (modo normal)
  static const skyTop    = Color(0xFF0A7EC2);
  static const skyMid    = Color(0xFF29B6E8);
  static const skyLight  = Color(0xFF7DD9F5);
  static const mint      = Color(0xFF3ECFA0);
  static const mintLight = Color(0xFF9FEDD8);
  
  // Colores oscuros (modo nocturno)
  static const darkSkyTop    = Color(0xFF0A2E4A);
  static const darkSkyMid    = Color(0xFF1A5F8E);
  static const darkSkyLight  = Color(0xFF2D7BB5);
  static const darkMint      = Color(0xFF2A8F6B);
  static const darkMintLight = Color(0xFF3DA87D);
  
  static const white70   = Color(0xB3FFFFFF);
  static const white40   = Color(0x66FFFFFF);
  static const white20   = Color(0x33FFFFFF);
  static const glassEdge = Color(0x80FFFFFF);
  
  // Colores oscuros para glassmorphism
  static const darkWhite70   = Color(0xB31A1A1A);
  static const darkWhite40   = Color(0x661A1A1A);
  static const darkWhite20   = Color(0x331A1A1A);
  static const darkGlassEdge = Color(0x80333333);

  // Gradientes modo claro
  static const cardGradients = [
    [Color(0xFF1B9FD8), Color(0xFF0D6EA8)],
    [Color(0xFF27C48A), Color(0xFF0F8F63)],
    [Color(0xFF5B8FE8), Color(0xFF2E5CC4)],
    [Color(0xFF39C9B0), Color(0xFF1A8E7A)],
    [Color(0xFF60B8F0), Color(0xFF1E7FC4)],
    [Color(0xFF4DD9A0), Color(0xFF1CA872)],
    [Color(0xFF7BA8F0), Color(0xFF3A64C8)],
    [Color(0xFF38D4C8), Color(0xFF179A90)],
  ];
  
  // Gradientes modo oscuro
  static const darkCardGradients = [
    [Color(0xFF0D4A6E), Color(0xFF073A58)],
    [Color(0xFF1A6B4A), Color(0xFF0F4F38)],
    [Color(0xFF2E4A8A), Color(0xFF1A3570)],
    [Color(0xFF1B705E), Color(0xFF0F5548)],
    [Color(0xFF1A5580), Color(0xFF0F4060)],
    [Color(0xFF1C6B4A), Color(0xFF0F5038)],
    [Color(0xFF2A4A80), Color(0xFF1A3570)],
    [Color(0xFF1B7068), Color(0xFF0F5550)],
  ];
  
  static List<Color> getCardGradient(int index, bool isDarkMode) {
    final pairs = isDarkMode ? darkCardGradients : cardGradients;
    return pairs[index % pairs.length];
  }
}

// ─── Pantalla principal ─────────────────────────────────────────────────────
class DomusScreen extends ConsumerWidget {
  const DomusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool estTenebrisModus = ref.watch(estTenebrisModusProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Flu Avm App',
          style: TextStyle(
            color: estTenebrisModus ? Colors.grey[300] : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _GlassIconButton(
              icon: estTenebrisModus
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              onTap: () {
                ref
                    .read(estTenebrisModusProvider.notifier)
                    .update((state) => !estTenebrisModus);
              },
              isDarkMode: estTenebrisModus,
            ),
          ),
        ],
      ),
      body: _AeroBackground(
        isDarkMode: estTenebrisModus,
        child: SafeArea(
          child: Column(
            children: [
              const _DomusBandera(),
              Expanded(
                child: _DomusMatrix(
                  isDarkMode: estTenebrisModus,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Fondo degradado Aero con burbujas ─────────────────────────────────────
class _AeroBackground extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  const _AeroBackground({required this.child, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
                  _AeroPalette.darkSkyTop,
                  _AeroPalette.darkSkyMid,
                  _AeroPalette.darkMint,
                ]
              : [
                  _AeroPalette.skyTop,
                  _AeroPalette.skyMid,
                  _AeroPalette.mint,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Burbujas decorativas Aero
          ..._buildBubbles(isDarkMode),
          child,
        ],
      ),
    );
  }

  List<Widget> _buildBubbles(bool isDarkMode) {
    final bubbleColor = isDarkMode 
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.12);
    
    final bubbles = [
      _BubbleData(left: -40,  top: 80,  size: 180, opacity: isDarkMode ? 0.06 : 0.12),
      _BubbleData(right: -60, top: 200, size: 220, opacity: isDarkMode ? 0.05 : 0.10),
      _BubbleData(left: 60,   top: 320, size: 120, opacity: isDarkMode ? 0.04 : 0.08),
      _BubbleData(right: 20,  bottom: 200, size: 160, opacity: isDarkMode ? 0.05 : 0.10),
      _BubbleData(left: -20,  bottom: 80,  size: 200, opacity: isDarkMode ? 0.04 : 0.09),
    ];

    return bubbles.map((b) {
      return Positioned(
        left: b.left,
        right: b.right,
        top: b.top,
        bottom: b.bottom,
        child: Container(
          width: b.size,
          height: b.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                bubbleColor.withValues(alpha: b.opacity * 1.5),
                bubbleColor.withValues(alpha: b.opacity * 0.3),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            border: Border.all(
              color: (isDarkMode ? Colors.grey[800]! : Colors.white).withValues(alpha: 0.18),
              width: 1.5,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _BubbleData {
  final double? left, right, top, bottom, size;
  final double opacity;
  const _BubbleData({
    this.left, this.right, this.top, this.bottom,
    required this.size, required this.opacity,
  });
}

// ─── Botón glass para la AppBar ─────────────────────────────────────────────
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDarkMode;
  const _GlassIconButton({required this.icon, required this.onTap, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (isDarkMode ? Colors.grey[800]! : Colors.white).withValues(alpha: 0.22),
          shape: BoxShape.circle,
          border: Border.all(
            color: (isDarkMode ? Colors.grey[600]! : Colors.white).withValues(alpha: 0.5), 
            width: 1,
          ),
        ),
        child: Icon(
          icon, 
          color: isDarkMode ? Colors.grey[300] : Colors.white, 
          size: 20,
        ),
      ),
    );
  }
}

// ─── Banner superior ────────────────────────────────────────────────────────
class _DomusBandera extends ConsumerWidget {
  const _DomusBandera();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(estTenebrisModusProvider);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: (isDarkMode ? Colors.grey[900]! : Colors.white).withValues(alpha: isDarkMode ? 0.25 : 0.18),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: (isDarkMode ? Colors.grey[700]! : Colors.white).withValues(alpha: 0.45),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono esfera Aero
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDarkMode
                    ? const RadialGradient(
                        colors: [
                          Color(0xFF2D7BB5),
                          Color(0xFF1A5F8E),
                          Color(0xFF0A2E4A),
                        ],
                        center: Alignment(-0.3, -0.4),
                        focal: Alignment(-0.3, -0.4),
                        focalRadius: 0.1,
                        radius: 1.0,
                      )
                    : const RadialGradient(
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFF7DD9F5),
                          Color(0xFF29B6E8),
                        ],
                        center: Alignment(-0.3, -0.4),
                        focal: Alignment(-0.3, -0.4),
                        focalRadius: 0.1,
                        radius: 1.0,
                      ),
                border: Border.all(
                  color: (isDarkMode ? Colors.grey[600]! : Colors.white).withValues(alpha: 0.7),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDarkMode ? _AeroPalette.darkSkyMid : _AeroPalette.skyMid).withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.water_drop_rounded,
                color: isDarkMode ? _AeroPalette.darkSkyMid : _AeroPalette.skyTop,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frutiger Aero',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[200] : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      letterSpacing: 0.3,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Adéntrate en el mundo digital',
                    style: TextStyle(
                      color: (isDarkMode ? Colors.grey[400] : Colors.white),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Destellos decorativos
            Column(
              children: [
                _GlossOrb(size: 10, opacity: 0.6, isDarkMode: isDarkMode),
                const SizedBox(height: 6),
                _GlossOrb(size: 7, opacity: 0.4, isDarkMode: isDarkMode),
                const SizedBox(height: 4),
                _GlossOrb(size: 5, opacity: 0.3, isDarkMode: isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Pequeños orbes decorativos
class _GlossOrb extends StatelessWidget {
  final double size;
  final double opacity;
  final bool isDarkMode;
  const _GlossOrb({required this.size, required this.opacity, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (isDarkMode ? Colors.grey[400]! : Colors.white).withValues(alpha: opacity),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.grey[600]! : Colors.white).withValues(alpha: opacity * 0.5),
            blurRadius: size,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

// ─── Grid de tarjetas ───────────────────────────────────────────────────────
class _DomusMatrix extends StatelessWidget {
  final bool isDarkMode;
  const _DomusMatrix({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final crossAxisCount = w > 900 ? 4 : w > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: appMenuItems.length,
      itemBuilder: (context, index) {
        return _AeroCard(
          menuItem: appMenuItems[index], 
          index: index,
          isDarkMode: isDarkMode,
        );
      },
    );
  }
}

// ─── Tarjeta individual Aero ────────────────────────────────────────────────
class _AeroCard extends StatefulWidget {
  final MenuItem menuItem;
  final int index;
  final bool isDarkMode;
  const _AeroCard({required this.menuItem, required this.index, required this.isDarkMode});

  @override
  State<_AeroCard> createState() => _AeroCardState();
}

class _AeroCardState extends State<_AeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<Color> get _gradient {
    return _AeroPalette.getCardGradient(widget.index, widget.isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          context.push(widget.menuItem.link);
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (widget.isDarkMode ? Colors.grey[700]! : Colors.white).withValues(alpha: 0.45),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _gradient[0].withValues(alpha: widget.isDarkMode ? 0.25 : 0.45),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: widget.isDarkMode ? 0.2 : 0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Reflejo gloss superior
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: widget.isDarkMode ? 0.08 : 0.28),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Burbuja decorativa en esquina
                Positioned(
                  right: -18,
                  bottom: -18,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: widget.isDarkMode ? 0.03 : 0.10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: widget.isDarkMode ? 0.08 : 0.18),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                // Contenido
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icono en contenedor glass
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: widget.isDarkMode ? 0.12 : 0.22),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: widget.isDarkMode ? 0.3 : 0.5),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          widget.menuItem.icon,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                      // Textos
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.menuItem.titulus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.menuItem.subtitulus,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: widget.isDarkMode ? 0.7 : 0.78),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
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