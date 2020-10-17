import 'package:kaladasava/models/biodata.dart';
import 'package:kaladasava/models/device.dart';
import 'package:kaladasava/models/locality.dart';
import 'package:kaladasava/models/loggedinuser.dart';
import 'package:kaladasava/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:kaladasava/screens/home/pancanga/pancanga.dart';
import 'package:kaladasava/services/apiservice.dart';
import 'package:kaladasava/services/deviceservice.dart';
import 'package:kaladasava/services/localdbservice.dart';
import 'package:kaladasava/services/locationservice.dart';
import 'package:kaladasava/static/staticadd.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:get_ip/get_ip.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<LoggedinUser>(context);
    
    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else { 
      int tsz = DateTime.now().toUtc().microsecondsSinceEpoch-StaticAdd().wts;
      StaticAdd().wts = DateTime.now().toUtc().microsecondsSinceEpoch;
      if(StaticAdd().wts==0 || tsz>constLoginDoubleDelay) init(user);//would not run if calls within 2 seconds
      return Pancanga();//?
    }
    
  }

Future<void> init(LoggedinUser lu) async {
  int _sinceepoch = DateTime.now().toUtc().microsecondsSinceEpoch;
  Device _device = await DBProvider.db.readDevice(_sinceepoch - constQtrinMS);
  Locality _loc = await DBProvider.db.readDeviceLocation(_sinceepoch - constHourinMS);//hour ago
  if (_device == null){
    _device = await DeviceService.getDeviceDetails();
    await DBProvider.db.createDevice(_device);
  }
List<BioData> _lbdfull = await DBProvider.db.readBioData();
List<int> _lbd = await DBProvider.db.readBioDataInit(lu.uid);
List<int> _fav = await DBProvider.db.readBioDataFav(lu.uid);
  if(_loc == null) {//_lbd.length > 0  && 
    _loc = await LocationService.getDeviceLocation();
  await DBProvider.db.createDeviceLocation(_loc);
  }
StaticAdd().loggedinUser = lu;
StaticAdd().device = _device;
StaticAdd().devicelocation = _loc;
StaticAdd().localbiodata = _lbd;
StaticAdd().listfullBioData = _lbdfull;
StaticAdd().favourites = _fav;
String ip;
try{ip = await GetIp.ipAddress;}catch(e){ip = e.toString();}

Map<String,dynamic> o = Map<String,dynamic>();
o['dvc']=StaticAdd().device;
o['liu']=StaticAdd().loggedinUser;
o['btd']=StaticAdd().localbiodata;
o['fav']=StaticAdd().favourites;
o['loc']=StaticAdd().devicelocation.toJsonDevice();
o['ip']=ip;
APIService _api = APIService();
_api.apiInit(json.encode(o)).then((value) async => StaticAdd().listfullBioData=await DBProvider.db.readBioData());
StaticAdd().localbiodata = await DBProvider.db.readBioDataInit(lu.uid);//update data in cache
}

}