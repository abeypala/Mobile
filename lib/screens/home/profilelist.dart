import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kaladasava/models/biodata.dart';
import 'package:intl/intl.dart';
import 'package:kaladasava/menudrawer.dart';
import 'package:kaladasava/services/apiservice.dart';
import 'package:kaladasava/services/localdbservice.dart';
import 'package:kaladasava/static/staticadd.dart';

class ProfileList extends StatefulWidget {
  @override
  _ProfileList createState() => _ProfileList();
}

class _ProfileList extends State<ProfileList> {
  int _tapcount = 0;
  List<BioData> _lbd = List<BioData>();  

  @override
  void dispose() {
    print('Back To old Screen');
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
        setState(() {_lbd = StaticAdd().listfullBioData;});
  }

  String _latlngFmt(double lat, double lng, int utc){
  String slat = lat>0?'N':'S';if(lat==0){slat='';}
  String slng = lng>0?'E':'W';if(lng==0){slng='';}

  final String y = lat.toStringAsFixed(3)+'° $slat';
  final String x = lng.toStringAsFixed(3)+'° $slng';
return '$y $x';
}
  
  List<TextSpan> _stylePID(String pid, String name){
  List<TextSpan> ltp = List<TextSpan>();
  for (int j=0;j<pid.length; j++){
    ltp.add(TextSpan(text: pid[j], style: TextStyle(fontWeight: FontWeight.bold,color: pid.codeUnitAt(j)<65?Colors.brown[500]:Colors.brown[300],decoration:pid.codeUnitAt(j)<65?TextDecoration.underline:TextDecoration.none,fontSize:pid.codeUnitAt(j)<65?18.0:15.0)));
  }
   ltp.add(TextSpan(text: '\t\t\t\t$name', style: TextStyle(fontWeight: FontWeight.normal,color: Colors.brown,fontSize:15.0)));
  return ltp;
}

