import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:game_pragma/main.dart';
import 'package:game_pragma/obstacles/obstacle.dart';

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<GameWorld>, KeyboardHandler, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  Vector2 movement = Vector2.zero();

  @override
  FutureOr<void> onLoad() async {
    await _loadAnimations();
    size = Vector2(128, 128);
    position = Vector2(game.size.x / 2, game.size.y / 2);
    final shape = RectangleHitbox(
      size: Vector2(45, 45),
      position: Vector2(40, 40),
      collisionType: CollisionType.passive,
    );
    add(shape);
    return super.onLoad();
  }

  _loadAnimations() async {
    final spriteSheet = SpriteSheet(
        image: await game.images.load('player.png'), srcSize: Vector2(48, 48));
    animations = {
      'idle':
          spriteSheet.createAnimation(row: 0, stepTime: 0.5, from: 0, to: 2),
      'left':
          spriteSheet.createAnimation(row: 2, stepTime: 0.1, from: 2, to: 4),
      'right':
          spriteSheet.createAnimation(row: 3, stepTime: 0.1, from: 2, to: 4),
      'up': spriteSheet.createAnimation(row: 1, stepTime: 0.1, from: 2, to: 4),
      'down':
          spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 2, to: 4),
    };
    current = 'idle';
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    movement.x = 0;
    movement.y = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      movement.y += -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      movement.y += 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      movement.x += -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      movement.x += 1;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    _updateAnmimations();
    _updateMovement(dt);
    super.update(dt);
  }

  void _updateMovement(double dt) {
    velocity.x = movement.x * 200;
    velocity.y = movement.y * 200;
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
  }

  void _updateAnmimations() {
    if (velocity != Vector2.zero()) {
      if (velocity.x < 0) {
        current = 'left';
      } else if (velocity.x > 0) {
        current = 'right';
      } else if (velocity.y < 0) {
        current = 'up';
      } else if (velocity.y > 0) {
        current = 'down';
      }
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstacle) {
      position = Vector2(0, game.size.y / 2);
    }
  }
}
