import 'package:intl/intl.dart';
class BioData{          
 final String uid;//new
 final String pid;
 final String name;
 final DateTime tob;
 final String location; //formatted address
 final String cc; //country code
 final double lat;
 final double lng;
 final int kin;
 final int gender;
 final int utcoff;//in seconds
 final int unixts;//seconds, before utc adjust
 final int lagna;
 final int editcount;
 final int favourite;
 final int fts;
 final int ts;
BioData({this.uid,this.pid,this.name,this.tob,this.location,this.cc,this.lat,this.lng,this.kin,this.gender,this.lagna,this.utcoff,this.unixts,this.editcount,this.favourite,this.fts,this.ts});

  factory BioData.fromJson(Map<String, dynamic> json) => BioData(
        uid: json["uid"], 
        pid: json["pid"], 
        name: json["name"],
        tob: DateTime.parse(json["tob"]),
        location: json["location"],
        cc: json["cc"],
        lat:json["lat"],
        lng:json["lng"],
        kin:json["kin"],
        gender:json["gender"],
        utcoff:json["utcoff"],
        unixts:json["unixts"],
        lagna: json["lagna"],
        editcount: json["editcount"],
        favourite: json["favourite"],
        fts: json["fts"],
        ts:json["ts"]
      );

  Map<String, dynamic> toJsonAPIinput() {
		final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['pid'] = this.pid;
    data['name'] = this.name;
		data['tob'] = DateFormat("yyyy-MM-dd HH:mm:ss").format(this.tob);
		data['location'] = this.location;
		data['cc'] = this.cc;
		data['lat'] = double.parse(this.lat.toStringAsFixed(6));//individual humans, 11cm
		data['lng'] = double.parse(this.lng.toStringAsFixed(6));
		data['kin'] = this.kin;
		data['gender'] = this.gender;
		data['utcoff'] = this.utcoff;
		data['unixts'] = this.unixts;
		data['editcount'] = this.editcount;
		data['favourite'] = this.favourite;
		data['fts'] = this.fts;
		data['ts'] = this.ts;//DateTime.now().toUtc().microsecondsSinceEpoch;//???? need toi set manually
		return data;
	}

  Map<String, dynamic> toJsonAPIfavourite() {
		final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['pid'] = this.pid;
		data['favourite'] = this.favourite;
		data['fts'] = this.fts;
		return data;
	}
}