import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/home_screen.dart';
import 'package:tic_tac_toe/screens/multiplayer_game_screen.dart';
import 'package:tic_tac_toe/screens/single_player_game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        SinglePlayerGameScreen.routeName: (ctx) =>
            const SinglePlayerGameScreen(),
        MultiplayerGameScreen.routeName: (ctx) => const MultiplayerGameScreen(),
      },
    );
  }
}
