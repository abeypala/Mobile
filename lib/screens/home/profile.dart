import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaladasava/models/biodata.dart';
import 'package:kaladasava/menudrawer.dart';
import 'package:kaladasava/models/locality.dart';
import 'package:kaladasava/services/apiservice.dart';
import 'package:kaladasava/services/localdbservice.dart';
import 'package:kaladasava/services/locationservice.dart';
import 'package:kaladasava/static/staticadd.dart';
import 'package:kaladasava/static/loading.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:convert';

const int _startyear = 1910;
const int _yearspan = 120;
const int _yeardefault = 2000;
const List<String> strmonth = const <String>['January','February','March','April','May','June','July','August','September','October','November','December'];
const mapGender = const {1:'Male',2:'Female'};
const mapKin = const {1:'MySelf',2:'Spouce',3:'Child',4:'Parent',5:'Sibling',6:'Grandparent',7:'Aunt/Uncle',8:'Cousin',9:'Niece/Nephew',10:'In-laws',11:'Friend',12:'Marriage Proposal',13:'Other'};

class Profile extends StatefulWidget {
  final Map<String, Object> data;
  Profile({ Key key, @required this.data, }) : super(key: key);
  @override
  _Profile createState() => _Profile(data);
}

class _Profile extends State<Profile> {
    int _ts = DateTime.now().toUtc().microsecondsSinceEpoch;List<String> _kinlist, _genderlist;
    Map<String, Object> _data;
    Map<String, int> _mapGenderR,_mapKinR;
    List<BioData> _lbd; BioData _ibd;
    DateTime _selectedDT, _unixepoch = DateTime(1970,1,1);
    String _newdt = '', _timeofday = '', _apm = '', _strDOBerr = '', _countrycode = '', _pid = '', _cmd = 'createbd';
    int _selectedGenderIndex = 0, _selectedKinIndex = 0, _selected12Hour = 0 ;
    int _originalGenderIndex = 0, _originalKinIndex = 0, _original12Hour = 0;
    int _selectedHour = 0, _selectedMinute = 0, _originalHour = 0, _originalMinute = 0;
    int _selectedYear = 0, _selectedMonth = 0, _selectedDate = 1, _utcoff = 0;//UAb
    int _originalYear =  (_yeardefault - _startyear), _originalMonth = 0, _originalDate = 1;//UAb
    int _editcount = 0, _favourite = 0, _favouritecount = 0, _fts = 0, _lagna = 0;
    double _latitude = 0.0, _longitude = 0.0;
    bool _loading = false, _flagmyself = false, _flagspouce = false, _butonenable = false;
    final _controllerName = TextEditingController(), _controllerDOB = TextEditingController(),  _controllerTOB = TextEditingController();  
    final _controllerlocation = TextEditingController(), _controllerGender = TextEditingController(),_controllerKin = TextEditingController();

_Profile(Map<String, Object> data){
  _data = data;
  _lbd = StaticAdd().listfullBioData;
  _genderlist = mapGender.entries.map((entry) => entry.value).toList();
  _kinlist = mapKin.entries.map((entry) => entry.value).toList();
  _mapGenderR = Map.fromEntries(mapGender.entries.map((e) => MapEntry(e.value, e.key)));
  _mapKinR = Map.fromEntries(mapKin.entries.map((e) => MapEntry(e.value, e.key)));
  _flagmyself = _lbd.where((item) => item.kin==1).length>=1;
  _flagspouce = _lbd.where((item) => item.kin==2).length>=1;
  _favouritecount = _lbd.where((item) => item.favourite==1).length;
    if (_flagmyself){_kinlist.remove('MySelf');}
    if (_flagspouce){_kinlist.remove('Spouce');}
 
  if (data!=null){
    _ibd = _lbd.singleWhere((e) => e.pid==data['pid']);
    _pid = _ibd.pid;
    _editcount = _ibd.editcount+1;
    _controllerName.text = _ibd.name;
    _selectedDT = _ibd.tob;
    _latitude = _ibd.lat;
    _longitude = _ibd.lng;
    _countrycode = _ibd.cc;
    _favourite = _ibd.favourite;
    _fts = _ibd.fts;
    _utcoff = _ibd.utcoff;
    _lagna = _ibd.lagna;
    _originalYear = _selectedYear = _selectedDT.year - _startyear;
    _originalMonth = _selectedMonth = _selectedDT.month - 1;
    _originalDate = _selectedDate = _selectedDT.day;
    _selectedHour = _selectedDT.hour;_selectedMinute=_selectedDT.minute;
    _originalHour = _selectedDT.hour;_originalMinute=_selectedDT.minute;
    _original12Hour = _selected12Hour = funchour(_originalHour);  
    _timeofday = functimeofday(_originalHour);
    _apm = funcapm(_originalHour);
    _originalGenderIndex = _ibd.gender;
    _originalKinIndex = _ibd.kin;  
    _controllerGender.text = mapGender[_originalGenderIndex];
    _controllerKin.text = mapKin[_originalKinIndex];
    _controllerTOB.text ='${(_original12Hour).toString().padLeft(2, '0')}:${(_selectedMinute).toString().padLeft(2, '0')} $_apm';
    _newdt = DateFormat.yMMMMd().format(_selectedDT);
    _controllerDOB.text ='$_newdt';
    _controllerlocation.text = _ibd.location;
    if (_originalKinIndex==2 && !_kinlist.contains('Spouce')) {_kinlist.insert(0, 'Spouce');}
    if (_originalKinIndex==1 && !_kinlist.contains('MySelf')) {_kinlist.insert(0, 'MySelf');}
    _originalGenderIndex = _selectedGenderIndex = _genderlist.indexOf(mapGender[_originalGenderIndex]);
    _originalKinIndex = _selectedKinIndex =_kinlist.indexOf(mapKin[_originalKinIndex]);
  }
}

Future<Null> locationPrediction(Prediction p) async {
Locality _loc = p!=null? await LocationService.getSelectedLocation(p) : Locality();
    setState(() {  
      _latitude = _loc.latitude;
      _longitude = _loc.longitude;
      _utcoff= _loc.utcoffset * 60;//in seconds
      _countrycode = _loc.countrycode;
      _controllerlocation.text = _loc.formattedaddress??'';
      _loading = false;
      _butonenable = true;
    });
}

void goBack() {
      Navigator.of(context).pop(); Navigator.pushNamed(context, '/profilelist',arguments: ''); 
      }

void _showDialog(String caller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (caller=='form'){
          return AlertDialog(title: Text('Alert'),content: Text('Please fill all the fields.'),actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () { Navigator.of(context).pop();},),],);
        }else if (caller=='nochange'){
          return AlertDialog(title: Text('Alert'),content: Text('No changes to save.'),actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () { Navigator.of(context).pop();},),],);
        }else if (caller=='button'){
          return AlertDialog(title: Text('Alert'),content: Text('No changes to save.\nDid you save twice?'),actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () { Navigator.of(context).pop();},),],);
        } else {//help
          String _help = '• All the fields are mandatory.\n• Location accuracy to the nearest kilometer is enough for the most cases.\n• Maxuimum number of profiles $constMaxCharts.\n• Maxuimum number of favourites $constMaxFavourites.\n• When add/remove from favourites, profiles are blocked for further changes upto $constFavouriteTimeOutDays days.\n• Profiles can be edited, however exessive editing may block profile being edited for $constEditTimeOutDays days.\n• Profiles can be deleted after $constEditTimeOutDays days from last edit date.';
          return AlertDialog(title: Text('Help'),content: Text(_help),actions: <Widget>[FlatButton(child: Text('Close'),onPressed: () { Navigator.of(context).pop();},),],);         
        }
      },
    );
  }

