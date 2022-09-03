// Project imports:
import 'package:flame_test/grid.dart';
import 'package:flame_test/levels/creep_spawner.dart';
import 'package:flame_test/levels/level.dart';

final pathGridCoords = [
  GridCoord(0, 0),
  GridCoord(5, 0),
  GridCoord(5, 3),
  GridCoord(2, 3),
  GridCoord(2, 6),
  GridCoord(9, 6),
  GridCoord(9, 9),
];

final level_1 = Level(
  baseGridPosition: GridCoord(9, 9),
  waves: [
    Wave(creepSpawners: [
      CreepSpawner(
        firstSpawnDelay: 0.0,
        creepCount: 10,
        creepPathCoords: pathGridCoords,
        gridPosition: GridCoord(0, 0),
        spawnPeriod: 0.25,
      ),
      CreepSpawner(
        firstSpawnDelay: 5.0,
        creepCount: 10,
        creepPathCoords: pathGridCoords,
        gridPosition: GridCoord(0, 0),
        spawnPeriod: 0.5,
      )
    ])
  ],
  delayBetweenWaves: 1.0,
);
