import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_pragma/main.dart';

class Obstacle extends PositionComponent
    with HasGameRef<GameWorld>, CollisionCallbacks {
  late Paint paint;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(200, 100);
    position = Vector2(100, game.size.y / 2);
    paint = Paint()
      ..color = Color(0xFFFF0000)
      ..style = PaintingStyle.fill;
    final shape = RectangleHitbox(
      size: Vector2(45, 45),
      position: Vector2(40, 40),
    );
    add(shape);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), paint);
    super.render(canvas);
  }
}