bool isValidDate(DateTime _d) {
    _newdt = DateFormat.yMMMMd().format(_d);
    return (_d.year == (_selectedYear + _startyear)  && _d.month == (_selectedMonth + 1) && _d.day == _selectedDate)?true:false;
}

String funcapm(int i){return (i>=12)?'p.m.':'a.m.';}

String functimeofday(int hr){
  String _timeofday='';
  if (hr>=5 && hr<12) _timeofday ='[morning]';
  if (hr==12) _timeofday ='[mid-day]';
  if (hr>12 && hr<17) _timeofday ='[afternoon]';
  if (hr>=17 && hr<=20) _timeofday ='[evening]';
  if (hr>20 && hr<=23) _timeofday ='[night]';
  if (hr==0) _timeofday ='[mid-night]';
  if (hr>=1 && hr<5) _timeofday ='[night]';
  return _timeofday;
}

int funchour(int hr){
  int _hr = hr%12;
  if(_hr==0 )_hr =12;
  return _hr;
} 

  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Scaffold(
      appBar: AppBar(title: Text('Profile'),leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:() => { goBack()}), actions: <Widget>[FlatButton.icon(icon: Icon(Icons.help_outline),label: Text('Help'),onPressed: () => _showDialog('help'),), 
      IconButton(icon: Icon(Icons.help,),tooltip: 'Help', onPressed: null)
      ],),
      drawer: MenuDrawer(),
      body:Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
        child: SingleChildScrollView(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[

          SizedBox(height: 10.0),
          TextFormField(controller: _controllerName,decoration: textInputDecoration.copyWith(hintText: 'Name',labelText: 'Name',prefixIcon: Icon(Icons.person),suffixIcon: Icon(Icons.short_text),),onChanged: (v){setState(() {_butonenable = true;});},),
          SizedBox(height: 20.0),
//DOB
          TextFormField(
              readOnly : true,
              enableInteractiveSelection: false,
              controller: _controllerDOB,
              decoration: textInputDecoration.copyWith(hintText: 'Date of Birth',labelText: 'Date of Birth', counterText: _strDOBerr, prefixIcon: Icon(Icons.calendar_today),suffixIcon: Icon(Icons.keyboard_arrow_down),),
              onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200.0,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CupertinoButton(
                                  child: Text(''),
                                  onPressed: () {Navigator.pop(context);},
                                ),
                                Expanded(child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(flex: 1,child: CupertinoPicker(
                                      scrollController: FixedExtentScrollController(initialItem:_originalYear),
                                      itemExtent: 32.0,
                                      backgroundColor: Colors.white,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          _butonenable = true;
                                          _selectedYear = index;
                                          _selectedDT = DateTime(_selectedYear+_startyear,_selectedMonth+1,_selectedDate,_selectedHour,_selectedMinute);                                         
                                          _strDOBerr = isValidDate(_selectedDT)?'':'Invalid Date!';
                                          print(DateFormat.yMMMMd().format(_selectedDT));
                                          _controllerDOB.text ='${strmonth[_selectedMonth]} $_selectedDate, ${_selectedYear+_startyear}';
                                        });
                                      },
                                      children: List<Widget>.generate(_yearspan,(int index) {return Center(child: Text('${index+_startyear}'),);}),
                                      ),
                                ),
Text('',style: TextStyle(fontSize: 24),),
                                Expanded(flex: 3,child: CupertinoPicker(
                                      scrollController: FixedExtentScrollController(initialItem: _originalMonth),
                                      itemExtent: 32.0,
                                      backgroundColor: Colors.white,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          _butonenable = true;
                                          _selectedMonth = index;
                                          _selectedDT = DateTime(_selectedYear+_startyear,_selectedMonth+1,_selectedDate,_selectedHour,_selectedMinute);                                         
                                          _strDOBerr = isValidDate(_selectedDT)?'':'Invalid Date!';
                                          _controllerDOB.text ='${strmonth[_selectedMonth]} $_selectedDate, ${_selectedYear+_startyear}';
                                        });
                                      },
                                      children: List<Widget>.generate(12,(int index) {return Center(child: Text('${strmonth[index]}'),);}),
                                      ),
                                ),
