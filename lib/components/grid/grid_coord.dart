class GridCoord {
  final int x;
  final int y;

  GridCoord(this.x, this.y)
      : assert(x >= 0),
        assert(y >= 0);
}
