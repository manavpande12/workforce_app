import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/services/review_service.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class WorkerCard extends StatefulWidget {
  final String workerId;
  final String name;
  final String dpImageUrl;
  final String profileImageUrl;
  final String age;
  final String experience;

  const WorkerCard({
    super.key,
    required this.workerId,
    required this.name,
    required this.dpImageUrl,
    required this.profileImageUrl,
    required this.age,
    required this.experience,
  });

  @override
  State<WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<WorkerCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, viewProfile, arguments: widget.workerId);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Worker Background Image
          SizedBox(
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.dpImageUrl,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      ShimmerLoadingCard(height: 150),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, color: red),
                ),
              ),
            ),
          ),
          // Profile Picture (Top Left)
          Positioned(
            top: 30,
            left: 30,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.profileImageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    ShimmerLoadingCard(width: 120, height: 120),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, color: red),
              ),
            ),
          ),
          // Name (Top Right)
          Positioned(
            bottom: 45,
            right: 16,
            child: Container(
              width: 180,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? bgrey
                    : grey,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.elliptical(240, 240),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.name.split(' ').first.length > 10
                        ? "${widget.name.split(' ').first.substring(0, 10)}..."
                        : widget.name.split(' ').first,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.person, size: 20),
                ],
              ),
            ),
          ),

          // Worker Details (Bottom Right) with Real-time Rating
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              height: 30,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.elliptical(240, 240),
                ),
                gradient: LinearGradient(
                  colors: [yellow, red],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildWorkerDetail(
                      Icons.calendar_today, "${widget.age} Age", context),
                  _buildWorkerDetail(Icons.work_outline_rounded,
                      "${widget.experience} Yrs", context),
                  _buildRealTimeRating(
                      widget.workerId, context), // ✅ Real-time rating
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// StreamBuilder to fetch real-time worker rating
  Widget _buildRealTimeRating(String workerId, BuildContext context) {
    return StreamBuilder<int>(
      stream: calculateAverageRating(workerId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildWorkerDetail(Icons.star_border_rounded, "N/A", context);
        }
        int avgRating = snapshot.data ?? 0;
        return _buildWorkerDetail(
            Icons.star_border_rounded, "$avgRating", context);
      },
    );
  }

  Widget _buildWorkerDetail(IconData icon, String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Icon(icon, size: 15),
          SizedBox(width: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
