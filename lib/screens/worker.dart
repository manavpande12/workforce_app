import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';
import 'package:workforce_app/services/get_nearby.dart';
import 'package:workforce_app/widgets/worker_card.dart';

class WorkerScreen extends StatefulWidget {
  final String categoryName;
  const WorkerScreen({super.key, required this.categoryName});

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.categoryName)), // Show category in AppBar
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: GetNearby.getNearbyWorkers(widget.categoryName, 10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 5, // Show 5 shimmer placeholders while loading
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(15),
                child: ShimmerLoadingCard(),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No workers found nearby. Please ensure your location services are enabled and permission is granted.",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            );
          }

          List<QueryDocumentSnapshot> workers = snapshot.data!;

          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (context, index) {
              var worker = workers[index];

              return WorkerCard(
                workerId: worker.id,
                name: worker["name"],
                dpImageUrl: worker["dpImageUrl"],
                profileImageUrl: worker["imageUrl"],
                age: worker["age"],
                experience: worker["experience"],
              );
            },
          );
        },
      ),
    );
  }
}
