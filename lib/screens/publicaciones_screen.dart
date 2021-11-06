import 'package:comm_safe/models/models.dart';
import 'package:comm_safe/screens/screens.dart';
import 'package:comm_safe/services/services.dart';
import 'package:comm_safe/widgets/Post_card_home.dart';
import 'package:comm_safe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  //NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  double _height = 0;
  List<dynamic> comentarios = [];

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);

    if (postService.isLoading) {
      print('Hollaaaa');
      return LoadingScreen();
    } else {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () => postService.loadPosts(),
          child: Stack(children: [
            ListView.builder(
                itemCount: postService.posts.length,
                //el metodo PostCard() se encuentra dentro de la carpeta widgets en el archivo Post_card.dart
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                      child: PostCardHome(posts: postService.posts[index]),
                      onTap: () {
                        setState(() {
                          _height = 400.0;
                          comentarios = postService.posts[index].comentarios;
                          if (comentarios != null) {
                            comentarios
                                .removeWhere((element) => element == null);
                          }
                        });
                      },
                    )),
            comentariosScreen(),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              postService.selectedPost = new Post(titulo: '', detalle: '');

              Navigator.pushNamed(context, 'post');
            }),
      );
    }
  }

  Widget comentariosScreen() {
    return Align(
        alignment: Alignment.bottomLeft,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          width: double.infinity,
          height: _height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              color: Colors.grey[200],
              border: Border.all(color: Colors.black26)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //SizedBox(height: 10.0),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _height = 0;
                        });
                      },
                      icon: Icon(Icons.arrow_back)),
                  Text('Comentarios',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 20)),
                ],
              ),

              Flexible(fit: FlexFit.loose, child: _commentList()),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  maxLength: 35,
                  //initialValue: post.titulo,
                  //onChanged: (value) => post.titulo = value,
                  //validator: (value){if(value == null || value.length < 1) return 'Titulo obligatorio';},
                  autocorrect: false,

                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Titulo',
                      labelText: 'Comentario'),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _commentList() {
    if (comentarios == null) {
      return Text("Aun no hay comentarios");
    }

    return ListView.builder(
        //shrinkWrap: true,
        padding: EdgeInsets.all(10.0),
        itemCount: comentarios.length,
        itemBuilder: (BuildContext context, int index) => Card(
              child: ListTile(
                title: Text('Fecha y hora'),
                subtitle: Text(comentarios[index].toString()),
              ),
            ));
  }
}
