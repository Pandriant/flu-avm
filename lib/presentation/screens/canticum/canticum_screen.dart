import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/legacy.dart';

// ============================================================
// PROVIDERS
// ============================================================

class PlaybackState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final String currentSong;
  final String currentSongUrl;
  final bool isLoading;
  final String? error;

  PlaybackState({
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.currentSong,
    required this.currentSongUrl,
    required this.isLoading,
    this.error,
  });

  PlaybackState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    String? currentSong,
    String? currentSongUrl,
    bool? isLoading,
    String? error,
  }) {
    return PlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      currentSong: currentSong ?? this.currentSong,
      currentSongUrl: currentSongUrl ?? this.currentSongUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PlaybackNotifier extends StateNotifier<PlaybackState> {
  PlaybackNotifier() : super(PlaybackState(
    isPlaying: false,
    position: Duration.zero,
    duration: Duration.zero,
    currentSong: 'Selecciona una canción',
    currentSongUrl: '',
    isLoading: false,
    error: null,
  ));

  Future<void> playSong(String url, String title) async {
    try {
      print('🎵 Abriendo: $title');
      print('🔗 URL: $url');
      
      state = state.copyWith(isLoading: true, error: null);
      
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri, 
          mode: LaunchMode.externalApplication,
        );
        state = state.copyWith(
          isPlaying: true,
          currentSong: title,
          currentSongUrl: url,
          isLoading: false,
          error: null,
        );
        print('✅ Navegador abierto para: $title');
      } else {
        throw Exception('No se puede abrir la URL: $url');
      }
      
    } catch (e) {
      print('❌ Error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'No se pudo abrir: $title',
      );
    }
  }

  Future<void> playPause() async {
    // Mostrar mensaje informativo
    print('ℹ️ Use los controles del navegador para pausar/reanudar');
  }

  Future<void> stop() async {
    print('ℹ️ Cierre el navegador para detener la reproducción');
    state = state.copyWith(isPlaying: false);
  }

  Future<void> seekTo(Duration position) async {
    print('ℹ️ Use los controles del navegador para buscar');
  }
}

final playbackProvider = StateNotifierProvider<PlaybackNotifier, PlaybackState>((ref) {
  return PlaybackNotifier();
});

// ============================================================
// PALETA DE COLORES AERO
// ============================================================

class _AeroPalette {
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
}

// ============================================================
// CANCIONES DE EJEMPLO
// ============================================================

class SongItem {
  final String title;
  final String artist;
  final String url;
  final Duration duration;

  SongItem({
    required this.title,
    required this.artist,
    required this.url,
    this.duration = const Duration(seconds: 180),
  });
}

final List<SongItem> availableSongs = [
  SongItem(
    title: 'Aura Digital', 
    artist: 'Frutiger Aero', 
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  ),
  SongItem(
    title: 'Sueños de Cristal', 
    artist: 'Nebula', 
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  ),
  SongItem(
    title: 'Horizonte Líquido', 
    artist: 'Waveform', 
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  ),
  SongItem(
    title: 'Espíritu Digital', 
    artist: 'Cyber Pulse', 
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  ),
  SongItem(
    title: 'Resplandor', 
    artist: 'Luminous', 
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
  ),
  SongItem(
    title: 'Nebulosa', 
    artist: 'Stellar Drift', 
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
  ),
];

// ============================================================
// WIDGETS
// ============================================================