  bool _showDialog(String caller,{int index}) {
    print('call $caller   tc $_tapcount index $index');
    _tapcount=0;
    String _strdura =''; Map<String,dynamic> _bdiargs;BioData _instance;
    int _tsnow;int _longtime;
    if (caller!='add'&&caller!='init'&&caller!='help'){
      _instance = _lbd[index];
      _tsnow = DateTime.now().toUtc().microsecondsSinceEpoch - _lbd[index].ts;
      _longtime = constDayinMS * constEditTimeOutDays;
    }

    if (caller=='edit'){
      int _editcount = _instance.editcount??0;
      if(_tsnow<_longtime && _editcount>constMaxEdits){
        Duration _dura = Duration(microseconds: (_longtime-_tsnow));
        _strdura = '${_dura.inDays} days and ${_dura.inHours.remainder(24)} hours';
        caller+='na';
      } else {
        _bdiargs = {'pid': _instance.pid};
      }
    }
    if (caller=='add'){
      caller+=_lbd.length<constMaxCharts?'':'na';
    }
    if (caller=='delete'){
        _bdiargs = {'uid':_instance.uid,'pid': _instance.pid};
      caller+=(_tsnow>_longtime)?'':'na';
    }
    if (caller=='favourite'){
        int _favcount = _lbd.where((e) => e.favourite==constFavourite).toList().length;
        int _ftsnow = DateTime.now().toUtc().microsecondsSinceEpoch - _instance.fts;
        int _favtimelmt = constDayinMS * constFavouriteTimeOutDays;
        Duration _dura = _ftsnow<_favtimelmt&&_instance.fts>0?Duration(microseconds: (_favtimelmt-_ftsnow)):Duration(days: 999);
        _strdura = '${_dura.inDays} days and ${_dura.inHours.remainder(24)} hours';
        print(_strdura);
      if(_instance.favourite==1){
        _bdiargs = {'uid':_instance.uid,'pid': _instance.pid,'favourite':0,'fts':DateTime.now().toUtc().microsecondsSinceEpoch};
        caller += (_ftsnow>_favtimelmt)?'remove':'removena';
      }else{
        _bdiargs = {'uid':_instance.uid,'pid': _instance.pid,'favourite':1,'fts':DateTime.now().toUtc().microsecondsSinceEpoch};
        caller += (_favcount<constMaxFavourites)?(_ftsnow>_favtimelmt)?'add':'addnatime':(_ftsnow>_favtimelmt)?'addnacount':'addnatimecount';//add time count timecount
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
    switch(caller){
      case 'init':
            return AlertDialog(title: Text('Information'),
              content:  Text('• Its important to enter your birth details (profile) first.\n\n• Then you can add up to $constMaxCharts family and friends profiles'),
              actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () {Navigator.of(context).pop();},),],
            );
      break;
      case 'oncardtap':
              return AlertDialog(title: Text('Information'),
                content: Text('Please tap and hold to edit profile card.'),
                actions: <Widget>[FlatButton(child: Text('Ok'),onPressed: () {Navigator.of(context).pop();},),],
              );
      break;
      case 'add':
              return AlertDialog(title: Text('Confirmation'),
                content: Text('Are you sure you want to add a new profile?\n(You can have up to $constMaxCharts profiles.)'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel',style: TextStyle(color: Colors.black),),
                    onPressed: () {Navigator.of(context).pop();},
                  ),
                  FlatButton(
                    child: Text('Add',style: TextStyle(color: Colors.red),),
                    onPressed: () {print('Add screen');
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/profile',arguments: null); 
                    },
                  ),
                ],              );
      break;
      case 'addna':
              return AlertDialog(title: Text('Information'),
                content: Text('You have reached maximum number of $constMaxCharts profiles allowed.\nPerhaps try deleting some of profiles.'),
                actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () {Navigator.of(context).pop();},),],
              );      
      break;               
      case 'edit':
              return AlertDialog(title: Text('Confirmation'),
                content: Text('Are you sure you want to edit ${_lbd[index].name}?\n(There are restrictions on number of edits can be done per profile.)'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel',style: TextStyle(color: Colors.black),),
                    onPressed: () {Navigator.of(context).pop();},
                  ),
                  FlatButton(
                    child: Text('Edit',style: TextStyle(color: Colors.red),),
                    onPressed: () {print('Edit screen');
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/profile',arguments: _bdiargs); 
                    },
                  ),
                ],              );
      break;
      case 'editna':
              return AlertDialog(title: Text('Edit Restriction'),
                content: Text('You have reached maximum number of $constMaxEdits edits per $constEditTimeOutDays day period.\nPlease try again in $_strdura.'),
                actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () {Navigator.of(context).pop();},),],
              );      
      break;      
      case 'delete':
                return AlertDialog(title: Text('Confirmation'),
                    content: Text('Are you sure you want to delete ${_lbd[index].name}?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel',style: TextStyle(color: Colors.black),),
                        onPressed: () {Navigator.of(context).pop();},
                      ),
                      FlatButton(
                        child: Text('Delete',style: TextStyle(color: Colors.red),),
                          onPressed: () async {
                          print('Delete');
                          APIService _api = APIService();
                          var flag = await _api.apiDelete('deletebd',json.encode(_bdiargs));
                          print(flag);
                          StaticAdd().listfullBioData = await DBProvider.db.readBioData();
                          setState(() {_lbd = StaticAdd().listfullBioData;});
                          Navigator.of(context).pop();
                          },
                      ),
                    ],
                );
      break;
      case 'deletena':
              return AlertDialog(title: Text('Time Restriction'),
                content: Text('Delete won\'t be available from $constEditTimeOutDays days since last edited.'),
                actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () {Navigator.of(context).pop();},),],
              );      
      break;
      case 'favouriteadd':                    
                return AlertDialog(title: Text('Confirmation'),
                      content: Text('Are you sure you want to add ${_lbd[index].name} to the favourites?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Cancel',style: TextStyle(color: Colors.black),),
                          onPressed: () {Navigator.of(context).pop();},
                        ),
                        FlatButton(
                          child: Text('Add',style: TextStyle(color: Colors.orange),),
                          onPressed: () async {
                          print('Add favourite');
                          APIService _api = APIService();
                          var flag = await _api.apiFavourite('favourite',json.encode(_bdiargs));
                          print(flag);
                          StaticAdd().listfullBioData = await DBProvider.db.readBioData();
                          setState(() {_lbd = StaticAdd().listfullBioData;});
                          Navigator.of(context).pop();
                          },
                        ),
                      ],
                  );
      break;
      case 'favouriteaddnatime':                    
                return AlertDialog(title: Text('Time Restriction'),
                      content: Text('You are not allowed to add ${_lbd[index].name} to the favourites now!\nPlease try again in $_strdura.\nYou can add or remove from favourites once in $constFavouriteTimeOutDays days.'),
                      actions: <Widget>[FlatButton(
                          child: Text('Close',style: TextStyle(color: Colors.black),),
                          onPressed: () {Navigator.of(context).pop();})],
                  );
      break;         
      case 'favouriteaddnatimecount':                    
                return AlertDialog(title: Text('Time & Max Favourites Restriction'),
                      content: Text('You are not allowed to add ${_lbd[index].name} to the favourites now!\nPlease remove some of your favourites and try again in $_strdura.\nYou can add or remove from favourites once in $constFavouriteTimeOutDays days.'),
                      actions: <Widget>[FlatButton(
                          child: Text('Close',style: TextStyle(color: Colors.black),),
                          onPressed: () {Navigator.of(context).pop();})],
                  );
      break;         
      case 'favouriteaddnacount':                    
                return AlertDialog(title: Text('Max Favourites Restriction'),
                      content: Text('You are not allowed to add ${_lbd[index].name} to the favourites now!\nYou can only have maximum $constMaxFavourites favourites.\nTry removing some of your favourites first.'),
                      actions: <Widget>[FlatButton(
                          child: Text('Close',style: TextStyle(color: Colors.black),),
                          onPressed: () {Navigator.of(context).pop();})],

                  );
      break;      
      case 'favouriteremove':                    
                return AlertDialog(title: Text('Confirmation'),
                      content: Text('Are you sure you want to remove ${_lbd[index].name} from favourites?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Cancel',style: TextStyle(color: Colors.black),),
                          onPressed: () {Navigator.of(context).pop();},
                        ),
                        FlatButton(
                          child: Text('Remove',style: TextStyle(color: Colors.orange),),
                          onPressed: () async {
                          print('Remove favourite');
                          APIService _api = APIService();
                          var flag = await _api.apiFavourite('favourite',json.encode(_bdiargs));
                          print(flag);
                          StaticAdd().listfullBioData = await DBProvider.db.readBioData();
                          setState(() {_lbd = StaticAdd().listfullBioData;});
                          Navigator.of(context).pop();
                          },
                        ),
                      ],
                  );
      break;      
      case 'favouriteremovena':
              return AlertDialog(title: Text('Time Restriction'),
                      content: Text('You are not allowed to remove ${_lbd[index].name} from the favourites now!\nPlease try again in $_strdura.\nYou can add or remove from favourites once in $constFavouriteTimeOutDays days.'),
                      actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () {Navigator.of(context).pop();},),],
              );        
      break;
      default:
              return AlertDialog(title: Text('Help'),
                content: Text('• Click bottom right floating button to add new profile.\n\n• Click and hold a profile card to edit.\n\n• Swipe right to add or remove profile from favourites.\n\n• Swipe left to delete a profile.\n\n• Id of each profile at the start of profile card, 4 to 6 letter alpha numeric word.'),
                actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () {Navigator.of(context).pop();},),],
              );
      break;
    }//switch
  }//builder
  );
  return false;
}

  Widget slideRightBackground() {
    return Container(
      color: Colors.orange,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 30),
            Icon(Icons.favorite,color: Colors.white),
            SizedBox(width: 10),
            Text('Favourite',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,),textAlign: TextAlign.left,),
          ])));
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete,color: Colors.white,),
            SizedBox(width: 10),
            Text('Delete',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,),textAlign: TextAlign.right,),
            SizedBox(width: 30,),
          ])));
  }
  
    @override
    Widget build(BuildContext context) {
    if(_lbd.length==0){Future.delayed(Duration(milliseconds: 500), () => _showDialog('init'));}
    return Scaffold(
    appBar: AppBar(title: Text('Profile List'),actions: <Widget>[FlatButton.icon(icon: Icon(Icons.help_outline),label: Text('Help'),onPressed: () => _showDialog('help'),),],),
    drawer: MenuDrawer(),
    floatingActionButton: FloatingActionButton(elevation: 15.0,child: Icon(Icons.person_add), onPressed: () {_showDialog('add');}),//_showChart(-1);print('f');
    body:ListView.builder(
        itemCount: _lbd.length,
        itemBuilder: (context, index) {
          return Dismissible(
          key: Key(_lbd[index].pid),
          child:Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: ListTile(               
                onTap: (){_tapcount>constMaxTapCount?_showDialog('oncardtap',index:index):_tapcount++;},
                onLongPress: () {_showDialog('edit',index:index);},
                title:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                RichText(text: TextSpan(children: _stylePID(_lbd[index].pid,_lbd[index].name),),),
                Icon(Icons.favorite,color:_lbd[index].favourite==1?Colors.brown:Colors.grey[50]),
                ],),
                //Text(_stylePID(_lbd[index].pid) + _lbd[index].name +'\t\t'),DateFormat.yMMMd()
               // subtitle: Text(_lbd[index].location +'\n'+ DateFormat('MMMM d, yyyy hh:mm a').format(_lbd[index].tob) +' \n'+ _latlngutcFmt(_lbd[index].lat,_lbd[index].lng,_lbd[index].utcoff),softWrap: false,),

                subtitle: Text(DateFormat('MMMM d, yyyy hh:mm a ').format(_lbd[index].tob) +'utc '+(_lbd[index].utcoff/3600).toStringAsFixed(2)+'hrs'+'\n'+_lbd[index].location +'\n'+ _latlngFmt(_lbd[index].lat,_lbd[index].lng,_lbd[index].utcoff),softWrap: false,),
                leading:CircleAvatar(
                          backgroundImage: AssetImage('assets/zodiac${_lbd[index].lagna.toString().padLeft(2, '0')}.png'),
                          backgroundColor: Colors.brown[500],
                          radius: 30.0,
                          ),
                ),
              ),
          ),


          background: slideRightBackground(),
          secondaryBackground: slideLeftBackground(),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              final bool res = _showDialog('delete',index:index);
              return res;
            } else {
              final bool res = _showDialog('favourite',index:index);
              return res;
            }
          },

    );
        }
      ),
/* Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly,
          children:[
          ]), */

      );
    }
}
