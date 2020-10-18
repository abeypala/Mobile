import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaladasava/models/eventdata.dart';
import 'package:kaladasava/services/cipherservice.dart';
import 'package:kaladasava/services/localdbservice.dart';

class APIService{
//String apicargo;

Future<bool>apiInit(String jstr) async {
  String res = await  apicall(prepareCargo('init', jstr));
  if(res !='false'){
      List ljson = json.decode(res);
      if(ljson.length == 0)return false;
      if(ljson[0] == null)return false;
      if(ljson[0]['event'] == null)return false;
        List<EventData>ljd = List<EventData>();
        ljson.forEach((e) => ljd.add(EventData.fromJson(e)));
        DBProvider.db.createChart(ljd);
    return true;
  }
return false;
}

Future<bool>apiCreateEditBio(String cmd,String jstr) async {
  String res = await  apicall(prepareCargo(cmd, jstr));
  if(res !='false'){
      var ljson = json.decode(res);
      if(ljson[0] == null)return false;
      if(ljson[0]['event'] == null)return false;
      List<EventData>ljd = List<EventData>();
      ljson.forEach((e) => ljd.add(EventData.fromJson(e)));
      DBProvider.db.createChart(ljd);
    return true;
}
return false;
}

Future<bool>apiFavourite(String cmd,String jstr) async {
  String res = await  apicall(prepareCargo(cmd, jstr));
  if(res =='true'){
      var jo = json.decode(jstr);
      DBProvider.db.updateBioDataFavourite(jo);
    return true;
}
return false;
}


Future<bool>apiDelete(String cmd,String jstr) async {
  String res = await  apicall(prepareCargo(cmd, jstr));
  if(res =='true'){
      var jo = json.decode(jstr);
      DBProvider.db.deleteBioData(jo['pid']);
    return true;
}
return false;
}

String prepareCargo(String cmd,String jstr){
  String tmpstr = '{"cmd":"$cmd","data":$jstr}';
  tmpstr = tmpstr.replaceAll("'", "^");
  print(tmpstr);
  tmpstr = '{"cipher":"' + CipherService.encryp(tmpstr) + '"}';
  print(tmpstr);
  return tmpstr;
  //REPLACE above> return '{"cipher":"' + CipherService.encryp(jstr,s) + '"}';
}

Future<String> apicall(String cipher, [String url='k-api']) async {
    final http.Response response = await http.post('https://mysite.com',
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    body: cipher);
  //201 good data, 204 no data,400 error
  if (response.statusCode == 201) {
    if(response.body==null)return 'false';
    if(response.body=='false')return 'false';
    return response.body;
  } else if (response.statusCode == 202) {
    print(response.statusCode); //update
    return 'true';
  }
    print(response.statusCode); //shouldn't hit here
    return 'false';
}


}