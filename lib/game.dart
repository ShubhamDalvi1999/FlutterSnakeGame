import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake_game/controler.dart';
import 'package:snake_game/direction.dart';
import 'package:snake_game/piece.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  //variables for bound
  late int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  late double screenwidth, screenHeight;
  int step = 20;
  int length = 7;
  int score = 0;
  double speed = 1.0;
  Offset? foodPosition = null;
  late Piece food;
  List<Offset> positions = [];
  Direction direction = Direction.right;
  Timer? timer = null;

  Widget getScore() {
    return Positioned(
        top: 80.0,
        right: 50.0,
        child: Text(
          "Score :" + score.toString(),
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ));
  }

  Widget getControls() {
    return Controller(onTapped: (Direction newDirection) {
      direction = newDirection;
    });
  }

  //the moving functionality
  void changeSpeed() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      setState(() {});
    });
  }

  void restart() {
    changeSpeed();
  }

  @override
  void initState() {
    super.initState();
    restart();
  }

  //to round the bound to nearest tens
  int getNearestTens(int num) {
    int output;
    output = (num ~/ step) * step;
    if (output == 0) output += step;
    return output;
  }

  Offset getRandomPosition() {
    Offset position;
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY;
    position = Offset(
        getNearestTens(posX).toDouble(), getNearestTens(posY).toDouble());
    return position;
  }

  void draw() {
    if (positions.length == 0) {
      positions.add(getRandomPosition());
    }
    //add length times boxes
    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }
    //moving the boxes
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    positions[0] = getNextPosition(positions[0])!;
  }

  bool detectCollision(Offset position) {
    if (position.dx >= upperBoundX && direction == Direction.right) {
      return true;
    } else if (position.dx <= lowerBoundX && direction == Direction.left) {
      return true;
    } else if (position.dy > upperBoundY && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY && direction == Direction.up) {
      return true;
    }
    return false;
  }

  Offset? getNextPosition(Offset position) {
    Offset nextPosition;
    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    } else {
      return null;
    }

    return nextPosition;
  }

  void drawFood() {
    if (foodPosition == null) {
      foodPosition = getRandomPosition();
    }

    if (foodPosition == positions[0]) {
      length++;
      score = score + 5;
      speed = speed + 0.25;
      foodPosition = getRandomPosition();
    }
    food = Piece(
      posX: foodPosition?.dx.toInt(),
      posY: foodPosition?.dy.toInt(),
      size: step,
      color: Colors.red,
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
    drawFood();
    for (var i = 0; i < length; i++) {
      if (i >= positions.length) {
        continue;
      }
      pieces.add(Piece(
        posX: positions[i].dx.toInt(),
        posY: positions[i].dy.toInt(),
        color: i.isEven ? Colors.green : Colors.yellow,
        size: step,
      ));
    }

    return pieces;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    lowerBoundX = step;
    lowerBoundY = step;

    upperBoundY = getNearestTens(screenHeight.toInt() - step);
    upperBoundX = getNearestTens(screenwidth.toInt() - step);

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(children: [
          Stack(
            children: getPieces(),
          ),
          getControls(),
          food,
          getScore(),
        ]),
      ),
    );
  }
}
