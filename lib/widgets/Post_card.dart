import 'package:comm_safe/models/models.dart';
import 'package:comm_safe/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Positioned(child: _PostDescription(posts.detalle), top: 60, left: 25, right: 25),

//Positioned(child: _Backgroundimage(posts.picture), top: 130, left: 25, right: 25, bottom: 0)

class PostCard extends StatelessWidget {
  final Post posts;

  const PostCard({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);
    final index = postService.posts.indexWhere((element) => element.id == posts.id);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
          margin: EdgeInsets.only(top: 30, bottom: 20),
          width: double.infinity,
          decoration: _borderStyle(),
          child: Stack(children: [
            Positioned(
              child: _PostTitle(posts.titulo),
              top: 0,
              left: 0,
              right: 50,
            ),
            Positioned(
              child: IconButton(
                  onPressed: () {
                    postService.selectedPost = postService.posts[index].copy();
                    Navigator.pushNamed(context, 'post');
                  },
                  icon: Icon(Icons.edit, size: 25, color: Colors.grey)),
              top: 5,
              right: 5,
            ),
            Positioned(
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                  'Cuidado, ¿desea eliminar la publicacion permanentemente?'),
                              actions: [
                                TextButton(
                                    child: Text('Cancelar', style: TextStyle(fontSize: 16)),
                                    onPressed: () {
                                      Navigator.of(context).pop('cancel');
                                    }),
                                TextButton(
                                    child: Text('Aceptar',
                                        style: TextStyle(fontSize: 16)),
                                    onPressed: () async {
                                      await postService.deletePost(postService.posts[index]);
                                      Navigator.pushNamed(context, 'home');
                                      await postService.loadPosts();
                                    }),
                              ],
                            ));
                  },
                  icon: Icon(Icons.delete, size: 25, color: Colors.red)),
              top: 5,
              left: 5,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  _PostDescription(posts.detalle),
                  SizedBox(height: 20),
                  _Backgroundimage(posts.picture)
                ],
              ),
            ),
          ])),
    );
  }

  BoxDecoration _borderStyle() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 5), blurRadius: 10)
          ]);
}

class _PostTitle extends StatelessWidget {
  final titulo;

  const _PostTitle(this.titulo);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
          Center(
            child: Text('$titulo',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center),
          ),
          SizedBox(height: 5),
          Text('Etiquetas: robo a mano armada, hurto',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontStyle: FontStyle.italic))
        ]),
        decoration: BoxDecoration(
            color: Colors.lightBlue.shade300,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))),
        height: 60);
  }
}

class _PostDescription extends StatelessWidget {
  final String descripcion;

  const _PostDescription(this.descripcion);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        '$descripcion',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      )),

      decoration: BoxDecoration(
          border: Border.all(width: 0.7, color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10)),
      height: 100,
      //margin: const EdgeInsets.only(bottom: 175),
    );
  }
}

class _Backgroundimage extends StatelessWidget {
  final String url;

  const _Backgroundimage(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: url == null
          ? Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover)
          : FadeInImage(
              placeholder: AssetImage('assets/1.gif'),
              image: NetworkImage(url),
              fit: BoxFit.contain,
            ),
    );
  }
}
