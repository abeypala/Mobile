import 'package:flutter/material.dart';
import 'package:kaladasava/menudrawer.dart';

class InfoScreen extends StatelessWidget {
  final Map<String,String> data;//rout
  InfoScreen({ Key key, @required this.data, }) : super(key: key);//rout

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Information Screen'),
      ),
      drawer: MenuDrawer(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[/* 
            Text(StaticAdd().uid,
              style: TextStyle(fontSize: 50),
            ), */
            
            SizedBox(height: 20.0),
            Text(data['msg'],style: TextStyle(fontSize: 21),),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('Go Back'),
              onPressed: () {

              },
            ),

          ],
        ),
      ),
    );
  }
}