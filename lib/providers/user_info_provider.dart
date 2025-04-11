import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workforce_app/models/user_info.dart';
import 'package:workforce_app/services/auth_service.dart';
import 'package:workforce_app/services/update_profile.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  final AuthService _authService;
  final UpdateProfile _updateProfile;

  UserNotifier(this._authService, this._updateProfile) : super(null) {
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    state = await _authService.getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = await _authService.login(email, password);
  }

  Future<void> signup(
      String email, String password, String name, File image) async {
    state = await _authService.signup(email, password, name, image);
  }

  Future<void> logout() async {
    await _authService.logout();
    state = null;
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String imageUrl,
    required String dpimageUrl,
    required String gender,
    required String employed,
    required String contact,
    required String age,
    required String experience,
    required String bio,
    required double lat,
    required double lng,
    required String address,
    required List<String> skills,
    required List<String> languages,
    required bool termsAccepted,
  }) async {
    await _updateProfile.updateProfile(
      name: name,
      email: email,
      imageUrl: imageUrl,
      dpimageUrl: dpimageUrl,
      gender: gender,
      employed: employed,
      contact: contact,
      age: age,
      experience: experience,
      bio: bio,
      lat: lat,
      lng: lng,
      address: address,
      skills: skills,
      languages: languages,
      termsAccepted: termsAccepted,
    );

    // Update local state
    state = state?.copyWith(
      name: name,
      email: email,
      imageUrl: imageUrl,
      dpImageUrl: dpimageUrl,
      gender: gender,
      employed: employed,
      contact: contact,
      age: age,
      experience: experience,
      bio: bio,
      lat: lat,
      lng: lng,
      address: address,
      skills: skills,
      languages: languages,
      termsAccepted: termsAccepted,
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier(AuthService(), UpdateProfile());
});
