// Package imports:
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/add_tower/add_tower.dart';
import 'package:flame_test/add_tower/text_button.dart';

class PlaceTowerButton extends TextButtonComponent
    with ParentIsA<AddTowerComponent> {
  PlaceTowerButton() : super(text: "Place tower");

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    onPressed = pressed;
  }

  void pressed() {
    if (parent.newTower != null) {
      parent.newTower!.placed = true;
      parent.newTower = null;
      add(RemoveEffect());
    }
  }
}
