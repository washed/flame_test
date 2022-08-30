import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GridNodeComponent extends RectangleComponent {
  final int hIndex;
  final int vIndex;

  GridNodeComponent({
    required this.hIndex,
    required this.vIndex,
    required double edgeSize,
  }) : super(
          size: Vector2(edgeSize, edgeSize),
          paint: Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.grey,
          position: Vector2(
            hIndex * edgeSize,
            vIndex * edgeSize,
          ),
        );
}

class GridComponent extends PositionComponent {
  late int nodesWidth;
  late int nodesHeight;
  late double edgeSize;
  late double snapFactor = 1.0;
  late List<List<GridNodeComponent>> nodes = [];

  @override
  Future<void> onLoad() async {
    for (int hNodeIndex = 0; hNodeIndex < nodesWidth; hNodeIndex++) {
      final List<GridNodeComponent> row = [];
      for (int vNodeIndex = 0; vNodeIndex < nodesHeight; vNodeIndex++) {
        final newNode = GridNodeComponent(
          hIndex: hNodeIndex,
          vIndex: vNodeIndex,
          edgeSize: edgeSize,
        );
        row.add(newNode);
        add(newNode);
      }
      nodes.add(row);
    }
  }

  Vector2 getSnapPosition(PositionComponent component) {
    final relativePosition = component.absolutePosition - absolutePosition;
    final int hIndex = relativePosition.x ~/ edgeSize;
    final int vIndex = relativePosition.y ~/ edgeSize;

    if (0 <= hIndex &&
        hIndex < nodesWidth &&
        0 <= vIndex &&
        vIndex < nodesHeight) {
      final node = nodes[hIndex][vIndex];
      if ((node.center - relativePosition).length < snapFactor * edgeSize) {
        return node.absoluteCenter;
      }
    }

    return component.position;
  }
}
