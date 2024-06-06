import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  List<int> tileNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slide Puzzle'),
        actions: [
          IconButton(
              onPressed: () => reset(), icon: const Icon(Icons.reset_tv)),
          IconButton(
            onPressed: () => loadTileNumbers(),
            icon: const Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: () => saveTileNumbers(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(tileNumbers.toString()),
            Expanded(
              child: Center(
                child: TilesView(
                  numbers: tileNumbers,
                  isCorrect: calcIsCorrect(tileNumbers),
                  onPressed: (number) => swapTile(number),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                  onPressed: () => shuffleTiles(),
                  icon: const Icon(Icons.shuffle),
                  label: const Text('Shuffle')),
            ),
          ],
        ),
      ),
    );
  }

  void saveTileNumbers() async {
    final value = jsonEncode(tileNumbers);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('TILE_NUMBERS', value);
  }

  void loadTileNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('TILE_NUMBERS');
    if (value != null) {
      final numbers =
          (jsonDecode(value) as List<dynamic>).map((v) => v as int).toList();
      setState(() {
        tileNumbers = tileNumbers = numbers;
      });
    }
  }

  bool calcIsCorrect(List<int> numbers) {
    final correctNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 0];
    for (int i = 0; i < numbers.length; i++) {
      if (numbers[i] != correctNumbers[i]) {
        return false;
      }
    }
    return true;
  }

  void swapTile(int number) {
    if (canSwapTile(number)) {
      setState(() {
        final indexOfTile = tileNumbers.indexOf(number);
        final indexOfEmpty = tileNumbers.indexOf(0);
        tileNumbers[indexOfTile] = 0;
        tileNumbers[indexOfEmpty] = number;
      });
    }
  }

  bool canSwapTile(int number) {
    final indexOfTile = tileNumbers.indexOf(number);
    final indexOfEmpty = tileNumbers.indexOf(0);
    switch (indexOfEmpty) {
      case 0:
        return [1, 3].contains(indexOfTile);
      case 1:
        return [0, 2, 4].contains(indexOfTile);
      case 2:
        return [1, 5].contains(indexOfTile);
      case 3:
        return [0, 4, 6].contains(indexOfTile);
      case 4:
        return [1, 3, 5, 7].contains(indexOfTile);
      case 5:
        return [2, 4, 8].contains(indexOfTile);
      case 6:
        return [3, 7].contains(indexOfTile);
      case 7:
        return [4, 6, 8].contains(indexOfTile);
      case 8:
        return [5, 7].contains(indexOfTile);
      default:
        return false;
    }
  }

  void reset() {
    setState(() {
      tileNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 0];
    });
  }

  void shuffleTiles() async {
    int count = 0;

    while (count < 100) {
      int randomIndex = Random().nextInt(8);
      if (canSwapTile(randomIndex)) {
        await Future.delayed(Duration(milliseconds: 10));
        swapTile(randomIndex);
        count++;
      }
    }
  }
}

class TilesView extends StatelessWidget {
  final List<int> numbers;
  final bool isCorrect;
  final void Function(int number) onPressed;

  const TilesView(
      {required this.numbers,
      required this.isCorrect,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: numbers.map((number) {
        if (number == 0) {
          return Container();
        }
        return TileView(
          number: number,
          color: isCorrect ? Colors.green : Colors.blue,
          onPressed: () => onPressed(number),
        );
      }).toList(),
    );
  }
}

class TileView extends StatelessWidget {
  final int number;
  final Color color;
  final void Function() onPressed;

  const TileView({
    Key? key,
    required this.number,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(fontSize: 32),
      ),
      child: Center(
        child: Text('$number'),
      ),
    );
  }
}
