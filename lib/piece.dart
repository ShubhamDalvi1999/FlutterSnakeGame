import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  const Piece({Key? key, this.posY, required this.color, this.posX, this.size})
      : super(key: key);
  final posY, posX, size;
  final Color color;
  @override
  _PieceState createState() => _PieceState();
}

class _PieceState extends State<Piece> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.posY.toDouble(),
        left: widget.posX.toDouble(),
        child: Opacity(
          opacity: 1,

          child: Container(
            width: widget.size.toDouble(), height: widget.size.toDouble(),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(width: 2.0, color: Colors.white12),
            ), // BoxDecoration
          ), // Container
        ));
  }
}
