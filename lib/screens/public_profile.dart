import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/services/connect_service.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/custom_button.dart';
import 'package:workforce_app/widgets/custom_container.dart';
import 'package:workforce_app/widgets/custom_icon_box.dart';
import 'package:workforce_app/widgets/custom_scaffold.dart';
import 'package:workforce_app/widgets/custom_skill_boxes.dart';
import 'package:workforce_app/widgets/profile_avatar.dart';
import 'package:workforce_app/widgets/profile_display.dart';
import 'package:workforce_app/widgets/saved_workforce_btn.dart';

class PublicProfileScreen extends StatefulWidget {
  final String id;

  const PublicProfileScreen({super.key, required this.id});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  String name = "Loading...";
  String imageUrl = "";
  String dpImageUrl = "";
  String bio = "";
  String age = "";
  String gender = "";
  String experience = "";
  List<String> skills = [];
  List<String> languages = [];
  bool termAccepted = false;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get();

    if (!mounted) return;

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          name = userData['name'] ?? "Unknown";
          imageUrl = userData['imageUrl'] ?? "";
          dpImageUrl = userData['dpImageUrl'] ?? "";
          bio = userData['bio'] ?? "No bio available";
          age = userData['age']?.toString() ?? "0";
          gender = userData['gender'] ?? "";
          experience = userData['experience']?.toString() ?? "0";
          skills = List<String>.from(userData['skills'] ?? []);
          languages = List<String>.from(userData['languages'] ?? []);
          termAccepted = userData['termsAccepted'] ?? false;
        });
      }
    } else {
      return;
    }
  }

  Icon getGenderIcon(String? value) {
    switch (value) {
      case "Male":
        return Icon(Icons.male, color: Colors.blue, size: 30);
      case "Female":
        return Icon(Icons.female, color: Colors.pink, size: 30);
      case "Other":
        return Icon(Icons.transgender, color: Colors.purple, size: 30);
      default:
        return Icon(Icons.arrow_drop_down, color: Colors.grey, size: 30);
    }
  }

  Color getGenderColor(String? value) {
    switch (value) {
      case "Male":
        return Colors.blueAccent;
      case "Female":
        return Colors.pinkAccent;
      case "Other":
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Icon(
              Icons.person,
              size: 30,
              color: red,
            ),
            SizedBox(width: 10),
            Text(
              name.split(' ').first.length > 10
                  ? "${name.split(' ').first.substring(0, 10)}. Profile"
                  : "${name.split(' ').first} Profile",
            )
          ],
        ),
        actions: [
          termAccepted
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SavedWorkerButton(
                    workerId: widget.id,
                    showMessage: (msg, isError) {
                      context.showSnackBar(msg, isError: isError);
                    },
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: !termAccepted
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileAvatar(radius: 80, iconSize: 80, oClr: yellow),
                  SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileDisplay(imageUrl: imageUrl, dpImageUrl: dpImageUrl),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 16,
                                ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.verified_rounded,
                            size: 30, color: Colors.lightBlue),
                        SizedBox(width: 10),
                        getGenderIcon(gender),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.description_outlined, color: red, size: 40),
                        SizedBox(width: 6),
                        Text("About",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    CustomContainer(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? bgrey
                              : grey,
                      height: 100,
                      des: bio,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconBox(
                            icon: Icons.calendar_today_rounded,
                            bgColor: red,
                            text: "$age yrs"),
                        CustomIconBox(
                            icon: getGenderIcon(gender).icon!,
                            bgColor: getGenderColor(gender),
                            text: gender.isNotEmpty ? "${gender[0]} ~" : ''),
                        CustomIconBox(
                            icon: Icons.work,
                            bgColor: black,
                            text: "$experience +"),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              icon: Icons.star,
                              iClr: black,
                              iSize: 25,
                              bgClr: yellow,
                              fgClr: black,
                              text: "Review",
                              onTap: () {
                                Navigator.pushNamed(context, review,
                                    arguments: widget.id);
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              icon: Icons.chat_rounded,
                              iClr: grey,
                              iSize: 25,
                              bgClr: Colors.blue,
                              fgClr: grey,
                              text: "Connect",
                              onTap: () {
                                saveUserToChat(widget.id);
                                Navigator.pushNamed(context, chat);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.design_services_outlined,
                            color: yellow, size: 40),
                        SizedBox(width: 6),
                        Text("Expert in a field.",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: skills.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CustomSkillBoxes(text: skills[index]);
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.language,
                            color: Colors.lightBlueAccent, size: 40),
                        SizedBox(width: 6),
                        Text("Communication.",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    CustomContainer(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? bgrey
                              : grey,
                      isScrollable: true,
                      height: 120,
                      items: languages,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
