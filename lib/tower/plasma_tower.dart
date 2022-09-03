// Project imports:
import 'package:flame_test/tower/tower.dart';

class PlasmaTower extends Tower {
  PlasmaTower()
      : super(
          fireRate: 10.0,
          turnRate: 10.0,
          firingRange: 200,
          acquisitionRange: 250,
        );
}
