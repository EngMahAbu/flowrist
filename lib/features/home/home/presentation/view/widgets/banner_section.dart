 
import 'package:flowrist/features/home/home/domain/entities/home_entities/banner_payload_entity.dart';
import 'package:flutter/material.dart';
 

class BannerSection extends StatelessWidget {
  final BannerPayloadEntity payload;

  const BannerSection({
    super.key,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 6,
          child: Image.network(
            payload.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.error),
              );
            },
          ),
        ),
      ),
    );
  }
}