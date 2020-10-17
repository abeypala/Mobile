import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kaladasava/models/loggedinuser.dart';
import 'package:kaladasava/router.dart' as rout;
import 'package:kaladasava/static/staticadd.dart';
import 'package:provider/provider.dart';
import 'package:kaladasava/services/authservice.dart' as auth;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LoggedinUser>.value(
      value: auth.AuthService().user,
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kaladasava',
      theme: appTheme(),
      //home:Wrapper(),
      //initialRoute: '/',
      onGenerateRoute: rout.Router.generateRoute,
      ),
    );
  }
}