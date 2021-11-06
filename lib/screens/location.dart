import 'package:comm_safe/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comm_safe/services/services.dart';
import 'package:comm_safe/models/models.dart';

class Location extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MapScreen(),
        ));
  }
}
