// Project imports:
import 'package:flame_test/components/creep/creep.dart';

class AntCreep extends Creep {
  AntCreep()
      : super(
          baseDamage: 5,
          maxHealth: 100,
          moveSpeed: 100,
        );
}
