// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/components/creep/creep.dart';
import 'package:flame_test/components/grid/grid_coord.dart';
import 'package:flame_test/creeps/ant_creep.dart';
import 'package:flame_test/main.dart';

class CreepSpawner extends CircleComponent with HasGameRef<SpaceShooterGame> {
  final GridCoord gridPosition;
  final int creepCount;
  final List<GridCoord> creepPathCoords;
  final double spawnPeriod;
  double firstSpawnDelay;

  late Path creepPath;

  double _tMinusSpawn = 0.0;
  int _creepSpawnCount = 0;
  final List<Creep> _creepsSpawned = [];

  CreepSpawner({
    required this.gridPosition,
    required this.creepCount,
    required this.creepPathCoords,
    required this.spawnPeriod,
    this.firstSpawnDelay = 0.0,
  });

  bool get allCreepsSpawned => _creepSpawnCount == creepCount;

  bool get allCreepsKilled => allCreepsSpawned
      ? _creepsSpawned.every((element) => element.dead)
      : false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = gameRef.grid.getPositionFromCoords(gridPosition);
    radius = 10;
    anchor = Anchor.center;
    paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    creepPath = gameRef.grid.getPathFromCoords(creepPathCoords);
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
            final creep = AntCreep()
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
