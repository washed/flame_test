// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/components/creep_spawner.dart';
import 'package:flame_test/components/grid/grid.dart';

class Wave extends Component {
  final List<CreepSpawner> creepSpawners;

  Wave({required this.creepSpawners});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    for (final spawner in creepSpawners) {
      await add(spawner);
    }
  }

  void initGrid(GridComponent grid) {
    for (final spawner in creepSpawners) {
      final interpolateGridCoords =
          grid.interpolateGridCoords(spawner.creepPathCoords);

      for (final pathGridCoord in interpolateGridCoords) {
        final node = grid.getGridNode(pathGridCoord);
        node.paint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.blueGrey.withOpacity(0.5);
        node.buildable = false;
      }
    }
  }

  bool get allCreepsSpawned =>
      creepSpawners.every((element) => element.allCreepsSpawned);

  bool get allCreepsKilled =>
      creepSpawners.every((element) => element.allCreepsKilled);
}
