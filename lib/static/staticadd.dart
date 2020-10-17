import 'package:flutter/material.dart';
import 'package:kaladasava/models/biodata.dart';
import 'package:kaladasava/models/device.dart';
import 'package:kaladasava/models/locality.dart';
import 'package:kaladasava/models/loggedinuser.dart';

enum signInMethod {Email,Google,Facebook,Twitter,Microsoft,Yahoo} 

const constHourinMS = 3600 * 1000000;
const constDayinMS = 24 * constHourinMS;
const constMonthinMS = 30 * constDayinMS;
const constQtrinMS = 3 * constMonthinMS;

const constEditTimeOutDays = 9;//90
const constMaxEdits = 2;//Edits Delete per time out
const constMaxCharts = 30;//7
const constFavouriteTimeOutDays = 7;//7
const constMaxFavourites = 3;//3
const constFavourite = 1;//val of favourite=1
const constMaxTapCount = 3;//3

const constLoginDoubleDelay = 2000000; //microseconds
const constCipher = 'AES CIPHER KEY';
const constMapKey = 'GOOGLE MAP API KEY';

class StaticAdd {
  ///// One instance, needs factory 
  static StaticAdd _instance;
  factory StaticAdd() => _instance ??= StaticAdd._();
  StaticAdd._();
  /////
 

 String selectedPid = '';
 int wts = 0; //this is to stop loading wrapper multiple times within few seconds./ need to investigate
 
 Locality devicelocation = Locality();
 Device device = Device();
 List<int> localbiodata = List<int>();
 List<int> favourites = List<int>();
 List<BioData> listfullBioData = List<BioData>();
 LoggedinUser loggedinUser = LoggedinUser();
}

///Theme 
ThemeData appTheme() {
  return ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.brown[200],
  accentColor: Colors.brown[600],
  backgroundColor: Colors.brown[60],
  visualDensity: VisualDensity.standard,
  hintColor: Colors.brown[700],
  dividerColor: Colors.brown[200],
  buttonColor: Colors.brown[200],
  scaffoldBackgroundColor: Colors.brown[50],
  canvasColor: Colors.white,
  );
} 
//text field decoration
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

//rich text decoration rtd A
const rtdA = TextStyle(
  color: Color.fromARGB(255, 205,133,63),
  fontSize: 18,
  fontFamily: 'Open Sans',
  fontStyle: FontStyle.italic
);
const rtdB = TextStyle(
  color: Color.fromARGB(255, 139,69,19),
  fontSize: 21,
  fontWeight: FontWeight.bold,
);
const rtdC = TextStyle(
  color: Color.fromARGB(255, 222,111,111),
  fontSize: 21,
  fontWeight: FontWeight.bold,
);
///^Theme 