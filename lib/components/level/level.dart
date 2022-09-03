// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/components/base.dart';
import 'package:flame_test/components/grid/grid_coord.dart';
import 'package:flame_test/components/level/wave.dart';
import 'package:flame_test/main.dart';

class Level extends Component with HasGameRef<SpaceShooterGame> {
  final List<Wave> waves;
  final double delayBetweenWaves;
  final GridCoord baseGridPosition;

  int completedWaves = 0;
  double _startOfLastWave = 0;
  Wave? _currentWave;
  bool _levelFinished = false;

  bool get levelFinished => _levelFinished;

  Level({
    required this.waves,
    required this.delayBetweenWaves,
    required this.baseGridPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final base = Base()
      ..position = gameRef.grid.getPositionFromCoords(baseGridPosition);
    add(base);
  }

  bool get waveFinished {
    if (_currentWave != null) {
      if (_currentWave!.allCreepsKilled) {
        return true;
      }
    }
    return false;
  }

  double? get nextWaveTMinus =>
      _currentWave == null ? (delayBetweenWaves - _startOfLastWave) : null;

  void maybePrepWave() {
    if (_currentWave == null) {
      if (completedWaves < waves.length) {
        final prepWave = waves[completedWaves];
        prepWave.initGrid(gameRef.grid);
      }
    }
  }

  void maybeStartWave(double dt) {
    if (_currentWave == null) {
      _startOfLastWave += dt;
      if (_startOfLastWave >= delayBetweenWaves) {
        if (completedWaves < waves.length) {
          _currentWave = waves[completedWaves];
          add(_currentWave!);
          _startOfLastWave = 0;
        }
      }
    }
  }

  void maybeFinishWave() {
    if (waveFinished) {
      completedWaves++;
      _currentWave = null;
    }
  }

  void maybeFinishLevel() {
    if (completedWaves == waves.length) {
      debugPrint("Level finished!");
      _levelFinished = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!levelFinished) {
      maybePrepWave();
      maybeStartWave(dt);
      maybeFinishWave();
      maybeFinishLevel();
    }
  }

  int get waveCount => waves.length;
}
