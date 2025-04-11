import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userImage;
  final String docId;

  const ChatAppBar({
    super.key,
    required this.userName,
    required this.userImage,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: yellow, // Change color as needed
      elevation: 0,
      title: InkWell(
        onTap: () {
          Navigator.pushNamed(context, viewProfile, arguments: docId);
        },
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: userImage,
                width: 35,
                height: 35,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    ShimmerLoadingCard(width: 35, height: 35),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, color: red),
              ),
            ),
            SizedBox(width: 10),
            Text(
              userName.split(" ").first,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
