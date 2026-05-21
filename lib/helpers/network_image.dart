import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkImages extends StatelessWidget {
  final String imageUrl;

  const NetworkImages({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover, // Adjust as needed
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,

              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300], // Placeholder background
            width: 100, // Set a default size
            height: 100,
            child: Icon(Icons.broken_image, color: Colors.grey[600]),
          );
        },
      ),
    );
  }
}

