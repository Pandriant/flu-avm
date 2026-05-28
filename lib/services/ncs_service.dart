import 'package:dio/dio.dart';

class SongItem {
  final String id;
  final String title;
  final String artist;
  final String url;
  final String imageUrl;
  final Duration duration;
  final String genre;

  SongItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
    required this.imageUrl,
    required this.duration,
    required this.genre,
  });
}

class NCSService {
  // URLs de música que SÍ funcionan (SoundHelix - música libre)
  static final List<SongItem> _workingSongs = [
    SongItem(
      id: '1',
      title: 'Melodía Clásica',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 180),
      genre: 'Classical',
    ),
    SongItem(
      id: '2',
      title: 'Ritmo Alegre',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 185),
      genre: 'Happy',
    ),
    SongItem(
      id: '3',
      title: 'Piano Relajante',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 175),
      genre: 'Chill',
    ),
    SongItem(
      id: '4',
      title: 'Energía Digital',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 190),
      genre: 'Electronic',
    ),
    SongItem(
      id: '5',
      title: 'Armonía Natural',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 170),
      genre: 'Chill',
    ),
    SongItem(
      id: '6',
      title: 'Viaje Espacial',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 195),
      genre: 'Electronic',
    ),
    SongItem(
      id: '7',
      title: 'Aventura Épica',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 188),
      genre: 'Epic',
    ),
    SongItem(
      id: '8',
      title: 'Luz Brillante',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 182),
      genre: 'Happy',
    ),
    SongItem(
      id: '9',
      title: 'Reflexión Profunda',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 200),
      genre: 'Sad',
    ),
    SongItem(
      id: '10',
      title: 'Romance al Atardecer',
      artist: 'SoundHelix',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
      imageUrl: '',
      duration: const Duration(seconds: 178),
      genre: 'Romantic',
    ),
  ];

  static Future<List<SongItem>> getRandomSongs({int limit = 15}) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mezclar canciones
    final shuffled = List<SongItem>.from(_workingSongs);
    shuffled.shuffle();
    
    return shuffled.take(limit).toList();
  }

  static Future<List<SongItem>> searchSongsByGenre(String genre, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    List<SongItem> filtered;
    
    if (genre == 'Aleatorio' || genre == 'Tendencias') {
      filtered = List<SongItem>.from(_workingSongs);
    } else {
      // Mapeo de géneros
      final genreMap = {
        'Chill': 'Chill',
        'Happy': 'Happy', 
        'Sad': 'Sad',
        'Epic': 'Epic',
        'Romantic': 'Romantic',
        'Party': 'Electronic',
        'Electronic': 'Electronic',
      };
      
      final targetGenre = genreMap[genre];
      filtered = _workingSongs
          .where((song) => song.genre == targetGenre)
          .toList();
    }
    
    if (filtered.isEmpty) {
      filtered = List<SongItem>.from(_workingSongs);
    }
    
    filtered.shuffle();
    return filtered.take(limit).toList();
  }

  static Future<List<SongItem>> getTrendingSongs({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final trending = List<SongItem>.from(_workingSongs);
    return trending.take(limit).toList();
  }
}