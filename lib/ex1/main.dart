import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GridPage(),
    );
  }
}

class GridPage extends StatelessWidget {
  const GridPage({super.key});

  static const List<Map<String, String>> places = [
    {
      'title': 'Chennai\nFlower Market',
      'url':
          'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=400',
    },
    {
      'title': 'Tanjore\nBronze Works',
      'url':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    },
    {
      'title': 'Tanjore\nMarket',
      'url':
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400',
    },
    {
      'title': 'Tanjore\nThanjavur Temple',
      'url':
          'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=400',
    },
    {
      'title': 'Tanjore\nThanjavur Temple',
      'url':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    },
    {
      'title': 'Pondicherry\nSalt Farm',
      'url':
          'https://images.unsplash.com/photo-1516912481808-3406841bd33c?w=400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GridView')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  places[index]['url']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 48),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
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
                    child: Text(
                      places[index]['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
