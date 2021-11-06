import 'dart:convert';
import 'dart:io';
import 'package:comm_safe/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileService with ChangeNotifier {
  final String _baseUrl = 'commsafe-cbacc-default-rtdb.firebaseio.com';
  List<Profile> profiles = [];
  Profile selectedProfile;

  File pictureFile;

  bool isLoading = true;
  bool isSaving = false;
  bool isDelete = false;

  ProfileService() {
    this.loadProfiles();
  }

  Future<List<Profile>> loadProfiles() async {
    
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'Profiles.json');
    final resp = await http.get(url);

    final Map<String, dynamic> profileMap = json.decode(resp.body);

    profileMap.forEach((key, value) {
      final tempProfile = Profile.fromMap(value);
      tempProfile.id = key;
      this.profiles.add(tempProfile);
    });

    this.isLoading = false;
    notifyListeners();

    return this.profiles;
  }

  Future saveOrCreateProfile(Profile profile) async {
    isSaving = true;
    notifyListeners();

    await this.updateProfile(profile);

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProfile(Profile profile) async {
    final url = Uri.https(_baseUrl, 'Profiles/${profile.id}.json');
    final resp = await http.put(url, body: profile.toJson());
    final decoderData = resp.body;

    final index = this.profiles.indexWhere((element) => element.id == profile.id);
    this.profiles[index] = profile;

    return profile.id;
  }

  // Future<String> createprofile(Profile profile) async {
  //   final url = Uri.https(_baseUrl, 'Profiles.json');
  //   final resp = await http.profile(url, body: profile.toJson());
  //   final decoderData = json.decode(resp.body);

  //   profile.id = decoderData['name'];

  //   this.profile.add(profile);

  //   return profile.id;
  // }

  // Future<String> deleteProfile(Profile Profile) async {
  //   this.isDelete = true;
  //   notifyListeners();

  //   final url = Uri.https(_baseUrl, 'Profiles/${Profile.id}.json');
  //   final resp = await http.delete(url, body: Profile.toJson());
  //   final decoderData = json.decode(resp.body);

  //   final index = this.profile.indexWhere((element) => element.id == Profile.id);
  //   this.profile[index] = profile;

  //   this.isDelete = true;
  //   notifyListeners();

  //   return Profile.id;
  // }

  void updateoruploadImage(String path) {
    this.selectedProfile.picture = path;
    this.pictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String> uploadImage() async {
    if (this.pictureFile == null) return null;
    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/commsafe/image/upload?upload_preset=h1hdfcmt');

    final imageUploadRequest = http.MultipartRequest('Profile', url);

    final file = await http.MultipartFile.fromPath('file', pictureFile.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    this.pictureFile = null;

    final decodeData = json.decode(resp.body);
    return decodeData['secure_url'];
  }
}