// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> _board;
  late String _currentPlayer;
  String _winner = '';
  bool _gameOver = false;

  // Define player colors
  final Color _playerOneColor = Colors.green;
  final Color _playerTwoColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    _board = List.generate(
        3, (_) => List.filled(3, '')); // Reset the board to empty strings
    _currentPlayer = 'X'; // Reset the current player to 'X'
    _winner = ''; // Reset the winner
    _gameOver = false; // Reset the game over flag
  }

  void _playMove(int row, int col) {
    if (!_gameOver && _board[row][col].isEmpty) {
      setState(() {
        _board[row][col] = _currentPlayer;
        _checkWinner(row, col);
        _togglePlayer();
      });
    }
  }

  void _checkWinner(int row, int col) {
    // Check row
    if (_board[row][0] == _board[row][1] && _board[row][1] == _board[row][2]) {
      _winner = _board[row][0];
    }
    // Check column
    else if (_board[0][col] == _board[1][col] &&
        _board[1][col] == _board[2][col]) {
      _winner = _board[0][col];
    }
    // Check diagonals
    else if ((row == col || row + col == 2) &&
        ((_board[0][0] == _board[1][1] && _board[1][1] == _board[2][2]) ||
            (_board[0][2] == _board[1][1] && _board[1][1] == _board[2][0]))) {
      _winner = _board[1][1];
    }

    if (_winner.isNotEmpty) {
      _gameOver = true;
    }
  }

  void _togglePlayer() {
    _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
  }

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double fontSize = constraints.maxWidth /
            8; // Adjust the font size based on the width of the grid
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            final int row = index ~/ 3;
            final int col = index % 3;
            // Set text color based on the value in the cell
            Color textColor = _board[row][col] == 'X'
                ? _playerOneColor
                : (_board[row][col] == 'O' ? _playerTwoColor : Colors.black);
            return GestureDetector(
              onTap: () => _playMove(row, col),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    _board[row][col],
                    style: TextStyle(fontSize: fontSize, color: textColor),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGrid(),
              const SizedBox(height: 20.0),
              _gameOver
                  ? Text('Winner: $_winner', style: const TextStyle(fontSize: 24.0))
                  : Text('Current Player: $_currentPlayer',
                      style: const TextStyle(fontSize: 24.0)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _initializeBoard();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
