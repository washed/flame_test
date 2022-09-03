// Package imports:
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

// Project imports:
import 'package:flame_test/components/tower/tower.dart';
import 'package:flame_test/main.dart';

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
