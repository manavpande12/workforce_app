import 'package:flutter/material.dart';
import 'package:workforce_app/screens/Chat/widgets/chat_app_bar.dart';
import 'package:workforce_app/screens/Chat/widgets/message_box_bubble.dart';
import 'package:workforce_app/screens/Chat/widgets/message_input_box.dart';
import 'package:workforce_app/services/chat_service.dart';

class MessageScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;
  final String userName;
  final String userImage;

  const MessageScreen({
    super.key,
    required this.userId,
    required this.currentUserId,
    required this.userName,
    required this.userImage,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();

  /// ✅ **Function to send message**
  void _sendMessage() {
    sendMessage(
      senderId: widget.currentUserId,
      receiverId: widget.userId,
      msgController: _messageController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        userName: widget.userName,
        userImage: widget.userImage,
        docId: widget.userId,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getMessages(widget.currentUserId, widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No messages yet.",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  );
                }

                List<Map<String, dynamic>> messages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var msg = messages[index];
                    bool isCurrentUser =
                        msg["senderId"] == widget.currentUserId;

                    return MessageBoxBubble(
                      senderImageUrl: isCurrentUser
                          ? msg["currentUserImageUrl"]
                          : msg["otherUserImageUrl"],
                      msg: msg["text"],
                      isCurrentUser: isCurrentUser,
                    );
                  },
                );
              },
            ),
          ),
          MessageInputBox(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
