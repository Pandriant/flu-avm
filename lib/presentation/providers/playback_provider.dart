import 'package:url_launcher/url_launcher.dart';
import '../../services/ncs_service.dart';
import 'package:flutter_riverpod/legacy.dart';

class PlaybackState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final SongItem? currentSong;
  final bool isLoading;
  final String? error;

  PlaybackState({
    required this.isPlaying,
    required this.position,
    required this.duration,
    this.currentSong,
    required this.isLoading,
    this.error,
  });

  PlaybackState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    SongItem? currentSong,
    bool? isLoading,
    String? error,
  }) {
    return PlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      currentSong: currentSong ?? this.currentSong,
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
    currentSong: null,
    isLoading: false,
    error: null,
  ));

  Future<void> playSong(SongItem song) async {
    try {
      print('🎵 Abriendo: ${song.title}');
      print('🔗 URL: ${song.url}');
      
      state = state.copyWith(isLoading: true, error: null, currentSong: song);
      
      final url = Uri.parse(song.url);
      
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url, 
          mode: LaunchMode.externalApplication, // Abre en navegador externo
        );
        state = state.copyWith(isPlaying: true, isLoading: false);
        print('✅ Navegador abierto');
      } else {
        throw Exception('No se puede abrir la URL');
      }
      
    } catch (e) {
      print('❌ Error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'No se pudo abrir: ${song.title}',
      );
    }
  }

  Future<void> playPause() async {
    // No necesario con url_launcher
    print('ℹ️ Use los controles del navegador');
  }

  Future<void> stop() async {
    // No necesario con url_launcher
    print('ℹ️ Cierre el navegador para detener');
  }

  Future<void> seekTo(Duration position) async {
    // No necesario con url_launcher
    print('ℹ️ Use los controles del navegador');
  }
}

final playbackProvider = StateNotifierProvider<PlaybackNotifier, PlaybackState>((ref) {
  return PlaybackNotifier();
}); 
