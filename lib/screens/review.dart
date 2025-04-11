import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/services/review_service.dart';
import 'package:workforce_app/widgets/rating_box.dart';
import 'package:workforce_app/widgets/rating_card.dart';

class ReviewScreen extends StatefulWidget {
  final String id;
  const ReviewScreen({super.key, required this.id});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Review")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (currentUser!.uid != widget.id) RatingBox(otherId: widget.id),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: fetchWorkerReviews(widget.id), // 🔥 Fetch reviews live
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No reviews yet."));
                  }

                  List<Map<String, dynamic>> reviews = snapshot.data!;

                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      var review = reviews[index];
                      return RatingCard(
                        imageUrl: review['imageUrl'],
                        label: review['label'],
                        name: review['name'],
                        rating: (review['rating'] as num).toInt(),
                        review: review['review'],
                        date: review['timestamp'] != null
                            ? review['timestamp']
                                .toDate()
                                .toString()
                                .split(' ')[0]
                            : ".....",
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
