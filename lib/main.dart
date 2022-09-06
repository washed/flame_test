// Flutter imports:
import 'package:flame_test/components/energy/energy.dart';
import 'package:flame_test/components/energy/energy_ui.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

// Project imports:
import 'package:flame_test/components/creep/creep.dart';
import 'package:flame_test/components/grid/grid.dart';
import 'package:flame_test/components/level/level.dart';
import 'package:flame_test/components/level/level_ui.dart';
import 'package:flame_test/components/tower_builder/add_tower.dart';
import 'package:flame_test/levels/level_1.dart';

class SpaceShooterGame extends FlameGame
    with
        PanDetector,
        HasCollisionDetection,
        HasDraggableComponents,
        HasTappables {
  final energy = Energy();

  late GridComponent grid;
  Level? currentLevel;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    debugMode = false;

    children.register<Creep>();

    add(ScreenHitbox());

    grid = GridComponent()
      ..edgeSize = 50
      ..nodesHeight = 10
      ..nodesWidth = 10
      ..position = Vector2(0, 80);

    add(grid);

    final addTowerComponent = AddTowerComponent();
    add(addTowerComponent);

    add(energy);
    final energyUI = EnergyUI();
    add(energyUI);

    final levelUI = LevelUI();
    add(levelUI);

    currentLevel = level_1;
    add(level_1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (currentLevel?.levelFinished == true) {
      currentLevel = null;
      // TODO: this should go into some level/global state management
    }
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
