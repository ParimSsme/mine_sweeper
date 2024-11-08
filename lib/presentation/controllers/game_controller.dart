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

  // Game level information
  GameLevel level = GameService.to.getGameLevel;

  // Game state variables
  var board = <List<BoardSquare>>[].obs;
  var revealedSquares = <bool>[].obs;
  var flaggedSquares = <bool>[].obs;
  var bombCount = 0.obs;
  var squaresLeft = 0.obs;
  var gameState = GameState.ongoing.obs;
  int flagsLeft = 0;

  // Grid dimensions
  late int rowCount = 18;
  late int columnCount = 10;

  // Timer variables
  RxInt elapsedTime = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    startNewGame();
  }

  void onBackClicked() => Get.offNamed(AppRoutes.selectLevel);

  bool isGameEnded() => gameState.value == GameState.lost || gameState.value == GameState.won;

  void startTimer() {
    _timer?.cancel();
    elapsedTime.value = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (_) => elapsedTime.value++);
  }

  void stopTimer() => _timer?.cancel();

  void resetTimer() {
    stopTimer();
    elapsedTime.value = 0;
  }

  void resetGame() {
    revealedSquares.clear();
    flaggedSquares.clear();
    gameState.value = GameState.ongoing;
    resetTimer();
    startTimer();
    _initializeGrid();
  }

  void startNewGame() {
    rowCount = level.rowCount;
    columnCount = level.columnCount;
    bombCount.value = level.bombProbability;
    board.value = initializeGame(bombCount: bombCount.value, rowCount: rowCount, columnCount: columnCount);
    _initializeGrid();
  }

  void _initializeGrid() {
    revealedSquares.value = List.generate(rowCount * columnCount, (_) => false);
    flaggedSquares.value = List.generate(rowCount * columnCount, (_) => false);
    squaresLeft.value = rowCount * columnCount;
    flagsLeft = bombCount.value;
  }

  void toggleFlag(int position) {
    if (gameState.value != GameState.ongoing || revealedSquares[position]) return;

    flaggedSquares[position] = !flaggedSquares[position];
    final row = position ~/ columnCount;
    final col = position % columnCount;

    if (flaggedSquares[position]) {
      board[row][col].hasBomb ? bombCount.value-- : squaresLeft.value--;
    } else {
      board[row][col].hasBomb ? bombCount.value++ : squaresLeft.value++;
    }
    update();
  }

  void handleTap(int position) {
    if (gameState.value != GameState.ongoing || flaggedSquares[position]) return;

    final row = position ~/ columnCount;
    final col = position % columnCount;

    if (board[row][col].hasBomb) {
      revealedSquares[position] = true;
      _handleGameOver();
      return;
    }

    if (board[row][col].bombsAround == 0) {
      _revealAdjacentSquares(row, col);
    } else {
      revealedSquares[position] = true;
      squaresLeft--;
    }

    if (squaresLeft <= bombCount.value) _handleWin();
  }

  void _handleGameOver() {
    SnackbarUtils.showErrorSnackbar(title: 'Game Over', message: 'You stepped on a mine!');
    gameState.value = GameState.lost;
    stopTimer();
    update();
  }

  void _handleWin() {
    SnackbarUtils.showSuccessSnackbar(title: 'Congratulations', message: 'You win!');
    gameState.value = GameState.won;
    stopTimer();
    confettiController.play();
    update();
  }

  void _revealAdjacentSquares(int row, int col) {
    if (row < 0 || row >= rowCount || col < 0 || col >= columnCount) return;

    final position = row * columnCount + col;
    if (revealedSquares[position]) return;

    revealedSquares[position] = true;
    squaresLeft--;

    if (board[row][col].bombsAround > 0) return;

    const directions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1],         [0, 1],
      [1, -1], [1, 0], [1, 1]
    ];

    for (final direction in directions) {
      final newRow = row + direction[0];
      final newCol = col + direction[1];
      _revealAdjacentSquares(newRow, newCol);
    }
    update();
  }

  @override
  void onClose() {
    _timer?.cancel();
    confettiController.dispose();
    super.onClose();
  }
}
