import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class ProfileDisplay extends StatelessWidget {
  final String? imageUrl;
  final String? dpImageUrl;
  final double avatarRadius;
  final double iconSize;
  final Color borderColor;

  const ProfileDisplay({
    super.key,
    required this.imageUrl,
    required this.dpImageUrl,
    this.avatarRadius = 60,
    this.iconSize = 50,
    this.borderColor = Colors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Image or Gradient
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: (dpImageUrl != null &&
                    dpImageUrl!.isNotEmpty &&
                    dpImageUrl!.startsWith('https'))
                ? CachedNetworkImage(
                    imageUrl: dpImageUrl!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        ShimmerLoadingCard(height: 150),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, color: red),
                  )
                : ShimmerLoadingCard(height: 150),
          ),
        ),

        // Profile Avatar
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: ClipOval(
              child: (imageUrl != null &&
                      imageUrl!.isNotEmpty &&
                      imageUrl!.startsWith('https'))
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          ShimmerLoadingCard(width: 120, height: 120),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: red),
                    )
                  : ShimmerLoadingCard(
                      width: 120,
                      height: 120,
                      borderRadius: 100,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
