import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workforce_app/constants/string.dart';
import 'package:workforce_app/models/languages.dart';
import 'package:workforce_app/providers/user_info_provider.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/custom_button.dart';
import 'package:workforce_app/widgets/custom_profile_header.dart';
import 'package:workforce_app/widgets/custom_dropdown.dart';
import 'package:workforce_app/widgets/custom_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workforce_app/widgets/custom_scaffold.dart';
import 'package:workforce_app/widgets/location_input.dart';
import 'package:workforce_app/widgets/multi_select_list.dart';
import 'package:workforce_app/widgets/select_category.dart';

class WorkForm extends ConsumerStatefulWidget {
  final String title;
  final bool isJoin;
  const WorkForm({super.key, required this.title, required this.isJoin});

  @override
  ConsumerState<WorkForm> createState() => _WorkFormState();
}

class _WorkFormState extends ConsumerState<WorkForm> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final data = ref.watch(userProvider);
      if (data != null) {
        setState(() {
          _enteredName = data.name;
          _enteredEmail = data.email;
          _selectedGender = data.gender;
          _selectedEmployed = data.employed;
          _enteredContact = data.contact;
          _enteredExperience = data.experience;
          _enteredAge = data.age;
          _enteredBio = data.bio;
          _selectedLat = data.lat;
          _selectedLng = data.lng;
          _selectedAddress = data.address;
          _selectedSkills = data.skills;
          _selectedLang = data.languages;

          _nameController.text = data.name;
          _emailController.text = data.email;
          _contactController.text = data.contact;
          _experienceController.text = data.experience;
          _ageController.text = data.age;
          _bioController.text = data.bio;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _experienceController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _print() {
    debugPrint("""
      NAME: ${_nameController.text}
      EMAIL: ${_emailController.text}
      GENDER: $_selectedGender
      EMPLOYED: $_selectedEmployed
      CONTACT: ${_contactController.text}
      EXPERIENCE: ${_experienceController.text}
      AGE: ${_ageController.text}
      BIO: ${_bioController.text}
      LATITUDE: $_selectedLat
      LONGITUDE: $_selectedLng
      ADDRESS: $_selectedAddress
      SKILLS: ${_selectedSkills.join(", ")}
      LANGUAGES: ${_selectedLang.join(", ")}
      DP: $_selectedDesktopImage
      PP: $_selectedProfileImage
      IS CHECKED: $_isChecked
    """);
  }

  String cleanInput(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _isEdit() {
    if (widget.title.contains("Enhance Your Profile")) {
      _isEditingMode = true;
    } else {
      _isEditingMode = false;
    }
    return _isEditingMode;
  }

  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  var _isJoin = false;
  var _isLoading = false;
  File? _selectedProfileImage;
  File? _selectedDesktopImage;
  String? _enteredName;
  String? _enteredEmail;
  String? _selectedGender;
  String? _selectedEmployed;
  String? _enteredContact;
  String? _enteredExperience;
  String? _enteredAge;
  String? _enteredBio;
  double? _selectedLat;
  double? _selectedLng;
  String? _selectedAddress;
  List<String> _selectedSkills = [];
  List<String> _selectedLang = [];
  bool _isChecked = false;
  bool _isEditingMode = false;

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  void _join(String? imageUrl, dpImgUrl) async {
    _enteredName = cleanInput(_nameController.text);
    _enteredEmail = cleanInput(_emailController.text);
    _enteredContact = cleanInput(_contactController.text);
    _enteredExperience = cleanInput(_experienceController.text);
    _enteredAge = cleanInput(_ageController.text);
    _enteredBio = cleanInput(_bioController.text);
    if (user == null) {
      context.showSnackBar('User is not logged in', isError: true);
      return;
    }

    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (!isValid ||
        (_selectedProfileImage == null && imageUrl == null) ||
        (_selectedDesktopImage == null && dpImgUrl == "") ||
        _selectedSkills.isEmpty ||
        _selectedLang.isEmpty ||
        _selectedAddress == "" ||
        _selectedLat == null ||
        _selectedLat == 0.0 ||
        _selectedLng == null ||
        _selectedLng == 0.0 ||
        !_isChecked) {
      context.showSnackBar('Please fill out all the details.', isError: true);
      return;
    }
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    try {
      setState(() {
        _isLoading = true;
      });

      String? ppImageUrl = imageUrl;
      String? dpImageUrl = dpImgUrl;

      // Upload Profile Image
      if (_selectedProfileImage != null) {
        final profileStorageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${user!.uid}.jpg');
        await profileStorageRef.putFile(_selectedProfileImage!);
        ppImageUrl = await profileStorageRef.getDownloadURL();
      }

      // Upload Desktop Image
      if (_selectedDesktopImage != null) {
        final desktopStorageRef = FirebaseStorage.instance
            .ref()
            .child('user_dpimages')
            .child('${user!.uid}.jpg');
        await desktopStorageRef.putFile(_selectedDesktopImage!);
        dpImageUrl = await desktopStorageRef.getDownloadURL();
      }

      // Update user profile in Firestore & Riverpod state
      ref.read(userProvider.notifier).updateProfile(
            name: _enteredName!,
            email: _enteredEmail!,
            imageUrl: ppImageUrl!,
            dpimageUrl: dpImageUrl!,
            gender: _selectedGender!,
            employed: _selectedEmployed!,
            contact: _enteredContact!,
            age: _enteredAge!,
            experience: _enteredExperience!,
            bio: _enteredBio!,
            lat: _selectedLat!,
            lng: _selectedLng!,
            address: _selectedAddress!,
            skills: _selectedSkills,
            languages: _selectedLang,
            termsAccepted: _isChecked,
          );
      setState(() {
        _isJoin = true;
      });
      if (mounted) {
        context.showSnackBar("Information is saved successfully.",
            isError: false);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        context.showSnackBar('Joining Failed:${e.toString()}', isError: true);
      }
    } catch (e) {
      if (mounted) context.showSnackBar(e.toString(), isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _isJoin
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isEdit()
                              ? "Profile Updated Successfully."
                              : "Thank you for joining WorkForce.",
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          fgClr: black,
                          bgClr: yellow,
                          text: "View Your Profile",
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              tabs,
                              (route) => false,
                              arguments: 3,
                            );
                          },
                          iClr: black,
                          icon: Icons.remove_red_eye_outlined,
                          iSize: 30,
                        )
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomProfileHeader(
                            imageUrl: user?.imageUrl,
                            dpImageUrl: user?.dpImageUrl,
                            onPickProfileImage: (pickedImage) {
                              _selectedProfileImage = pickedImage;
                            },
                            onPickDesktopImage: (pickedImage) {
                              _selectedDesktopImage = pickedImage;
                            },
                          ),
                          SizedBox(height: 10),
                          CustomInput(
                            defaultIcon: const Icon(Icons.person),
                            labelText: "Name",
                            enableSuggestions: true,
                            maxLength: 50,
                            controller: _nameController,
                            kType: TextInputType.name,
                            validationType: ValidationType.name,
                          ),
                          SizedBox(height: 10),
                          CustomInput(
                            defaultIcon: const Icon(Icons.email),
                            labelText: "Email",
                            maxLength: 100,
                            readOnly: true,
                            controller: _emailController,
                            validationType: ValidationType.email,
                            kType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 10),
                          CustomDropdownInput(
                            defaultIcon: Icon(Icons.diversity_1),
                            selectedValue: user?.gender ?? "",
                            labelText: "Gender",
                            options: ["Male", "Female", "Other"],
                            onSaved: (value) => _selectedGender = value!,
                          ),
                          SizedBox(height: 10),
                          CustomDropdownInput(
                            defaultIcon: Icon(Icons.work),
                            selectedValue: user?.employed ?? "",
                            labelText: "Employed",
                            options: ["Yes", "No"],
                            onSaved: (value) => _selectedEmployed = value!,
                          ),
                          SizedBox(height: 10),
                          CustomInput(
                            defaultIcon: const Icon(Icons.phone),
                            labelText: "Contact",
                            controller: _contactController,
                            maxLength: 10,
                            validationType: ValidationType.contact,
                            kType: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomInput(
                                  defaultIcon: const Icon(Icons.work_history),
                                  labelText: "Experience",
                                  controller: _experienceController,
                                  validationType: ValidationType.experience,
                                  maxLength: 2,
                                  kType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: CustomInput(
                                  defaultIcon: const Icon(Icons.calendar_today),
                                  labelText: "Age",
                                  controller: _ageController,
                                  validationType: ValidationType.age,
                                  maxLength: 2,
                                  kType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          CustomInput(
                            defaultIcon: const Icon(Icons.description),
                            labelText: "Bio For Your Profile",
                            controller: _bioController,
                            kType: TextInputType.multiline,
                            enableSuggestions: true,
                            maxLength: 121,
                            maxLines: 4,
                            validationType: ValidationType.none,
                          ),
                          SizedBox(height: 10),
                          LocationInput(
                            initialLat: user?.lat ?? 0.0,
                            initialLng: user?.lng ?? 0.0,
                            initialAddress: user?.address ?? "",
                            onSelectLocation: (latitude, longitude, address) {
                              _selectedLat = latitude;
                              _selectedLng = longitude;
                              _selectedAddress = address;
                            },
                          ),
                          SizedBox(height: 10),
                          SelectCategory(
                            selectedSkills: user?.skills ?? _selectedSkills,
                            onSelect: (List<String> selected) {
                              setState(() {
                                _selectedSkills = selected;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          MultiSelectList(
                            title: "Please Choose A Language",
                            description:
                                "Please choose your native language first, then other languages. These will help to get opportunities.",
                            allOptions: worldLanguages,
                            selectedOptions: user?.languages ?? _selectedLang,
                            onSelectionChanged: (List<String> selected) {
                              setState(() {
                                _selectedLang = selected;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                activeColor: red,
                                value: _isChecked,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isChecked = newValue!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  _isEdit()
                                      ? "Save the edits."
                                      : "By filling out this form, you agree to the terms and conditions. All information provided is secure and will be used solely for professional purposes within WorkForce. Your privacy is important to us.",
                                  textAlign: TextAlign.justify,
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              fgClr: black,
                              bgClr: yellow,
                              text: widget.title,
                              onTap: () {
                                _print();
                                _join(user?.imageUrl, user?.dpImageUrl);
                              },
                              iClr: black,
                              icon: Icons.handshake_outlined,
                              iSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
