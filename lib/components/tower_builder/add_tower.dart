// Package imports:
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/components/text_button.dart';
import 'package:flame_test/components/tower/tower.dart';
import 'package:flame_test/components/tower_builder/drag_shadow.dart';
import 'package:flame_test/main.dart';
import 'package:flame_test/towers/plasma_tower.dart';

class AddTowerComponent extends PositionComponent
    with HasGameRef<SpaceShooterGame> {
  final TextButtonComponent addTowerButton =
      TextButtonComponent(text: "Add Tower")..position = Vector2(0, 0);

  final TextButtonComponent placeTowerButton =
      TextButtonComponent(text: "Place Tower")..position = Vector2(90, 0);

  final TextButtonComponent abortPlaceTowerButton =
      TextButtonComponent(text: "Abort")..position = Vector2(180, 0);

  Tower? newTower;
  DragShadow? dragShadow;

  bool get placeable {
    if (newTower != null) {
      final node = gameRef.grid.snappedAtNode(newTower!);
      return node?.buildable ?? false;
    }

    return false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    addTowerButton.onPressed = onAddTower;
    placeTowerButton.onPressed = onPlaceTower;
    abortPlaceTowerButton.onPressed = onAbortPlaceTower;

    add(addTowerButton);
  }

  Future<void> onAddTower() async {
    if (!placeTowerButton.isMounted && !abortPlaceTowerButton.isMounted) {
      final towerPosition = absolutePositionOf(Vector2(40, -40));
      newTower = PlasmaTower()..position = towerPosition;

      dragShadow = DragShadow(tower: newTower!);

      gameRef.add(newTower!);
      gameRef.add(dragShadow!);

      add(placeTowerButton);
      add(abortPlaceTowerButton);
    }
  }

  void onPlaceTower() {
    if (newTower != null &&
        dragShadow != null &&
        placeTowerButton.isMounted &&
        abortPlaceTowerButton.isMounted &&
        placeable) {
      newTower!.placed = true;
      newTower!.targetAcquisition.renderRanges = false;
      newTower = null;

      dragShadow!.add(RemoveEffect());
      dragShadow = null;

      placeTowerButton.onTapCancel();
      placeTowerButton.add(RemoveEffect());

      abortPlaceTowerButton.onTapCancel();
      abortPlaceTowerButton.add(RemoveEffect());
    }
  }

  void onAbortPlaceTower() {
    if (newTower != null &&
        placeTowerButton.isMounted &&
        abortPlaceTowerButton.isMounted) {
      newTower?.add(RemoveEffect());
      newTower = null;

      dragShadow!.add(RemoveEffect());
      dragShadow = null;

      placeTowerButton.onTapCancel();
      placeTowerButton.add(RemoveEffect());

      abortPlaceTowerButton.onTapCancel();
      abortPlaceTowerButton.add(RemoveEffect());
    }
  }
}
