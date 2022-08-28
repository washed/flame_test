import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GridComponent extends PositionComponent {
  late int nodesWidth;
  late int nodesHeight;
  late double edgeSize;
  late double snapFactor = 1.0;

  @override
  Future<void> onLoad() async {
    for (int hNodeIndex = 0; hNodeIndex < nodesWidth; hNodeIndex++) {
      for (int vNodeIndex = 0; vNodeIndex < nodesHeight; vNodeIndex++) {
        final newNode = RectangleComponent(
            position: Vector2(
              hNodeIndex * edgeSize,
              vNodeIndex * edgeSize,
            ),
            size: Vector2(edgeSize, edgeSize),
            paint: Paint()
              ..style = PaintingStyle.stroke
              ..color = Colors.grey);
        add(newNode);
      }
    }
  }

  Vector2 getSnapPosition(Vector2 position) {
    // TODO: might be more efficient to directly calculate the matching node

    try {
      final node = children
          .whereType<PositionComponent>()
          .where((element) => element.containsPoint(position))
          .single;
      if ((node.absoluteCenter - position).length < snapFactor * edgeSize) {
        debugPrint("Snapped!");
        return node.absoluteCenter;
      } else {
        return position;
      }
    } catch (e) {
      if (e is StateError) return position;
      rethrow;
    }
  }
}
