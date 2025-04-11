import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/providers/user_info_provider.dart';
import 'package:workforce_app/widgets/custom_button.dart';
import 'package:workforce_app/widgets/custom_container.dart';
import 'package:workforce_app/widgets/custom_icon_box.dart';
import 'package:workforce_app/widgets/custom_skill_boxes.dart';
import 'package:workforce_app/widgets/profile_avatar.dart';
import 'package:workforce_app/widgets/profile_display.dart';
import 'package:workforce_app/theme/color.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isProfile = false;
  String name = "Loading...";
  String imageUrl = "";
  String dpImageUrl = "";
  String bio = "";
  String age = "";
  String gender = "";
  String experience = "";
  List<String> skills = [];
  List<String> languages = [];
  String id = "";

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
    final user = ref.watch(userProvider);
    if (user != null) {
      setState(() {
        isProfile = user.termsAccepted;
        name = user.name;
        imageUrl = user.imageUrl;
        dpImageUrl = user.dpImageUrl;
        bio = user.bio;
        age = user.age;
        gender = user.gender;
        experience = user.experience;
        skills = List<String>.from(user.skills);
        languages = List<String>.from(user.languages);
        id = user.uid;
      });
    }

    if (!isProfile) {
      return Center(
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.person,
              size: 30,
              color: red,
            ),
            SizedBox(width: 10),
            Text("${name.split(' ').first} Profile"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                          .copyWith(fontSize: 16),
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
                  Text("About", style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              CustomContainer(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? bgrey
                          : grey,
                  height: 100,
                  des: bio),
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
                      icon: Icons.work, bgColor: black, text: "$experience +"),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  icon: Icons.auto_fix_high,
                  iClr: white,
                  iSize: 25,
                  bgClr: red,
                  fgClr: white,
                  text: "Enhance Profile",
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      join,
                      arguments: {
                        "joined": true,
                        "title": "Enhance Your Profile",
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  icon: Icons.star,
                  iClr: black,
                  iSize: 25,
                  bgClr: yellow,
                  fgClr: black,
                  text: "Check Review",
                  onTap: () {
                    Navigator.pushNamed(context, review, arguments: id);
                  },
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.design_services_outlined, color: yellow, size: 40),
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
                  Icon(Icons.language, color: Colors.lightBlueAccent, size: 40),
                  SizedBox(width: 6),
                  Text("Communication.",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              CustomContainer(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
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