Text('',style: TextStyle(fontSize: 24),),
                                Expanded(flex: 1,child: CupertinoPicker(
                                      scrollController: FixedExtentScrollController(initialItem: _originalDate-1),
                                      itemExtent: 32.0,
                                      backgroundColor: Colors.white,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          _butonenable = true;
                                          _selectedDate = index + 1;
                                          _selectedDT = DateTime(_selectedYear+_startyear,_selectedMonth+1,_selectedDate,_selectedHour,_selectedMinute);                                         
                                          _strDOBerr = isValidDate(_selectedDT)?'':'Invalid Date!';
                                          _controllerDOB.text ='${strmonth[_selectedMonth]} $_selectedDate, ${_selectedYear+_startyear}';
                                        });
                                      },
                                      children: List<Widget>.generate(31,(int index) {return Center(child: Text('${index+1}'),);}),
                                      ),
                                ),
                              ],
                            ),
                                ),
                                CupertinoButton(child: Text('Done'),onPressed: () {
                                  _originalYear = _selectedYear; //UAb
                                  _originalMonth = _selectedMonth; //UAb
                                  _originalDate = _selectedDate;
                                  Navigator.pop(context);},),

                              ],
                            ),
                        );}
                    );}//showModalBottomSheet
            ),
//^DOB   
          SizedBox(height: 20.0),
