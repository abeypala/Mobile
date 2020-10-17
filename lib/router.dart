import 'package:flutter/material.dart';
import 'package:kaladasava/screens/home/dasava/dasava.dart';
import 'package:kaladasava/screens/home/infoscreen.dart';
import 'package:kaladasava/screens/home/pancanga/pancanga.dart';
import 'package:kaladasava/screens/home/profile.dart';
import 'package:kaladasava/screens/home/profilelist.dart';
import 'package:kaladasava/screens/wrapper.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    
    //StaticAdd().uid='THis ISME';

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Wrapper());
      break; 
      case '/infoscreen':
          return MaterialPageRoute(builder: (_) => InfoScreen(data: args));
      break; 
      case '/today':
          return MaterialPageRoute(builder: (_) => Pancanga());
      break; 
      case '/profilelist':
          return MaterialPageRoute(builder: (_) => ProfileList());
      break; 
      case '/profile':
          return MaterialPageRoute(builder: (_) => Profile(data: args));
      break; 
      case '/dasava':
          return MaterialPageRoute(builder: (_) => Dasava(data: args));
      break; 
      case '/pancanga':
        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Pancanga(
                //  data: args,
                ),
          );
        }
        return _errorRoute();        
      break; 
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}