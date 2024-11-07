import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_partouche_app/pages/puzzle_game_page.dart';

class PuzzleGamePage extends StatelessWidget {
  final List<PuzzleGame> puzzles = [
    PuzzleGame(imageUrl: 'images/image1.png', title: 'Eiffel Tower Day'),
    PuzzleGame(imageUrl: 'images/image2.png', title: 'Eiffel Tower Close-up'),
    PuzzleGame(imageUrl: 'images/image3.png', title: 'Eiffel Tower Night'),
    PuzzleGame(imageUrl: 'images/image4.png', title: 'Eiffel Tower Olympics'),
    PuzzleGame(imageUrl: 'images/image5.png', title: 'Eiffel Tower Sunrise'),
  ];

  PuzzleGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Puzzle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: puzzles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final puzzle = puzzles[index];
            return PuzzleCard(
              imageUrl: puzzle.imageUrl,
              title: puzzle.title,
              onTap: () async {
                await Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => PuzzleWidget(
                      imageAssetPath: puzzle.imageUrl,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PuzzleGame {
  final String imageUrl;
  final String title;

  PuzzleGame({required this.imageUrl, required this.title});
}

class PuzzleCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onTap;

  const PuzzleCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onTap,
                    child: const Text(
                      'Play',
                      style: TextStyle(color: Colors.white),
                    ),
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
