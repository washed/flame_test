import 'package:flame/components.dart';
import 'package:flame_test/add_tower/add_tower.dart';
import 'package:flame_test/add_tower/text_button.dart';
import 'package:flame_test/tower.dart';

class AddTowerButton extends TextButtonComponent
    with ParentIsA<AddTowerComponent> {
  AddTowerButton() : super(text: "Add tower");

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    onPressed = pressed;
  }

  void pressed() {
    if (parent.newTower == null) {
      final newTower = Tower(
        firingRange: 200,
        acquisitionRange: 250,
      )..position = Vector2(200, 200);

      parent.newTower = newTower;
      gameRef.add(newTower);

      parent.addPlaceTowerButton();
    }
  }
}
