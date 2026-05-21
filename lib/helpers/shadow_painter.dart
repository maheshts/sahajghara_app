import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShadowPainter extends CustomPainter{
  Paint ShadowPaint;
  ShadowPainter():ShadowPaint = new Paint(){
    ShadowPaint
      ..strokeWidth = 3.0
      ..color = const Color(0x44000000)
      ..style = PaintingStyle.fill;

  }
  @override
  void paint(Canvas canvas, Size size) {


    canvas.drawShadow(
        getCurvedPath(size),
        Colors.deepPurpleAccent.withAlpha(100),
        10.0,
        true
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }


  Path getCurvedPath(Size size){
    Path path = new Path();
    Offset startOffset;
    Offset endOffset;
    path.lineTo(0.0, size.height - 30);

    startOffset = Offset(size.width /4, size.height);
    endOffset = Offset(size.width/2 , size.height);
    path.quadraticBezierTo(startOffset.dx, startOffset.dy, endOffset.dx, endOffset.dy);

    startOffset = Offset(size.width - (size.width /4), size.height);
    endOffset = Offset(size.width , size.height - 30);
    path.quadraticBezierTo(startOffset.dx, startOffset.dy, endOffset.dx, endOffset.dy);

    path.lineTo(size.width,0.0);
    return path;
  }


}

