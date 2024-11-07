enum GameLevel {
  easy,
  medium,
  hard,
}

extension GameLevelExtension on GameLevel {
  int get rowCount {
    switch (this) {
      case GameLevel.easy: return 8;
      case GameLevel.medium: return 12;
      case GameLevel.hard: return 18;
    }
  }

  int get columnCount {
    switch (this) {
      case GameLevel.easy: return 8;
      case GameLevel.medium: return 10;
      case GameLevel.hard: return 14;
    }
  }

  int get bombProbability {
    switch (this) {
      case GameLevel.easy: return 2;
      case GameLevel.medium: return 3;
      case GameLevel.hard: return 5;
    }
  }
}
