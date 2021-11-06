import 'dart:convert';
import 'dart:io';
import 'package:comm_safe/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostService with ChangeNotifier {
  final String _baseUrl = 'commsafe-cbacc-default-rtdb.firebaseio.com';
  List<Post> posts = [];
  Post selectedPost;

  File pictureFile;

  bool isLoading = true;
  bool isSaving = false;
  bool isDelete = false;

  PostService() {
    print('Hollaaaa------');
    this.loadPosts();
  }

  Future<List<Post>> loadPosts() async {
    this.posts = [];
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'posts.json');
    final resp = await http.get(url);

    final Map<String, dynamic> postsMap = json.decode(resp.body);

    postsMap.forEach((key, value) {
      final tempPost = Post.fromMap(value);
      tempPost.id = key;
      this.posts.add(tempPost);
    });

    this.isLoading = false;
    notifyListeners();

    return this.posts;
  }

  Future saveOrCreatePost(Post post) async {
    isSaving = true;
    notifyListeners();

    if (post.id == null) {
      await this.createPost(post);
    } else {
      await this.updatePost(post);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updatePost(Post post) async {
    final url = Uri.https(_baseUrl, 'posts/${post.id}.json');
    final resp = await http.put(url, body: post.toJson());
    final decoderData = resp.body;

    final index = this.posts.indexWhere((element) => element.id == post.id);
    this.posts[index] = post;

    return post.id;
  }

  Future<String> createPost(Post post) async {
    final url = Uri.https(_baseUrl, 'posts.json');
    final resp = await http.post(url, body: post.toJson());
    final decoderData = json.decode(resp.body);

    post.id = decoderData['name'];

    this.posts.add(post);

    return post.id;
  }

  Future<String> deletePost(Post post) async {
    this.isDelete = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'posts/${post.id}.json');
    final resp = await http.delete(url, body: post.toJson());
    final decoderData = json.decode(resp.body);

    final index = this.posts.indexWhere((element) => element.id == post.id);
    this.posts[index] = post;

    this.isDelete = true;
    notifyListeners();

    return post.id;
  }

  void updateoruploadImage(String path) {
    this.selectedPost.picture = path;
    this.pictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String> uploadImage() async {
    if (this.pictureFile == null) return null;
    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/commsafe/image/upload?upload_preset=h1hdfcmt');

    final imageUploadRequest = http.MultipartRequest('POST', url);

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
