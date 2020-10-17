import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaladasava/models/loggedinuser.dart';
import 'package:kaladasava/services/authservice.dart';
import 'package:kaladasava/static/staticadd.dart';
import 'package:provider/provider.dart';
class MenuDrawer extends StatelessWidget{
logoutAlertDialog(BuildContext context) {
  print('dialog');
  final AuthService _auth = AuthService();
  // set up the buttons

  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {print('cancel');Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Logout"),
    onPressed:  ()  async {
      print('logout');
               Navigator.of(context).pop();
                await _auth.signOut();
              },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert Dialog"),
    content: Text("Would you like to log out of Kaladasava?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


  @override
  Widget build(BuildContext context){
  LoggedinUser user = Provider.of<LoggedinUser>(context);
    return Drawer(
      child:ListView(
        children: <Widget>[
        Container(
            height: 84.0,
            child: DrawerHeader(
              child: Column(children: [
                  Text('Kaladasava', style: TextStyle(color: Colors.brown[100], fontSize: 22)),
                  Row(children: [
                  Icon(Icons.verified_user,color: Colors.brown[50]),
                  SizedBox( width: 15.0),
                  Flexible(child: Text(user != null? user.email:'', style: TextStyle(color: Colors.brown[50], fontSize: 16),overflow: TextOverflow.ellipsis)),
                ],),
                ],),
                  
                decoration: BoxDecoration(color: Colors.brown[300],  
            ),
            ),
            ),
        //SizedBox( height: 20.0, ),
          ListTile(
            leading: Icon(Icons.local_florist),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('Today'),
            onTap: () => {      
                  Navigator.of(context).pop(),          
                  Navigator.of(context).pushNamed(
                  '/today',
                  arguments: 'Hello there from the first page!',
                  )
                },
          ),
          ListTile(
            leading: Icon(Icons.widgets),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('Horoscope'),
            onTap: ()  {
              String _pid = StaticAdd().selectedPid!=''?StaticAdd().selectedPid:StaticAdd().listfullBioData.length>0?StaticAdd().listfullBioData[0].pid:'';
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/dasava',arguments: {'page':0,'pid':_pid});             
            },  
          ),
          ListTile(
            enabled: false,
            leading: Icon(Icons.multiline_chart),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('Predictions'),
            onTap: () => {
                  Navigator.of(context).pop(),          
                  Navigator.of(context).pushNamed('/infoscreen',arguments: {'msg':'[Prediction] This Screen Under Construction!'},)              
            },
            ),

          ListTile(
            leading: Icon(Icons.people_outline),           
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('Matchmaking'),
            onTap: () => {
                  Navigator.of(context).pop(),          
                  Navigator.of(context).pushNamed('/infoscreen',arguments: {'msg':'[Matchmaking] This Screen Under Construction!'},)              
            },
          ),
          ListTile(
            enabled: false,
            leading: Icon(Icons.child_care),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('Baby Names'),
            onTap: () => {
                  Navigator.of(context).pop(),          
                  Navigator.of(context).pushNamed('/infoscreen',arguments: {'msg':'[Baby Names] This Screen Under Construction!'},)                          
            },     
          ),          
          ListTile(
            leading: Icon(Icons.storage),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('Profile List'),
            onTap: () => {
                  Navigator.of(context).pop(),          
                  Navigator.of(context).pushNamed('/profilelist')
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('Settings'),
            onTap: () => {
                  Navigator.of(context).pop(),          
                  Navigator.of(context).pushNamed('/infoscreen',arguments: {'msg':'[Settings] This Screen Under Construction!'},)              
            },         
          ),            
          ListTile(
            leading: Icon(Icons.contact_mail),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text('Feedback'),
            onTap: () => {
                  Navigator.of(context).pop(),          
                  Navigator.of(context).pushNamed('/infoscreen',arguments: {'msg':'[FeedBack] This Screen Under Construction!'},)                           
            }, 
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            //trailing: Icon(Icons.),
            title: Text('Logout'),
            onTap: () => {//Navigator.of(context).pop(),
            logoutAlertDialog(context)},
          ),



      ],)
    );
  }
}