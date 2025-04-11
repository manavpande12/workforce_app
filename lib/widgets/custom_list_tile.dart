import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class CustomListTile extends StatelessWidget {
  final String userId;
  final String name;
  final String sub;
  final String imageUrl;
  final VoidCallback onTap;
  final ConfirmDismissCallback? onConfirmDismissed;
  final void Function(DismissDirection)? onDismissed;
  final bool onSub;

  const CustomListTile({
    super.key,
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.onTap,
    required this.onConfirmDismissed,
    required this.onDismissed,
    this.sub = "",
    this.onSub = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(userId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: red,
        child: Icon(Icons.delete, color: white),
      ),
      confirmDismiss: onConfirmDismissed,
      onDismissed: onDismissed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? bgrey
                        : grey,
                    width: 1),
              ),
            ),
            child: ListTile(
              leading: imageUrl.startsWith('http')
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            ShimmerLoadingCard(width: 40, height: 40),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: red),
                      ),
                    )
                  : const CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: onSub
                  ? Text(
                      sub.length > 25
                          ? "${sub.substring(0, 25)}..."
                          : sub, // Limit to 25 chars
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 10,
                          ),
                    )
                  : null, // If `onSub` is false, hide the subtitle

              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
