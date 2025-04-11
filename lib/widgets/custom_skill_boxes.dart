import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';

class CustomSkillBoxes extends StatelessWidget {
  final String text;

  const CustomSkillBoxes({
    super.key,
    required this.text,
  });

  // Function to fetch the icon URL for a given text (category title)
  Stream<String?> getIconUrl() {
    return FirebaseFirestore.instance
        .collection('category')
        .where("title", isEqualTo: text)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();
        if (data.containsKey('iconUrl') && data['iconUrl'] != null) {
          return data['iconUrl'] as String;
        }
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: getIconUrl(),
      builder: (context, snapshot) {
        String? iconUrl = snapshot.data;

        return Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color:
                Theme.of(context).brightness == Brightness.dark ? bgrey : grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: RadialGradient(
                    colors: [
                      yellow,
                      red,
                    ],
                    radius: 0.4,
                    tileMode: TileMode.decal,
                  ),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: iconUrl != null
                        ? CachedNetworkImage(
                            imageUrl: iconUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SizedBox(
                              width: 80,
                              height: 80,
                              child: Center(
                                child: ShimmerLoadingCard(
                                  width: 80,
                                  height: 80,
                                  borderRadius: 100,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.error,
                              color: red,
                              size: 80,
                            ),
                          )
                        : ShimmerLoadingCard(
                            width: 80,
                            height: 80,
                            borderRadius: 100,
                          ),
                  ),
                ),
              ),
              SizedBox(width: 10), // Space between image and text
              Text(
                text,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}
