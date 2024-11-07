import '../models/board_square.dart';
import 'dart:math';

class GameRepository {
  late final int rowCount;
  late final int columnCount;
  late final int bombProbability;
  final int maxProbability;

  GameRepository({
    this.maxProbability = 15,
  });

  List<List<BoardSquare>> initializeBoard({
    required int bombCount,
    required int rowCount,
    required int columnCount,
  }) {
    List<List<BoardSquare>> board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return BoardSquare();
      });
    });

    bombProbability = bombCount;
    this.rowCount = rowCount;
    this.columnCount = columnCount;
    // Add bombs to the board
    Random random = Random();
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (random.nextInt(maxProbability) < bombProbability) {
          board[i][j].hasBomb = true;
        }
      }
    }

    // Calculate bombs around each cell
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (board[i][j].hasBomb) continue;
        board[i][j].bombsAround = _countBombsAround(i, j, board);
      }
    }
    return board;
  }

  int _countBombsAround(int i, int j, List<List<BoardSquare>> board) {
    int count = 0;
    for (int x = i - 1; x <= i + 1; x++) {
      for (int y = j - 1; y <= j + 1; y++) {
        if (x >= 0 && x < rowCount && y >= 0 && y < columnCount) {
          if (board[x][y].hasBomb) count++;
        }
      }
    }
    return count;
  }
}
