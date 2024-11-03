import 'package:get/get.dart';
import '../../data/models/board_square.dart';
import '../../domain/usecases/initialize_game.dart';

class GameController extends GetxController {
  final InitializeGame initializeGame;

  GameController({required this.initializeGame});

  var board = <List<BoardSquare>>[].obs;
  var revealedSquares = <bool>[].obs;
  var bombCount = 0.obs;
  var squaresLeft = 0.obs;

  int rowCount = 18;
  int columnCount = 10;

  @override
  void onInit() {
    super.onInit();
    startNewGame();
  }

  void startNewGame() {
    board.value = initializeGame();
    revealedSquares.value = List.generate(rowCount * columnCount, (_) => false);
    bombCount.value = board.expand((row) => row).where((square) => square.hasBomb).length;
    squaresLeft.value = rowCount * columnCount;
  }

  void handleTap(int position) {
    int rowNumber = (position / columnCount).floor();
    int columnNumber = position % columnCount;

    if (board[rowNumber][columnNumber].hasBomb) {
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
    startNewGame();
  }

  void handleWin() {
    Get.snackbar("Congratulations", "You win!");
    startNewGame();
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

