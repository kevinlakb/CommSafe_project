import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:comm_safe/screens/screens.dart';
import 'package:comm_safe/services/services.dart';
import 'package:comm_safe/theme/theme.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => PostService())
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Robos',
      initialRoute: 'checking',
      routes: {
        'login': (_) => LoginScreen(),
        'register': (_) => RegisterScreen(),
        'map': (_) => MapScreen(),
        'home': (_) => HomeScreen(),
        'post': (_) => PostScreen(),
        'checking': (_) => CheckAuthScreen(),
        'alert': (_) => Location()
      },
      scaffoldMessengerKey: NotificationService.messengerKey,
      theme: mitema,
    );
  }
}
