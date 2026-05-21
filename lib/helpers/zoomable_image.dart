import 'package:flutter/material.dart';

void main() => runApp(ZoomableImageApp());

class ZoomableImageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      //  appBar: AppBar(title: Text('Zoom Image')),
        body: Center(
          child: InteractiveViewer(
            panEnabled: true, // Set to false to disable panning
            boundaryMargin: EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.asset('assets/my_image.jpg'), // Or use NetworkImage
          ),
        ),
      ),
    );
  }
}
