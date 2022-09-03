// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

class GridCoord {
  final int x;
  final int y;

  GridCoord(this.x, this.y)
      : assert(x >= 0),
        assert(y >= 0);
}

class GridNodeComponent extends RectangleComponent {
  GridCoord coords;
  bool buildable = true;

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
      if ((node.center - relativePosition).length < snapFactor * edgeSize &&
          node.buildable) {
        return node.absoluteCenter;
      }
    }

    return component.position;
  }

  GridNodeComponent getGridNode(GridCoord coord) {
    if (coord.x < nodesWidth && coord.y < nodesWidth) {
      final node = nodes[coord.x][coord.y];
      return node;
    }
    throw IndexError;
  }

  Vector2 getPositionFromCoords(GridCoord coord) {
    return getGridNode(coord).absoluteCenter;
  }

  Path getPathFromCoords(List<GridCoord> coords) {
    assert(coordsValid(coords));

    final path = Path();
    for (final coord in coords) {
      final nodeAbsoluteCenter = getPositionFromCoords(coord);
      path.lineTo(
        nodeAbsoluteCenter.x - nodes[0][0].absoluteCenter.x,
        nodeAbsoluteCenter.y - nodes[0][0].absoluteCenter.y,
      );
    }
    return path;
  }

  bool coordsValid(List<GridCoord> coords) {
    GridCoord? lastCoord;
    for (final coord in coords) {
      lastCoord ??= coord;

      final xDelta = coord.x - lastCoord.x;
      final yDelta = coord.y - lastCoord.y;

      if (xDelta != 0 && yDelta != 0) {
        return false;
      }

      lastCoord = coord;
    }
    return true;
  }

  List<GridCoord> interpolateGridCoords(List<GridCoord> coords) {
    assert(coordsValid(coords));

    GridCoord? lastCoord;
    List<GridCoord> interpolatedCoords = [];
    for (final coord in coords) {
      lastCoord ??= coord;

      final xDelta = coord.x - lastCoord.x;
      final yDelta = coord.y - lastCoord.y;

      if (xDelta != 0) {
        for (int x = lastCoord.x; x != lastCoord.x + xDelta; x += xDelta.sign) {
          final coord = GridCoord(x, lastCoord.y);
          interpolatedCoords.add(coord);
        }
      }

      if (yDelta != 0) {
        for (int y = lastCoord.y; y != lastCoord.y + yDelta; y += yDelta.sign) {
          final coord = GridCoord(lastCoord.x, y);
          interpolatedCoords.add(coord);
        }
      }

      lastCoord = coord;
    }

    interpolatedCoords.add(coords.last);

    return interpolatedCoords;
  }
}
