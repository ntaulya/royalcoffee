import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageBoxWidget extends StatelessWidget {
  final File? image;
  final Uint8List? networkImageBytes;
  final VoidCallback onTap;
  final double size;
  final String? caption;

  const ImageBoxWidget({
    super.key,
    required this.image,
    required this.onTap,
    this.networkImageBytes,
    this.size = 100,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final hasLocalImage = image != null;
    final hasNetworkImage = !hasLocalImage && networkImageBytes != null;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: hasLocalImage
                  ? Image.file(image!, fit: BoxFit.cover, width: size, height: size)
                  : hasNetworkImage
                      ? Image.memory(networkImageBytes!, fit: BoxFit.cover, width: size, height: size)
                      : const Center(child: Icon(Icons.add_a_photo)),
            ),
          ),
          if (caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(caption!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
        ],
      ),
    );
  }
}
