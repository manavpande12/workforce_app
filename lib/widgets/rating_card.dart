import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class RatingCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String label;
  final String review;
  final int rating;
  final String date;

  const RatingCard({
    super.key,
    this.imageUrl,
    required this.name,
    required this.label,
    required this.review,
    required this.rating,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.dark
            ? bgrey.withValues(alpha: 0.6)
            : grey.withValues(alpha: 0.6),
      ),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: (imageUrl != null &&
                          imageUrl!.isNotEmpty &&
                          imageUrl!.startsWith('https'))
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              ShimmerLoadingCard(width: 60, height: 60),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: red),
                        )
                      : ShimmerLoadingCard(
                          width: 60,
                          height: 60,
                          borderRadius: 100,
                        ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.length > 18 ? '${name.substring(0, 18)}...' : name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 12),
                    ),
                    SizedBox(height: 3),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: yellow,
                      size: 20,
                    );
                  }),
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 10,
                      ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 85,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).brightness == Brightness.dark
                    ? bgrey
                    : grey,
              ),
              child:
                  Text(review, style: Theme.of(context).textTheme.titleSmall),
            )
          ],
        ),
      ),
    );
  }
}
