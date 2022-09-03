// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/base.dart';
import 'package:flame_test/grid.dart';
import 'package:flame_test/levels/creep_spawner.dart';
import 'package:flame_test/main.dart';

class Wave extends Component with HasGameRef<SpaceShooterGame> {
  final List<CreepSpawner> creepSpawners;

  Wave({required this.creepSpawners});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    for (final spawner in creepSpawners) {
      await add(spawner);
      initGrid(spawner.creepPathCoords);
    }
  }

  void initGrid(List<GridCoord> pathGridCoords) {
    final interpolateGridCoords =
        gameRef.grid.interpolateGridCoords(pathGridCoords);

    for (final pathGridCoord in interpolateGridCoords) {
      final node = gameRef.grid.getGridNode(pathGridCoord);
      node.paint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.blueGrey.withOpacity(0.5);
      node.buildable = false;
    }
  }

  bool get allCreepsSpawned =>
      creepSpawners.every((element) => element.allCreepsSpawned);
}

class Level extends Component with HasGameRef<SpaceShooterGame> {
  final List<Wave> waves;
  final double delayBetweenWaves;
  final GridCoord baseGridPosition;

  int completedWaves = 0;
  double _startOfLastWave = 0;
  Wave? _currentWave;

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

  @override
  void update(double dt) {
    super.update(dt);

    if (_currentWave == null) {
      _startOfLastWave += dt;
      if (_startOfLastWave >= delayBetweenWaves) {
        if (completedWaves < waves.length) {
          _currentWave = waves[completedWaves];
          add(_currentWave!);
          _startOfLastWave = 0;
        } else {
          // TODO: all waves completed
        }
      }
    } else {
      if (_currentWave!.allCreepsSpawned) {
        completedWaves++;
        _currentWave = null;
      }
    }
  }

  int get waveCount => waves.length;
}
