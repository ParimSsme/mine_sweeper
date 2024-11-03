import 'package:get/get.dart';
import '../../data/models/board_square.dart';
import '../../domain/enums/game_state.dart';
import '../../domain/usecases/initialize_game.dart';

class GameController extends GetxController {
  final InitializeGame initializeGame;

  GameController({required this.initializeGame});

  var board = <List<BoardSquare>>[].obs;
  var revealedSquares = <bool>[].obs;
  var flaggedSquares = <bool>[].obs;
  var bombCount = 0.obs;
  var squaresLeft = 0.obs;

  int rowCount = 18;
  int columnCount = 10;

  var gameState = GameState.ongoing.obs;

  int flagsLeft = 0; // Track remaining flags

  @override
  void onInit() {
    super.onInit();
    startNewGame();
  }

  void startNewGame() {
    board.value = initializeGame();
    revealedSquares.value = List.generate(rowCount * columnCount, (_) => false);
    flaggedSquares.value = List.generate(rowCount * columnCount, (_) => false);
    bombCount.value = board.expand((row) => row).where((square) => square.hasBomb).length;
    squaresLeft.value = rowCount * columnCount;
    flagsLeft = bombCount.value;
  }


  // Toggle flag on a cell
  void toggleFlag(int position) {
    // if (gameState.value != GameState.ongoing || revealedSquares[position]) return;

    if (flaggedSquares[position]) {
      flaggedSquares[position] = false;
      flagsLeft++;
    } else if (flagsLeft > 0) {
      flaggedSquares[position] = true;
      flagsLeft--;
    }

    update();
  }

  void handleTap(int position) {

    if (gameState.value != GameState.ongoing) return; // Ignore taps if game is over

    int rowNumber = (position / columnCount).floor();
    int columnNumber = position % columnCount;

    if (board[rowNumber][columnNumber].hasBomb) {
      revealedSquares[position] = true;
      handleGameOver();
      return;
    }

    if (board[rowNumber][columnNumber].bombsAround == 0) {
      _revealAdjacentSquares(rowNumber, columnNumber);
    } else {
      revealedSquares[position] = true;
      squaresLeft--;
    }

    if (squaresLeft <= bombCount.value) {
      handleWin();
    }
  }

  void handleGameOver() {
    Get.snackbar("Game Over", "You stepped on a mine!");
    gameState.value = GameState.lost;
    update();
  }

  void handleWin() {
    Get.snackbar("Congratulations", "You win!");
    gameState.value = GameState.won;
    update();
  }

  // Recursive function to reveal adjacent squares
  void _revealAdjacentSquares(int row, int col) {
    // Check if the cell is within bounds
    if (row < 0 || row >= rowCount || col < 0 || col >= columnCount) return;

    int position = row * columnCount + col;

    // If already opened or flagged, skip
    if (revealedSquares[position]) return;

    // Mark the cell as opened
    revealedSquares[position] = true;
    squaresLeft--;

    // If there are bombs around this square, stop recursion
    if (board[row][col].bombsAround > 0) return;

    // Directions for adjacent cells
    List<List<int>> directions = [
      [-1, -1], [-1, 0], [-1, 1], // Top row
      [0, -1], /*Current*/ [0, 1], // Middle row
      [1, -1], [1, 0], [1, 1]     // Bottom row
    ];

    // Recursively reveal neighbors
    for (var direction in directions) {
      int newRow = row + direction[0];
      int newCol = col + direction[1];
      _revealAdjacentSquares(newRow, newCol);
    }

    // Update UI
    update();
  }

}


// class GameController1 extends GetxController {
//   final int rowCount = 18;
//   final int columnCount = 10;
//   late List<List<BoardSquare>> board;
//   late List<bool> openedSquares;
//
//
//   // Track the current state of the game
//   //
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeGame();
//   }
//
//   void _initializeGame() {
//     // Initialize the board with empty squares
//     board = List.generate(rowCount, (_) => List.generate(columnCount, (_) => BoardSquare()));
//
//     // Initialize openedSquares and flaggedSquares lists
//     openedSquares = List.generate(rowCount * columnCount, (_) => false);
//
//
//     // Reset counters
//     bombCount = 10; // Or however many bombs you want to add
//     squaresLeft = rowCount * columnCount - bombCount;
//
//
//     // Set the game state to ongoing
//     gameState.value = GameState.ongoing;
//
//     // Place bombs and calculate adjacent bomb counts
//     // _placeBombs();
//     // _calculateAdjacentBombCounts();
//   }
//
//   // Handle cell tap
//   void handleTap(int position) {
//
//
//     int row = position ~/ columnCount;
//     int col = position % columnCount;
//
//     if (board[row][col].hasBomb) {
//       _handleGameOver();
//     } else if (board[row][col].bombsAround == 0) {
//       _revealAdjacent(row, col); // Reveal adjacent cells recursively
//     } else {
//       openedSquares[position] = true;
//       squaresLeft--;
//       _checkWinCondition();
//     }
//
//     update();
//   }
//
//
//
//   // Check if all non-bomb squares have been opened
//   void _checkWinCondition() {
//     if (squaresLeft <= bombCount) {
//       _handleWin();
//     }
//   }
//
//   // Handle game loss
//   void _handleGameOver() {
//     gameState.value = GameState.lost;
//     update();
//     // Display "Game Over" dialog or message
//   }
//
//   // Handle game win
//   void _handleWin() {
//
//     // Display "You Win" dialog or message
//   }
//
//   // Reveal adjacent cells recursively
//   void _revealAdjacent(int row, int col) {
//     int position = row * columnCount + col;
//     openedSquares[position] = true;
//     squaresLeft--;
//
//     if (board[row][col].bombsAround == 0) {
//       // Reveal adjacent cells if no bombs around
//       for (var (adjRow, adjCol) in _getAdjacentCells(row, col)) {
//         int adjPosition = adjRow * columnCount + adjCol;
//         if (!openedSquares[adjPosition] && !board[adjRow][adjCol].hasBomb) {
//           _revealAdjacent(adjRow, adjCol);
//         }
//       }
//     }
//
//     _checkWinCondition(); // Check if game has been won
//   }
//
//   List<(int, int)> _getAdjacentCells(int row, int col) {
//     final adjacentCells = <(int, int)>[];
//     for (int r = row - 1; r <= row + 1; r++) {
//       for (int c = col - 1; c <= col + 1; c++) {
//         if (r >= 0 && r < rowCount && c >= 0 && c < columnCount && !(r == row && c == col)) {
//           adjacentCells.add((r, c));
//         }
//       }
//     }
//     return adjacentCells;
//   }
// }

