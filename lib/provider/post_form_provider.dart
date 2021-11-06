import 'package:comm_safe/models/models.dart';
import 'package:flutter/material.dart';

class PostFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Post post;

  PostFormProvider(this.post);

  

  bool isValidForm(){

    return formKey.currentState.validate() ?? false;

  }


}