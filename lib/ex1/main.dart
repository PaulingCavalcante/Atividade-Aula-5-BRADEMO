import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GridView – Imagens Aleatórias',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const GridPage(),
    );
  }
}

class PicsumPhoto {
  final String id;
  final String author;

  const PicsumPhoto({required this.id, required this.author});

  factory PicsumPhoto.fromJson(Map<String, dynamic> json) {
    return PicsumPhoto(
      id: json['id'].toString(),
      author: json['author'] as String,
    );
  }

  String get thumbUrl => 'https://picsum.photos/id/$id/400/400';
}

class PicsumService {
  static Future<List<PicsumPhoto>> fetchRandom({int count = 6}) async {
    final page = DateTime.now().millisecondsSinceEpoch % 10 + 1;
    final uri = Uri.parse(
      'https://picsum.photos/v2/list?page=$page&limit=20',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Erro ${response.statusCode} ao buscar imagens');
    }

    final List<dynamic> data = jsonDecode(response.body);
    final photos = data.map((j) => PicsumPhoto.fromJson(j)).toList();
    photos.shuffle();
    return photos.take(count).toList();
  }
}

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  late Future<List<PicsumPhoto>> _future;

  @override
  void initState() {
    super.initState();
    _future = PicsumService.fetchRandom();
  }

  void _reload() => setState(() => _future = PicsumService.fetchRandom());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView – Picsum API'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Novas imagens',
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<PicsumPhoto>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'Erro ao carregar imagens.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final photos = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) =>
                _PhotoCard(photo: photos[index]),
          );
        },
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final PicsumPhoto photo;
  const _PhotoCard({required this.photo});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            photo.thumbUrl,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image,
                  size: 48, color: Colors.grey),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Photo #${photo.id}',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    photo.author,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}