import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;

  const ProductImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.white,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: Colors.red,),
        ),
        errorWidget: (context, url, error) => 
            const Icon(Icons.broken_image, size: 100, color: Colors.grey),
        ),
      );
  }
}