import 'package:comm_safe/provider/post_form_provider.dart';
import 'package:comm_safe/screens/home_screen.dart';
import 'package:comm_safe/services/post_service.dart';
import 'package:comm_safe/services/services.dart';
import 'package:comm_safe/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);

    return ChangeNotifierProvider(
        create: (_) => PostFormProvider(postService.selectedPost),
        child: _PostScreenBody(postService: postService));
  }
}

class _PostScreenBody extends StatelessWidget {
  const _PostScreenBody({
    Key key,
    @required this.postService,
  }) : super(key: key);

  final PostService postService;

  @override
  Widget build(BuildContext context) {
    final postForm = Provider.of<PostFormProvider>(context);

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [
            Stack(
              children: [
                PostImage(postService.selectedPost.picture),
                Positioned(
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios,
                          size: 40, color: Colors.white)),
                  top: 60,
                  left: 20,
                ),
                Positioned(
                  child: IconButton(
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final PickedFile pickedFile = await picker.getImage(
                            source: ImageSource.camera, imageQuality: 100);

                        if (pickedFile == null) {
                          return;
                        }

                        postService.updateoruploadImage(pickedFile.path);
                      },
                      icon: Icon(Icons.camera_alt_rounded,
                          size: 40, color: Colors.white)),
                  top: 60,
                  right: 20,
                ),
                Positioned(
                  child: IconButton(
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final PickedFile pickedFile = await picker.getImage(
                            source: ImageSource.gallery, imageQuality: 100);

                        if (pickedFile == null) {
                          return;
                        }

                        postService.updateoruploadImage(pickedFile.path);
                      },
                      icon: Icon(Icons.image_search_outlined,
                          size: 40, color: Colors.white)),
                  top: 120,
                  right: 20,
                ),
              ],
            ),
            _PostForm(),
            SizedBox(height: 100),
          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: postService.isSaving
              ? CircularProgressIndicator(color: Colors.white)
              : Icon(Icons.save_outlined),
          onPressed: postService.isSaving
              ? null
              : () async {
                  if (!postForm.isValidForm()) return;

                  final String imageUrl = await postService.uploadImage();

                  if (imageUrl != null) postForm.post.picture = imageUrl;

                  final authService =
                      Provider.of<AuthService>(context, listen: false);

                  postForm.post.idUser = await authService.readId();
                  await postService.saveOrCreatePost(postForm.post);
                  Navigator.of(context).pop();
                },
        ));
  }
}

class _PostForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postForm = Provider.of<PostFormProvider>(context);
    final post = postForm.post;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: postForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                maxLength: 35,
                initialValue: post.titulo,
                onChanged: (value) => post.titulo = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'Titulo obligatorio';
                },
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
                    labelText: 'Titulo de la publicacion'),
              ),
              SizedBox(height: 30),
              TextFormField(
                maxLength: 200,
                maxLines: null,
                initialValue: post.detalle,
                onChanged: (value) => post.detalle = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'Descripcion es obligatoria';
                },
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Descripcion de lo sucedido',
                  border: OutlineInputBorder(),
                ),
              ),
              Center(
                  child: SizedBox(
                      height: 20,
                      child: Text('Especifique el tipo de inseguridad:',
                          textAlign: TextAlign.center))),
              _CheckForm()
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
                blurRadius: 10)
          ]);
}

class _CheckForm extends StatefulWidget {
  @override
  __CheckFormState createState() => __CheckFormState();
}

class __CheckFormState extends State<_CheckForm> {
  bool value = false;
  final notification = [
    CheckBoxState(title: 'Robo a mano armada'),
    CheckBoxState(title: 'Robo a motociclista'),
    CheckBoxState(title: 'Accidente de transito'),
    CheckBoxState(title: 'Riña'),
    CheckBoxState(title: 'Altercado publico')
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [...notification.map(buildbox).toList()]);
  }

  Widget buildbox(CheckBoxState checkbox) => CheckboxListTile(
        value: checkbox.value,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(checkbox.title),
        onChanged: (bool value) => setState(() => checkbox.value = value),
      );
}

class CheckBoxState {
  final String title;
  bool value;
  CheckBoxState({this.title, this.value = false});
}
