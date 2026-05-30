import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ─── Animales y sus APIs gratuitas ───────────────────────────────────────────
enum _Animal { perro, gato, conejo }

const _animalIcons = {
  _Animal.perro:  Icons.pets,
  _Animal.gato:   Icons.cruelty_free,
  _Animal.conejo: Icons.nature,
};

const _animalLabels = {
  _Animal.perro:  'Perro',
  _Animal.gato:   'Gato',
  _Animal.conejo: 'Conejo',
};

Future<String> _fetchImageUrl(_Animal animal) async {
  switch (animal) {
    case _Animal.perro:
      final res = await http.get(
        Uri.parse('https://api.thedogapi.com/v1/images/search'),
      );
      if (res.statusCode != 200) throw Exception('Error Dog API');
      final data = jsonDecode(res.body) as List<dynamic>;
      return data[0]['url'] as String;

    case _Animal.gato:
      final res = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search'),
      );
      if (res.statusCode != 200) throw Exception('Error Cat API');
      final data = jsonDecode(res.body) as List<dynamic>;
      return data[0]['url'] as String;

    case _Animal.conejo:
      // Unsplash random — no necesita clave, añade timestamp para evitar caché
      final ts = DateTime.now().millisecondsSinceEpoch;
      return 'https://source.unsplash.com/random/800x600/?rabbit&t=$ts';
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class AnimalScreen extends StatefulWidget {
  const AnimalScreen({super.key});

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen>
    with SingleTickerProviderStateMixin {

  String?  _imageUrl;
  _Animal? _animal;
  String?  _error;
  bool     _loading = true;

  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _buscarAnimal();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _buscarAnimal() async {
    setState(() { _loading = true; _error = null; _imageUrl = null; });
    _fadeCtrl.reset();

    // Elegir animal aleatorio
    final animal = _Animal.values[Random().nextInt(_Animal.values.length)];

    try {
      final url = await _fetchImageUrl(animal);
      setState(() {
        _imageUrl = url;
        _animal   = animal;
        _loading  = false;
      });
      _fadeCtrl.forward();
    } catch (e) {
      setState(() {
        _error   = e.toString();
        _animal  = animal;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Animal del día',
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
            padding: const EdgeInsets.only(right: 12),
            child: _GlassButton(
              icon: Icons.refresh_rounded,
              onTap: _buscarAnimal,
            ),
          ),
        ],
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
            _bubble(left: -40,  top: 80,     size: 180, opacity: 0.12),
            _bubble(right: -60, top: 250,    size: 220, opacity: 0.09),
            _bubble(left: 30,   bottom: 100, size: 160, opacity: 0.10),
            SafeArea(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return _LoadingView(animal: _animal);
    if (_error != null) return _ErrorView(error: _error!, onRetry: _buscarAnimal);
    return _ResultView(
      imageUrl:  _imageUrl!,
      animal:    _animal!,
      fadeAnim:  _fadeAnim,
      onRefresh: _buscarAnimal,
    );
  }

  static Widget _bubble({
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
          border: Border.all(
            color: Colors.white.withOpacity(0.18), width: 1.5,
          ),
        ),
      ),
    );
  }
}

// ─── Vista de carga ───────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  final _Animal? animal;
  const _LoadingView({this.animal});

  @override
  Widget build(BuildContext context) {
    final label = animal != null
        ? 'Buscando un ${_animalLabels[animal!]!.toLowerCase()}...'
        : 'Eligiendo animal...';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 110, height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Colors.white, Color(0xFF7DD9F5), Color(0xFF1B9FD8)],
                center: Alignment(-0.3, -0.4),
                focal:  Alignment(-0.3, -0.4),
                focalRadius: 0.1,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.7), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF29B6E8).withOpacity(0.5),
                  blurRadius: 30, spreadRadius: 8,
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0A5A8A), strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: LinearProgressIndicator(
                backgroundColor: Colors.white.withOpacity(0.20),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
                minHeight: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Vista de resultado ───────────────────────────────────────────────────────
class _ResultView extends StatelessWidget {
  final String            imageUrl;
  final _Animal           animal;
  final Animation<double> fadeAnim;
  final VoidCallback      onRefresh;

  const _ResultView({
    required this.imageUrl,
    required this.animal,
    required this.fadeAnim,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            // Badge del animal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.white.withOpacity(0.45), width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_animalIcons[animal], color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _animalLabels[animal]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta imagen
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.45), width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 20, offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(27),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.white.withOpacity(0.7),
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _animalIcons[animal],
                                color: Colors.white54, size: 48,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No se pudo cargar la imagen',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Reflejo gloss
                      Positioned(
                        top: 0, left: 0, right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.22),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botón buscar otro
            GestureDetector(
              onTap: onRefresh,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF60D0F0), Color(0xFF1B8FD0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6), width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1B9FD8).withOpacity(0.45),
                      blurRadius: 14, offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shuffle_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Buscar otro animal',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.3,
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
}

// ─── Vista de error ───────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String       error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.40), width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  color: Colors.white70, size: 48),
              const SizedBox(height: 16),
              const Text(
                'No se pudo obtener la imagen',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.70), fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF60D0F0), Color(0xFF1B8FD0)],
                    ),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5), width: 1,
                    ),
                  ),
                  child: const Text(
                    'Reintentar',
                    style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Botón glass ──────────────────────────────────────────────────────────────
class _GlassButton extends StatelessWidget {
  final IconData     icon;
  final VoidCallback onTap;
  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.5), width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}