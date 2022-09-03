// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/creep.dart';
import 'package:flame_test/grid.dart';
import 'package:flame_test/main.dart';

class CreepSpawner extends PositionComponent with HasGameRef<SpaceShooterGame> {
  late int creepCount;
  late double spawnPeriod;
  late Path creepPath;
  late GridCoord gridPosition;

  double _tminusSpawn = 0.0;
  int _creepSpawnCount = 0;
  List<Creep> _creepsSpawned = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = gameRef.grid.getPositionFromCoords(gridPosition);

    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isMounted) {
      _tminusSpawn -= dt;
      if (_tminusSpawn <= 0.0) {
        _tminusSpawn = spawnPeriod;
        if (_creepSpawnCount < creepCount) {
          final creep = Creep()
            ..position = position
            ..path = creepPath
            ..startMovingDelay = 0.1;

          _creepsSpawned.add(creep);

          // TODO: maybe it is beneficial to add creeps to the spawner instead?
          gameRef.add(creep);

          _creepSpawnCount++;
        }
      }
    }
  }
}
