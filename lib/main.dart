import 'package:flutter/material.dart';

import 'puzzle_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyFirstApp());
}

class MyFirstApp extends StatelessWidget {
  const MyFirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Slide Puzzle',
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => showPuzzlePage(context),
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

  void showPuzzlePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PuzzlePage()),
    );
  }
}
