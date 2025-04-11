import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:workforce_app/models/user_info.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      log("no user found");
      return null;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      log(" user found, doc created");
      return UserModel.fromMap(doc.data()!, user.uid);
    }
    return null;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<UserModel?> signup(
      String email, String password, String name, File image) async {
    try {
      final authCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authCredential.user == null) {
        log("User creation failed");
        return null;
      }

      log("User created Successfully");

      // Upload image to Firebase Storage
      final storageRef = _storage
          .ref()
          .child('user_images')
          .child('${authCredential.user!.uid}.jpg');
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();

      // Save user data to Firestore
      final userModel = UserModel(
        uid: authCredential.user!.uid,
        name: name,
        email: email,
        imageUrl: imageUrl,
        dpImageUrl: '',
        gender: '',
        employed: '',
        contact: '',
        age: '',
        experience: '',
        bio: '',
        lat: 0.0,
        lng: 0.0,
        address: '',
        skills: [],
        languages: [],
        termsAccepted: false,
      );

      await _firestore.collection('users').doc(authCredential.user!.uid).set({
        'name': userModel.name,
        'email': userModel.email,
        'imageUrl': userModel.imageUrl,
        'createdAt': Timestamp.now(),
      });

      log("User data saved Successfully");
      return userModel;
    } on FirebaseAuthException catch (e) {
      log("Auth Error: ${e.message!}");
      rethrow;
    } catch (e) {
      log("General Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final authCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authCredential.user != null) {
        log("User logged in Successfully");
        return await getCurrentUser();
      }
      return null;
    } catch (e) {
      log("Login Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      log("User logged out");
    } catch (e) {
      log("Logout Error: ${e.toString()}");
      rethrow;
    }
  }
}
