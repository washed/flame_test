// Package imports:
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

// Project imports:
import 'package:flame_test/components/text_button.dart';
import 'package:flame_test/components/tower.dart';
import 'package:flame_test/main.dart';
import 'package:flame_test/towers/plasma_tower.dart';

class DragShadow extends CircleComponent
    with HasGameRef<SpaceShooterGame>, DragCallbacks {
  final Tower tower;
  DragShadow({required this.tower}) {
    radius = 20;
    anchor = Anchor.center;
    position = tower.position;
    renderShape = false;
  }

  @override
  void onDragStart(DragStartEvent event) {}

  @override
  void onDragEnd(DragEndEvent event) {
    // follow the towers position onDragEnd because it has probably snapped
    position = tower.position;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.delta;
    tower.position = gameRef.grid.getSnapPosition(this);
  }
}

class AddTowerComponent extends PositionComponent
    with HasGameRef<SpaceShooterGame> {
  final TextButtonComponent addTowerButton =
      TextButtonComponent(text: "Add Tower")..position = Vector2(0, 0);

  final TextButtonComponent placeTowerButton =
      TextButtonComponent(text: "Place Tower")..position = Vector2(90, 2);

  final TextButtonComponent abortPlaceTowerButton =
      TextButtonComponent(text: "Abort")..position = Vector2(180, 2);

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
      newTower = PlasmaTower()..position = Vector2(50, 50);

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