//TOB
          TextFormField(
              readOnly : true,
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              controller: _controllerTOB,
              decoration: textInputDecoration.copyWith(hintText: 'Time of Birth',labelText: 'Time of Birth',helperText: '$_newdt ${(_selected12Hour).toString().padLeft(2, '0')}:${(_selectedMinute).toString().padLeft(2, '0')} $_apm',counterText:'$_timeofday', prefixIcon: Icon(Icons.access_time),suffixIcon: Icon(Icons.keyboard_arrow_down),),
              onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200.0,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CupertinoButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    setState(() {  
                                      _selectedHour = _originalHour;
                                      _selected12Hour = _original12Hour;
                                      _selectedMinute = _originalMinute;
                                      _apm = funcapm(_originalHour);
                                      _selectedDT = DateTime(_selectedYear+_startyear,_selectedMonth+1,_selectedDate,_selectedHour,_selectedMinute); 
                                      _controllerTOB.text ='${(_selected12Hour).toString().padLeft(2, '0')}:${(_selectedMinute).toString().padLeft(2, '0')} $_apm';
                                    });                                      
                                    Navigator.pop(context);
                                  },
                                ),
                                Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(flex: 1,child: CupertinoPicker(
                                      scrollController:FixedExtentScrollController(initialItem: _originalHour),
                                      itemExtent: 32.0,
                                      backgroundColor: Colors.white,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          _butonenable = true;
                                          _apm = funcapm(index);
                                          _selected12Hour = funchour(index);
                                          _selectedHour = index;
                                          _timeofday = functimeofday(index);
                                          _selectedDT = DateTime(_selectedYear+_startyear,_selectedMonth+1,_selectedDate,_selectedHour,_selectedMinute);   
                                          _controllerTOB.text ='${(_selected12Hour).toString().padLeft(2, '0')}:${(_selectedMinute).toString().padLeft(2, '0')} $_apm';
                                        });
                                      },
                                      children: List<Widget>.generate(24,(int index) {return Center(child: Text('$index'),);}),
                                      ),
                                ),
Text(':',style: TextStyle(fontSize: 24),),
                                Expanded(flex: 1,child: CupertinoPicker(
                                      scrollController: FixedExtentScrollController(initialItem: _originalMinute),
                                      itemExtent: 32.0,
                                      backgroundColor: Colors.white,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          _butonenable = true;
                                          _selectedMinute = index;
                                           _selectedDT = DateTime(_selectedYear+_startyear,_selectedMonth+1,_selectedDate,_selectedHour,_selectedMinute); 
                                          _controllerTOB.text ='${(_selectedHour).toString().padLeft(2, '0')}:${(_selectedMinute).toString().padLeft(2, '0')} $_apm';
                                        });
                                      },
                                      children: List<Widget>.generate(60,(int index) {return Center(child: Text('$index'),);}),
                                      ),
                                ),
                              ],
                            ),
                                ),
                                CupertinoButton(child: Text('Done'),onPressed: () {
                                   setState(() {
                                      _original12Hour = _selected12Hour;
                                      _originalHour = _selectedHour;
                                      _originalMinute = _selectedMinute;
                                      _apm = funcapm(_originalHour);});
                                  Navigator.pop(context);},),
                              ],
                            ),
                        );}
                    );}//showModalBottomSheet
            ),
//^TOB     
          SizedBox(height: 20.0),
//Location
          TextFormField(
              readOnly : true,
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              controller: _controllerlocation,
              onTap: () async {
                  try 
                  {
                    setState(() => _loading = true);
                    Prediction p = await PlacesAutocomplete.show(context: context, apiKey: constMapKey.substring(32,71));
                    locationPrediction(p);
                  } catch(e) {print('Caught error: $e');}
              },
              decoration:textInputDecoration.copyWith(hintText: 'Birth Location',labelText: 'Birth Location',helperText:([0,'',null,0.0].contains(_latitude)||[0,'',null,0.0].contains(_longitude))?'':'Lat ${_latitude.toStringAsFixed(3)}, Lng ${_longitude.toStringAsFixed(3)}',prefixIcon: Icon(Icons.local_hospital), suffixIcon: Icon(Icons.keyboard_arrow_right),)
            ),
//^Location
          SizedBox(height: 20.0),
//Gender & Relationship        
Row(children: <Widget>[Flexible(child:
          TextFormField(
              readOnly : true,
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              controller: _controllerGender,
              decoration: textInputDecoration.copyWith(hintText: 'Gender',labelText: 'Gender',prefixIcon: Icon(Icons.wc),suffixIcon: Icon(Icons.keyboard_arrow_down),),
              onTap: () {
                  _controllerGender.text = _genderlist[_selectedGenderIndex];
                  setState(() {_butonenable = true;});
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200.0,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CupertinoButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    setState(() {
                                      _selectedGenderIndex = _originalGenderIndex;
                                      _controllerGender.text = _genderlist[_originalGenderIndex];
                                    });                                      
                                    Navigator.pop(context);
                                  },
                                ),
                                Expanded(
                                  child: CupertinoPicker(
                                  scrollController:FixedExtentScrollController(initialItem: _originalGenderIndex,),
                                  itemExtent: 32.0,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      _selectedGenderIndex = index;
                                      _controllerGender.text = _genderlist[_selectedGenderIndex].toString();
                                    });
                                  },
                                  children: List<Widget>.generate(_genderlist.length, (int index) {return Center( child: Text(_genderlist[index]));})
                                  ),
                                ),
                                CupertinoButton(child: Text('Done'),onPressed: () {
                                  _originalGenderIndex = _selectedGenderIndex;                                  
                                  Navigator.pop(context);},),
                              ],
                            ),
                        );}
                    );}//showModalBottomSheet
            ),
),        
        SizedBox(width: 20.0),
