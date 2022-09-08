// Project imports:
import 'package:flame_test/components/creep_spawner.dart';
import 'package:flame_test/components/grid/grid_coord.dart';
import 'package:flame_test/components/level/level.dart';
import 'package:flame_test/components/level/wave.dart';

final pathGridCoords = [
  GridCoord(0, 0),
  GridCoord(5, 0),
  GridCoord(5, 3),
  GridCoord(2, 3),
  GridCoord(2, 6),
  GridCoord(9, 6),
  GridCoord(9, 9),
];

final wave_1 = Wave(
  creepSpawners: [
    CreepSpawner(
      firstSpawnDelay: 0.0,
      creepCount: 10,
      creepPathCoords: pathGridCoords,
      gridPosition: GridCoord(0, 0),
      spawnPeriod: 1.0,
    ),
    CreepSpawner(
      firstSpawnDelay: 5.0,
      creepCount: 10,
      creepPathCoords: pathGridCoords,
      gridPosition: GridCoord(0, 0),
      spawnPeriod: 2.0,
    )
  ],
);

final wave_2 = Wave(
  creepSpawners: [
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
  ],
);

final level_1 = Level(
  baseGridPosition: GridCoord(9, 9),
  waves: [
    wave_1,
    wave_2,
  ],
  delayBetweenWaves: 1.0,
);
