import '../../data/models/board_square.dart';
import '../../data/repositories/game_repository.dart';

class InitializeGame {
  final GameRepository repository;

  InitializeGame(this.repository);

  List<List<BoardSquare>> call({
    required int bombCount,
    required int rowCount,
    required int columnCount,
  }) {
    return repository.initializeBoard(
      bombCount: bombCount,
      rowCount: rowCount,
      columnCount: columnCount,
    );
  }
}
