import 'package:comm_safe/models/models.dart';
import 'package:comm_safe/screens/screens.dart';
import 'package:comm_safe/services/services.dart';
import 'package:comm_safe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (postService.isLoading) {
      return LoadingScreen();
    } else {
      return FutureBuilder(
          future: authService.readId(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Post> misPosts = postService.posts
                .where((element) => element.idUser == snapshot.data)
                .toList();
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Mis Publicaciones',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                backgroundColor: Colors.white,
              ),
              body: ListView.builder(
                itemCount: misPosts.length,
                //el metodo PostCard() se encuentra dentro de la carpeta widgets en el archivo Post_card.dart
                itemBuilder: (BuildContext context, int index) =>
                    PostCard(posts: misPosts[index]),
              ),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    postService.selectedPost =
                        new Post(titulo: '', detalle: '');

                    Navigator.pushNamed(context, 'post');
                  }),
            );
          });
    }
  }
}
