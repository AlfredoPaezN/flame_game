import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_pragma/obstacles/obstacle.dart';
import 'package:game_pragma/players/player.dart';

void main() {
  runApp(GameWidget(game: GameWorld()));
}

class GameWorld extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  FutureOr<void> onLoad() async {
    final background = SpriteComponent(
      sprite: await Sprite.load('map.png'),
      size: size,
      paint: Paint()..color = Colors.green,
    );
    final player = Player();
    final obstacle = Obstacle();

    player.priority = 1;
    obstacle.priority = 1;

    add(background);
    add(obstacle);
    add(player);

    return super.onLoad();
  }
}
