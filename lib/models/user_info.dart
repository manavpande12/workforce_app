class UserModel {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final String dpImageUrl;
  final String gender;
  final String employed;
  final String contact;
  final String age;
  final String experience;
  final String bio;
  final double lat;
  final double lng;
  final String address;
  final List<String> skills;
  final List<String> languages;
  final bool termsAccepted;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.dpImageUrl,
    required this.gender,
    required this.employed,
    required this.contact,
    required this.age,
    required this.experience,
    required this.bio,
    required this.lat,
    required this.lng,
    required this.address,
    required this.skills,
    required this.languages,
    required this.termsAccepted,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      dpImageUrl: data['dpImageUrl'] ?? '',
      gender: data['gender'] ?? '',
      employed: data['employed'] ?? '',
      contact: data['contact'] ?? '',
      age: data['age'] ?? '',
      experience: data['experience'] ?? '',
      bio: data['bio'] ?? '',
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0, // Fix for null safety
      lng: (data['lng'] as num?)?.toDouble() ?? 0.0, // Fix for null safety
      address: data['address'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      languages: List<String>.from(data['languages'] ?? []),
      termsAccepted: data['termsAccepted'] ?? false,
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? imageUrl,
    String? dpImageUrl,
    String? gender,
    String? employed,
    String? contact,
    String? age,
    String? experience,
    String? bio,
    double? lat,
    double? lng,
    String? address,
    List<String>? skills,
    List<String>? languages,
    bool? termsAccepted,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      dpImageUrl: dpImageUrl ?? this.dpImageUrl,
      gender: gender ?? this.gender,
      employed: employed ?? this.employed,
      contact: contact ?? this.contact,
      age: age ?? this.age,
      experience: experience ?? this.experience,
      bio: bio ?? this.bio,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }
}
