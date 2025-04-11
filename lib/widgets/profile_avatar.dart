import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workforce_app/providers/user_info_provider.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class ProfileAvatar extends ConsumerWidget {
  final double radius;
  final double iconSize;
  final Color oClr;

  const ProfileAvatar({
    super.key,
    required this.radius,
    required this.iconSize,
    required this.oClr,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null || user.imageUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: grey,
        child: Icon(
          Icons.person,
          size: iconSize,
          color: white,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: oClr, width: 2),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: grey,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.imageUrl,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                ShimmerLoadingCard(width: radius * 2, height: radius * 2),
            errorWidget: (context, url, error) => Icon(Icons.error, color: red),
          ),
        ),
      ),
    );
  }
}
