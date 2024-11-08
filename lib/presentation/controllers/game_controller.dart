import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:mine_sweeper/core/routes/app_routes.dart';
import '../../core/services/game_service.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../data/models/board_square.dart';
import '../../domain/enums/game_level.dart';
import '../../domain/enums/game_state.dart';
import '../../domain/usecases/initialize_game.dart';

class GameController extends GetxController {
  static GameController get to => Get.find();

  final InitializeGame initializeGame;

  final ConfettiController confettiController = ConfettiController(duration: const Duration(seconds: 3));
  GameController({required this.initializeGame});

  GameLevel level = GameService.to.getGameLevel;

  var board = <List<BoardSquare>>[].obs;
  var revealedSquares = <bool>[].obs;
  var flaggedSquares = <bool>[].obs;
  var bombCount = 0.obs;
  var squaresLeft = 0.obs;

  late int rowCount = 18;
  late int columnCount = 10;

  // Timer variables
  RxInt elapsedTime = 0.obs; // Elapsed time in seconds
  Timer? _timer;

  var gameState = GameState.ongoing.obs;

  int flagsLeft = 0; // Track remaining flags

  @override
  void onInit() {
    super.onInit();
    startTimer();
    startNewGame();
  }

  void onBackClicked() {
    Get.offNamed(AppRoutes.selectLevel);
  }

  bool isGameEnded () {
    if (gameState.value == GameState.lost || gameState.value == GameState.won) {
      return true;
    }
    return false;
  }

  void startTimer() {
    // Cancel any previous timer if exists
    _timer?.cancel();
    elapsedTime.value = 0;

    // Start a new timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedTime.value++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    stopTimer();
    elapsedTime.value = 0;
  }

  void resetGame(){
    revealedSquares.clear();
    flaggedSquares.clear();
    revealedSquares.refresh();
    flaggedSquares.refresh();

    gameState.value = GameState.ongoing;

    resetTimer();

    startTimer();

    revealedSquares.value = List.generate(rowCount * columnCount, (_) => false);
    flaggedSquares.value = List.generate(rowCount * columnCount, (_) => false);
    squaresLeft.value = rowCount * columnCount;
    flagsLeft = bombCount.value;

  }

  void startNewGame() {

    rowCount = level.rowCount;
    columnCount = level.columnCount;
    bombCount.value = level.bombProbability;

    board.value = initializeGame(
      bombCount: bombCount.value,
      rowCount: rowCount,
      columnCount: columnCount,
    );
    revealedSquares.value = List.generate(rowCount * columnCount, (_) => false);
    flaggedSquares.value = List.generate(rowCount * columnCount, (_) => false);
    squaresLeft.value = rowCount * columnCount;
    flagsLeft = bombCount.value;
  }

  // Toggle flag on a cell
  void toggleFlag(int position) {
    if (gameState.value != GameState.ongoing || revealedSquares[position]) return;

    flaggedSquares[position] = !flaggedSquares[position];
    int row = (position / columnCount).floor();
    int col = position % columnCount;

    if (flaggedSquares[position]) {
      if (board[row][col].hasBomb) {
        bombCount.value--;
      } else {
        squaresLeft.value--;
      }
    } else {
      if (board[row][col].hasBomb) {
        bombCount.value++;
      } else {
        squaresLeft.value++;
      }
    }

    update();
  }

  void handleTap(int position) {
    if (gameState.value != GameState.ongoing || flaggedSquares[position]) {
      return; // Ignore taps if game is over
    }

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
    SnackbarUtils.showErrorSnackbar(title: 'Game Over', 'You stepped on a mine!');
    gameState.value = GameState.lost;
    stopTimer();
    update();
  }

  void handleWin() {
    SnackbarUtils.showSuccessSnackbar(title: 'Congratulations', 'You win!');
    gameState.value = GameState.won;
    stopTimer();
    confettiController.play(); // Play confetti animation on win
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
      [1, -1], [1, 0], [1, 1] // Bottom row
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

  @override
  void onClose() {
    _timer?.cancel(); // Make sure to cancel the timer to avoid memory leaks
    confettiController.dispose(); // Dispose of confetti controller
    super.onClose();
  }

}
