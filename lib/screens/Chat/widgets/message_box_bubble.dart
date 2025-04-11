import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class MessageBoxBubble extends StatelessWidget {
  final String senderImageUrl;
  final String msg;
  final bool isCurrentUser;

  const MessageBoxBubble({
    super.key,
    required this.senderImageUrl,
    required this.msg,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isCurrentUser
            ? [
                _buildMessageBubble(context),
                const SizedBox(width: 10),
                _buildProfileImage(),
              ]
            : [
                _buildProfileImage(),
                const SizedBox(width: 10),
                _buildMessageBubble(context),
              ],
      ),
    );
  }

  // ✅ Profile Image Widget
  Widget _buildProfileImage() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        child: ClipOval(
          child:
              (senderImageUrl.isNotEmpty && senderImageUrl.startsWith('https'))
                  ? CachedNetworkImage(
                      imageUrl: senderImageUrl,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          ShimmerLoadingCard(width: 36, height: 36),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: red),
                    )
                  : ShimmerLoadingCard(
                      width: 36,
                      height: 36,
                      borderRadius: 100,
                    ),
        ),
      ),
    );
  }

  // ✅ Message Bubble Widget
  Widget _buildMessageBubble(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260, minWidth: 100),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isCurrentUser
            ? yellow
            : Theme.of(context).brightness == Brightness.dark
                ? bgrey
                : grey,
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        msg.isEmpty ? '...' : msg,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: isCurrentUser
                  ? black.withValues(alpha: 0.6)
                  : Theme.of(context).brightness == Brightness.dark
                      ? white
                      : black.withValues(alpha: 0.6),
            ),
      ),
    );
  }
}