Flexible(child:TextFormField(
              readOnly : true,
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              controller: _controllerKin,
              decoration: textInputDecoration.copyWith(hintText: 'Relationship',labelText: 'Relationship',prefixIcon: Icon(Icons.supervised_user_circle),suffixIcon: Icon(Icons.keyboard_arrow_down),),
              onTap: () {
                  _controllerKin.text = _kinlist[_selectedKinIndex];
                  setState(() {_butonenable = true;});
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200.0,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CupertinoButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    setState(() {
                                      _selectedKinIndex = _originalKinIndex;
                                      _controllerKin.text = _kinlist[_selectedKinIndex];
                                    });                                      
                                    Navigator.pop(context);
                                  },
                                ),
                                Expanded(
                                  child: CupertinoPicker(
                                  scrollController:FixedExtentScrollController(initialItem: _originalKinIndex,),
                                  itemExtent: 32.0,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      _selectedKinIndex = index;
                                      _controllerKin.text = _kinlist[_selectedKinIndex];
                                    });
                                  },
                                  children: List<Widget>.generate(_kinlist.length, (int index) {return Center( child: Text(_kinlist[index]));})
                                  ),
                                ),
                                CupertinoButton(child: Text('Done'),onPressed: () {
                                  _originalKinIndex = _selectedKinIndex; 
                                  Navigator.pop(context);},),

                              ],
                            ),
                        );}
                    );}//showModalBottomSheet
            ),
),]),
//^Gender & Relationship  

SizedBox(height: 20.0),
RaisedButton(  
  child: Text('Save Settings',style: TextStyle(color: _butonenable?Colors.brown[900]:Colors.grey),),
  onPressed: () async { 
    if (_controllerName.text==''||_controllerDOB.text==''||_controllerTOB.text==''||_controllerlocation.text==''||_controllerGender.text==''||_controllerKin.text==''){_showDialog('form'); return null;}
    if(_butonenable == true)         
    {
          setState(() {_butonenable = false;});
          int _unixts = _selectedDT.difference(_unixepoch).inSeconds;
          if (_mapKinR[_controllerKin.text] == 1 && _favourite !=1){//if no myself and favourites available make myself favourite
            _favourite=_favouritecount<constMaxFavourites?1:0;
            _fts = _favouritecount<constMaxFavourites?_ts:0;
          }
        print(_selectedDT.toString());
        if (_data != null){
          if (_unixts == _ibd.unixts && _latitude == _ibd.lat && _longitude == _ibd.lng && _controllerName.text == _ibd.name && _mapGenderR[_controllerGender.text] == _ibd.gender && _mapKinR[_controllerKin.text] == _ibd.kin ){//no major change     
            _showDialog('nochange');
          return null;
          }
          _cmd = 'updatebd';
        }
            BioData bd = BioData(uid:StaticAdd().loggedinUser.uid,lat: _latitude,lng:_longitude,kin:_mapKinR[_controllerKin.text],utcoff:_utcoff,unixts:_unixts,favourite:_favourite,fts:_fts, location:_controllerlocation.text,cc:_countrycode,gender:_mapGenderR[_controllerGender.text],tob:_selectedDT,name:_controllerName.text,editcount:_editcount,pid:_pid,lagna:_lagna,ts:_ts);
            APIService _api = APIService();
            var flag = await _api.apiCreateEditBio(_cmd,json.encode(bd.toJsonAPIinput()));  
            StaticAdd().listfullBioData = await DBProvider.db.readBioData();//update data in cache
            print(flag);
            goBack();
           // String createbdjson = _api.prepareCargo(_cmd, json.encode(bd.toJsonAPIinput()));
           // print(createbdjson);
    }else{_showDialog('button'); return null;}
      
  },
),         
        SizedBox(width: 30.0),
        Text('',style: TextStyle(fontSize: 10.0),),         
    ])))),
    );
  }//Widget
}