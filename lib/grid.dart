import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GridCoord {
  final int x;
  final int y;

  GridCoord(this.x, this.y)
      : assert(x >= 0),
        assert(y >= 0);
}

class GridNodeComponent extends RectangleComponent {
  GridCoord coords;

  GridNodeComponent({
    required this.coords,
    required double edgeSize,
  }) : super(
          size: Vector2(edgeSize, edgeSize),
          paint: Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.grey,
          position: Vector2(
            coords.x * edgeSize,
            coords.y * edgeSize,
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
          coords: GridCoord(
            hNodeIndex,
            vNodeIndex,
          ),
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

  Path getPathFromCoords(List<GridCoord> coords) {
    final path = Path();
    for (final coord in coords) {
      if (coord.x < nodesWidth && coord.y < nodesWidth) {
        final node = nodes[coord.x][coord.y];
        final nodePosition = node.absoluteCenter;

        path.lineTo(
          nodePosition.x,
          nodePosition.y,
        );
      }
    }
    return path;
  }
}
