import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workforce_app/services/workforce_save.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/shimmer_loading.dart';
import 'package:workforce_app/widgets/worker_card.dart';

class Workforce extends StatefulWidget {
  const Workforce({super.key});

  @override
  State<Workforce> createState() => _WorkforceState();
}

class _WorkforceState extends State<Workforce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My WorkForce"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              FontAwesomeIcons.fire,
              size: 30.0,
              color: red,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "🚨 Emergency Ready! ⚡🛠️\n",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: red),
                  ),
                  TextSpan(
                    text:
                        "When the unexpected happens, your saved heroes are just a tap away! ",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextSpan(
                    text:
                        "Be it a leaking pipe, a power cut, or a last-minute fix—help is always within reach. 🚑🔧",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? white
                              : black,
                        ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: fetchSavedWorkers(),
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
                      child: Text(
                    "No saved workers found.",
                    style: Theme.of(context).textTheme.titleSmall,
                  ));
                }

                List<Map<String, dynamic>> workers = snapshot.data!;
                return ListView.builder(
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    var worker = workers[index];
                    return WorkerCard(
                      workerId: worker["workerId"],
                      name: worker["name"],
                      dpImageUrl: worker["dpImageUrl"],
                      profileImageUrl: worker["profileImageUrl"],
                      age: worker["age"],
                      experience: worker["experience"],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
