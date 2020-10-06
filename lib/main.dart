import 'package:Notes/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/AddNoteScreen.dart';
import './screens/ViewNoteScreen.dart';
import './screens/LoginScreen.dart';
import './screens/SplashScreen.dart';
import './providers/NoteProvider.dart';
import './providers/Auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Notes>(
          create: null,
          update: (context, auth, previous) => Notes(
              auth.token, previous == null ? [] : previous.notes, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.indigo[900],
            accentColor: Colors.amber,
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (c, s) =>
                      s.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          routes: {
            AddNoteScreen.routeName: (ctx) => AddNoteScreen(),
            ViewNoteScreen.routeName: (ctx) => ViewNoteScreen(),
          },
        ),
      ),
    );
  }
}
