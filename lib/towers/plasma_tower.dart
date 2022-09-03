// Project imports:
import 'package:flame_test/components/tower.dart';

class PlasmaTower extends Tower {
  PlasmaTower()
      : super(
          fireRate: 10.0,
          turnRate: 10.0,
          firingRange: 75,
          acquisitionRange: 100,
        );
}
