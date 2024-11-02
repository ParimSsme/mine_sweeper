import 'dart:math';

import 'package:get/get.dart';

class GameController extends GetxController {
  final int numberOfSquares = 9 * 9;
  final int numberInEachRow = 9;

  // List of bombs and square statuses
  List<int> bombLocation = [];
  RxList<List<dynamic>> squareStatus = RxList.filled(9 * 9, [0, false]);
  RxBool bombsRevealed = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeGame();
  }

  void _initializeGame() {
    // Initialize each square with no bombs around and as unrevealed
    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus[i] = [0, false];
    }

    generateBombLocations();

    _scanBombs();
  }

  void generateBombLocations() {
    Random random = Random();

    /// Generate unique bomb locations until we reach the desired count
    /// bomb count is 7
    while (bombLocation.length < 7) {

      /// 82 is grid size
      int randomNumber = random.nextInt(82);

      if (!bombLocation.contains(randomNumber)) {
        bombLocation.add(randomNumber);
      }
    }
  }

  void restartGame() {
    bombsRevealed.value = false;
    _initializeGame();
  }

  void revealBoxNumbers(int index) {
    if (squareStatus[index][0] != 0) {
      squareStatus[index][1] = true;
    } else if (squareStatus[index][0] == 0) {
      _revealAdjacentSquares(index);
    }
    squareStatus.refresh();
  }

  void _revealAdjacentSquares(int index) {
    squareStatus[index][1] = true;

    List<int> adjacentIndices = _getAdjacentIndices(index);
    for (var adjIndex in adjacentIndices) {
      if (squareStatus[adjIndex][0] == 0 && !squareStatus[adjIndex][1]) {
        revealBoxNumbers(adjIndex);
      }
      squareStatus[adjIndex][1] = true;
    }
  }

  List<int> _getAdjacentIndices(int index) {
    List<int> adjacentIndices = [];

    // Define the surrounding indices (left, top-left, top, etc.)
    // Based on boundary checks like left wall, top row, right wall, etc.
    // Here’s a sample for a few directions:

    if (index % numberInEachRow != 0) {
      adjacentIndices.add(index - 1); // Left
    }
    if (index >= numberInEachRow) {
      adjacentIndices.add(index - numberInEachRow); // Top
    }
    // Complete with other directions as per your initial logic...

    return adjacentIndices;
  }

  void _scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      int numberOfBombsAround = _countSurroundingBombs(i);
      squareStatus[i][0] = numberOfBombsAround;
    }
  }

  int _countSurroundingBombs(int index) {
    int count = 0;
    List<int> adjacentIndices = _getAdjacentIndices(index);

    for (var adjIndex in adjacentIndices) {
      if (bombLocation.contains(adjIndex)) {
        count++;
      }
    }
    return count;
  }

  void checkWinner() {
    int unrevealedBoxes = squareStatus.where((square) => !square[1]).length;
    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  void playerLost() {
    bombsRevealed.value = true;
    // Trigger loss message or logic here
  }

  void playerWon() {
    // Trigger win message or logic here
  }
}
