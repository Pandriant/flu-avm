import '../../services/ncs_service.dart';
import 'package:flutter_riverpod/legacy.dart';

// Estado del catálogo de canciones
class CanticumCatalogState {
  final List<SongItem> songs;
  final bool isLoading;
  final String? error;
  final String currentCategory;

  CanticumCatalogState({
    this.songs = const [],
    this.isLoading = false,
    this.error,
    this.currentCategory = 'Aleatorio',
  });

  CanticumCatalogState copyWith({
    List<SongItem>? songs,
    bool? isLoading,
    String? error,
    String? currentCategory,
  }) {
    return CanticumCatalogState(
      songs: songs ?? this.songs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentCategory: currentCategory ?? this.currentCategory,
    );
  }
}

// Notifier para manejar la lógica del catálogo
class CanticumCatalogNotifier extends StateNotifier<CanticumCatalogState> {
  CanticumCatalogNotifier() : super(CanticumCatalogState());

  Future<void> loadRandomSongs() async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null);
    try {
      final randomSongs = await NCSService.getRandomSongs(limit: 20);
      state = state.copyWith(
        songs: randomSongs,
        isLoading: false,
        currentCategory: 'Aleatorio',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadSongsByGenre(String genre) async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null);
    try {
      final genreSongs = await NCSService.searchSongsByGenre(genre, limit: 20);
      state = state.copyWith(
        songs: genreSongs,
        isLoading: false,
        currentCategory: genre,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ✅ CORREGIDO: Sin 'const' y con sintaxis correcta
  Future<void> loadTrendingSongs() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final trendingSongs = await NCSService.getTrendingSongs(limit: 20);
      state = state.copyWith(
        songs: trendingSongs,
        isLoading: false,
        currentCategory: 'Tendencias',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void refreshSongs() {
    if (state.currentCategory == 'Aleatorio') {
      loadRandomSongs();
    } else if (state.currentCategory == 'Tendencias') {
      loadTrendingSongs();
    } else {
      loadSongsByGenre(state.currentCategory);
    }
  }
}

// Provider para el catálogo
final canticumCatalogProvider = StateNotifierProvider<CanticumCatalogNotifier, CanticumCatalogState>((ref) {
  return CanticumCatalogNotifier();
});