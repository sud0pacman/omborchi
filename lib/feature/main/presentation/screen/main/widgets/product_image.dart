import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<Uint8List> loadImageBytes(String path) async {
  return await compute(_readFileBytes, path);
}

Uint8List _readFileBytes(String path) {
  return File(path).readAsBytesSync();
}

class ProductImage extends StatelessWidget {
  final String? imagePath;

  const ProductImage({Key? key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: loadImageBytes(imagePath ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Icon(Icons.error));
        }

        return Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
