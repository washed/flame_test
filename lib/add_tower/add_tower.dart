// Package imports:
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/add_tower/text_button.dart';
import 'package:flame_test/main.dart';
import 'package:flame_test/tower.dart';

class AddTowerComponent extends PositionComponent
    with HasGameRef<SpaceShooterGame> {
  final TextButtonComponent addTowerButton =
      TextButtonComponent(text: "Add Tower")..position = Vector2(0, 0);

  final TextButtonComponent placeTowerButton =
      TextButtonComponent(text: "Place Tower")..position = Vector2(0, 60);

  final TextButtonComponent abortPlaceTowerButton =
      TextButtonComponent(text: "Abort")..position = Vector2(0, 120);

  Tower? newTower;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    addTowerButton.onPressed = onAddTower;
    placeTowerButton.onPressed = onPlaceTower;
    abortPlaceTowerButton.onPressed = onAbortPlaceTower;

    add(addTowerButton);
  }

  void onAddTower() {
    if (!placeTowerButton.isMounted && !abortPlaceTowerButton.isMounted) {
      newTower = Tower(
        firingRange: 200,
        acquisitionRange: 250,
      )..position = Vector2(200, 200);

      gameRef.add(newTower!);

      add(placeTowerButton);
      add(abortPlaceTowerButton);
    }
  }

  void onPlaceTower() {
    if (newTower != null &&
        placeTowerButton.isMounted &&
        abortPlaceTowerButton.isMounted) {
      newTower!.placed = true;
      newTower = null;

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

      placeTowerButton.onTapCancel();
      placeTowerButton.add(RemoveEffect());

      abortPlaceTowerButton.onTapCancel();
      abortPlaceTowerButton.add(RemoveEffect());
    }
  }
}