class _AeroBubble extends StatelessWidget {
  final double? left, right, top, bottom, size, opacity;
  const _AeroBubble({this.left, this.right, this.top, this.bottom, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left, right: right, top: top, bottom: bottom,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(opacity! * 1.5),
              Colors.white.withOpacity(opacity! * 0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final bool hasGlow;

  const _GlassButton({
    required this.icon,
    required this.onTap,
    this.size = 60,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
          boxShadow: hasGlow
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.45,
        ),
      ),
    );
  }
}

class _AudioVisualizer extends StatelessWidget {
  final bool isPlaying;
  const _AudioVisualizer({required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(20, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: isPlaying ? 150 + index * 10 : 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 4,
                height: isPlaying ? (15 + Random().nextInt(40)).toDouble() : 15,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.3)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MainPlayer extends StatelessWidget {
  final PlaybackState playbackState;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;

  const _MainPlayer({
    required this.playbackState,
    required this.onPlayPause,
    required this.onStop,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  colors: [Color(0xFF29B6E8), Color(0xFF0A7EC2), Color(0xFF0A2E4A)],
                  center: Alignment(0.3, 0.3),
                  radius: 0.8,
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF29B6E8).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.audiotrack, size: 60, color: Colors.white70),
                  ),
                  if (playbackState.isPlaying)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.transparent,
                            ],
                            radius: 0.5,
                          ),
                        ),
                      ),
                    ),
                  if (playbackState.isLoading)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  playbackState.currentSong,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Frutiger Aero',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Mensaje informativo
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.white.withOpacity(0.7), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'La música se abrirá en tu navegador',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Botones de control
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GlassButton(
                    icon: Icons.open_in_browser_rounded,
                    onTap: () {
                      if (playbackState.currentSongUrl.isNotEmpty) {
                        final uri = Uri.parse(playbackState.currentSongUrl);
                        canLaunchUrl(uri).then((canLaunch) {
                          if (canLaunch) launchUrl(uri, mode: LaunchMode.externalApplication);
                        });
                      }
                    },
                    size: 50,
                  ),
                  const SizedBox(width: 20),
                  _GlassButton(
                    icon: playbackState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    onTap: onPlayPause,
                    size: 70,
                    hasGlow: true,
                  ),
                  const SizedBox(width: 20),
                  _GlassButton(
                    icon: Icons.stop_rounded,
                    onTap: onStop,
                    size: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistTile extends StatelessWidget {
  final SongItem song;
  final bool isPlaying;
  final int index;
  final VoidCallback onTap;

  const _PlaylistTile({
    required this.song,
    required this.isPlaying,
    required this.index,
    required this.onTap,
  });

  List<Color> get _gradient {
    final gradients = _AeroPalette.cardGradients;
    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPlaying ? [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.15)] : _gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPlaying ? Colors.white.withOpacity(0.7) : Colors.white.withOpacity(0.35),
              width: isPlaying ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _gradient[0].withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
                ),
                child: Center(
                  child: isPlaying
                      ? const Icon(Icons.equalizer_rounded, color: Colors.white, size: 20)
                      : Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isPlaying ? FontWeight.bold : FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      song.artist,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isPlaying)
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.25),
                  ),
                  child: const Icon(Icons.play_circle_rounded, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaylistSection extends StatelessWidget {
  final List<SongItem> songs;
  final String currentSongTitle;
  final Function(SongItem) onSongSelected;

  const _PlaylistSection({
    required this.songs,
    required this.currentSongTitle,
    required this.onSongSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.queue_music_rounded, 
                    color: Colors.white.withOpacity(0.9), 
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Lista de reproducción',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isPlaying = song.title == currentSongTitle;
                  return _PlaylistTile(
                    song: song,
                    isPlaying: isPlaying,
                    index: index,
                    onTap: () => onSongSelected(song),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PANTALLA PRINCIPAL
// ============================================================

class CanticumScreen extends ConsumerStatefulWidget {
  const CanticumScreen({super.key});

  @override
  ConsumerState<CanticumScreen> createState() => _CanticumScreenState();
}

class _CanticumScreenState extends ConsumerState<CanticumScreen> {
  @override
  Widget build(BuildContext context) {
    final playbackState = ref.watch(playbackProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Canticum',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
            shadows: [Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_AeroPalette.grad1, _AeroPalette.grad2, _AeroPalette.grad3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _AeroBubble(left: -40, top: 80, size: 180, opacity: 0.12),
            _AeroBubble(right: -60, top: 200, size: 220, opacity: 0.10),
            _AeroBubble(left: 30, bottom: 120, size: 150, opacity: 0.09),
            _AeroBubble(right: 20, bottom: 300, size: 130, opacity: 0.08),
            _AeroBubble(left: -20, top: 400, size: 100, opacity: 0.07),
            
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _AudioVisualizer(isPlaying: playbackState.isPlaying),
                  const SizedBox(height: 20),
                  _MainPlayer(
                    playbackState: playbackState,
                    onPlayPause: () => ref.read(playbackProvider.notifier).playPause(),
                    onStop: () => ref.read(playbackProvider.notifier).stop(),
                  ),
                  const SizedBox(height: 20),
                  _PlaylistSection(
                    songs: availableSongs,
                    currentSongTitle: playbackState.currentSong,
                    onSongSelected: (song) {
                      // Mostrar diálogo de confirmación
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: const Color(0xFF1A5580),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text(
                            'Abrir en navegador',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            '¿Reproducir "${song.title}" en tu navegador?',
                            style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                ref.read(playbackProvider.notifier).playSong(song.url, song.title);
                              },
                              child: const Text('Abrir', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}