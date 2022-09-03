// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/creep.dart';
import 'package:flame_test/grid.dart';
import 'package:flame_test/main.dart';

class CreepSpawner extends CircleComponent with HasGameRef<SpaceShooterGame> {
  late int creepCount;
  late double spawnPeriod;
  late double firstSpawnDelay = 0.0;
  late Path creepPath;
  late GridCoord gridPosition;

  double _tMinusSpawn = 0.0;
  int _creepSpawnCount = 0;
  final List<Creep> _creepsSpawned = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = gameRef.grid.getPositionFromCoords(gridPosition);
    radius = 10;
    anchor = Anchor.center;
    paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isMounted) {
      if (firstSpawnDelay > 0.0) {
        firstSpawnDelay -= dt;
      } else {
        _tMinusSpawn -= dt;
        if (_tMinusSpawn <= 0.0) {
          _tMinusSpawn = spawnPeriod;
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
}
