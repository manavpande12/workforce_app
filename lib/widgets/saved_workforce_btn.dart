import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/services/workforce_save.dart';
import 'package:workforce_app/theme/color.dart';

class SavedWorkerButton extends StatefulWidget {
  final String workerId;
  final Function(String, bool) showMessage;

  const SavedWorkerButton({
    super.key,
    required this.workerId,
    required this.showMessage,
  });

  @override
  State<SavedWorkerButton> createState() => _SavedWorkerButtonState();
}

class _SavedWorkerButtonState extends State<SavedWorkerButton>
    with SingleTickerProviderStateMixin {
  bool isSaved = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Slow animation
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    checkIfSaved();
  }

  Future<void> checkIfSaved() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    final favRef =
        FirebaseFirestore.instance.collection('saved').doc(currentUserId);
    final snapshot = await favRef.get();

    if (snapshot.exists) {
      List<dynamic>? savedList = snapshot.data()?['saved'];
      if (savedList != null && savedList.contains(widget.workerId)) {
        setState(() => isSaved = true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleSavedStatus() {
    setState(() {
      if (isSaved) {
        unsavedWorker(widget.workerId, (message, isError) {
          widget.showMessage(message, isError);
        });
        isSaved = false;

        _rotationAnimation = Tween<double>(begin: 0, end: -0.25).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        ); // Rotate left when unsaving
      } else {
        savedWorker(widget.workerId, (message, isError) {
          widget.showMessage(message, isError);
        });
        isSaved = true;

        _rotationAnimation = Tween<double>(begin: 0, end: 0.25).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        ); // Rotate right when saving
      }

      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: toggleSavedStatus,
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 10.1416, // Convert to radians
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              ),
            ),
          );
        },
        child: Icon(
          isSaved ? Icons.star_rate_rounded : Icons.star_border_rounded,
          key: ValueKey<bool>(isSaved),
          size: 30,
          color: red,
        ),
      ),
    );
  }
}
