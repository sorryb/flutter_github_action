
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() =>
      _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  final List<String> board = List.filled(9, '');

  String current = 'X';
  String? winner;
  bool draw = false;

  int xWins = 0;
  int oWins = 0;
  int draws = 0;

  List<int> winningLine = [];

  static const lines = <List<int>>[
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  void play(int index) {
    if (board[index].isNotEmpty ||
        winner != null ||
        draw) {
      return;
    }

    setState(() {
      board[index] = current;

      for (final line in lines) {
        if (line.every((i) => board[i] == current)) {
          winner = current;
          winningLine = line;

          if (current == 'X') {
            xWins++;
          } else {
            oWins++;
          }
          return;
        }
      }

      if (board.every((cell) => cell.isNotEmpty)) {
        draw = true;
        draws++;
      } else {
        current = current == 'X' ? 'O' : 'X';
      }
    });
  }

  void resetBoard() {
    setState(() {
      board.fillRange(0, board.length, '');
      current = 'X';
      winner = null;
      draw = false;
      winningLine = [];
    });
  }

  void resetScores() {
    setState(() {
      xWins = 0;
      oWins = 0;
      draws = 0;

      board.fillRange(0, board.length, '');
      current = 'X';
      winner = null;
      draw = false;
      winningLine = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0B1020);
    const xColor = Color(0xFF50E3C2);
    const oColor = Color(0xFFFFB86B);

    final status = winner != null
        ? 'Player $winner wins!'
        : draw
            ? "It's a draw!"
            : "Player $current's turn";

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 650;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Column(
                children: [
                  Text(
                    'TIC TAC TOE',
                    style: TextStyle(
                      fontSize: compact ? 25 : 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: compact ? 10 : 22),

                  Row(
                    children: [
                      _scoreCard(
                        'PLAYER X',
                        xWins,
                        xColor,
                      ),
                      const SizedBox(width: 10),
                      _scoreCard(
                        'DRAWS',
                        draws,
                        Colors.white70,
                      ),
                      const SizedBox(width: 10),
                      _scoreCard(
                        'PLAYER O',
                        oWins,
                        oColor,
                      ),
                    ],
                  ),

                  SizedBox(height: compact ? 12 : 25),

                  Text(
                    status,
                    style: TextStyle(
                      fontSize: compact ? 19 : 23,
                      fontWeight: FontWeight.bold,
                      color: winner == 'X'
                          ? xColor
                          : winner == 'O'
                              ? oColor
                              : Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GridView.builder(
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: 9,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final mark = board[index];
                            final highlighted =
                                winningLine.contains(index);

                            return Material(
                              color: highlighted
                                  ? const Color(0xFF263E4A)
                                  : const Color(0xFF1A2540),
                              borderRadius:
                                  BorderRadius.circular(18),
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(18),
                                onTap: () => play(index),
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      mark,
                                      style: TextStyle(
                                        fontSize: 76,
                                        fontWeight:
                                            FontWeight.w900,
                                        color: mark == 'X'
                                            ? xColor
                                            : oColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: resetBoard,
                      icon: const Icon(
                        Icons.refresh_rounded,
                      ),
                      label: const Text(
                        'NEW GAME',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: xColor,
                        foregroundColor: bg,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: resetScores,
                    child: const Text(
                      'Reset scoreboard',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _scoreCard(
    String title,
    int score,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2540),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '$score',
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
