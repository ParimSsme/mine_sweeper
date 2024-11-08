import '../models/board_square.dart';
import 'dart:math';

class GameRepository {
  final int maxProbability;
  late final int rowCount;
  late final int columnCount;
  late final int bombProbability;

  GameRepository({this.maxProbability = 15});

  List<List<BoardSquare>> initializeBoard({
    required int bombCount,
    required int rowCount,
    required int columnCount,
  }) {
    this.rowCount = rowCount;
    this.columnCount = columnCount;
    bombProbability = bombCount;

    // Initialize the board with empty squares
    List<List<BoardSquare>> board = List.generate(rowCount, (_) {
      return List.generate(columnCount, (_) => BoardSquare());
    });

    _placeBombs(board);
    _calculateBombsAround(board);

    return board;
  }

  void _placeBombs(List<List<BoardSquare>> board) {
    Random random = Random();
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (random.nextInt(maxProbability) < bombProbability) {
          board[i][j].hasBomb = true;
        }
      }
    }
  }

  void _calculateBombsAround(List<List<BoardSquare>> board) {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (!board[i][j].hasBomb) {
          board[i][j].bombsAround = _countBombsAround(i, j, board);
        }
      }
    }
  }

  int _countBombsAround(int row, int col, List<List<BoardSquare>> board) {
    int count = 0;
    for (int i = row - 1; i <= row + 1; i++) {
      for (int j = col - 1; j <= col + 1; j++) {
        if (_isInBounds(i, j) && board[i][j].hasBomb) {
          count++;
        }
      }
    }
    return count;
  }

  bool _isInBounds(int row, int col) {
    return row >= 0 && row < rowCount && col >= 0 && col < columnCount;
  }
}
