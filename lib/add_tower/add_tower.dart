import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/add_tower/add_tower_button.dart';
import 'package:flame_test/add_tower/place_tower_button.dart';
import 'package:flame_test/tower.dart';

class AddTowerComponent extends PositionComponent {
  final AddTowerButton addTowerButton = AddTowerButton()
    ..position = Vector2(0, 0);
  final PlaceTowerButton placeTowerButton = PlaceTowerButton()
    ..position = Vector2(0, 60);

  Tower? newTower;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(addTowerButton);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void addPlaceTowerButton() {
    if (newTower != null && !placeTowerButton.isMounted) {
      add(placeTowerButton);
    }
  }
}
