class Locality{
final double latitude;
final double longitude;
final double altitude;
final double speed;
final double accuracy;
final String countrycode;
final String address;
final String formattedaddress;
final int utcoffset;
final int timestamp;
Locality({this.latitude,this.longitude,this.altitude,this.speed,this.accuracy,this.countrycode,this.address,this.formattedaddress,this.utcoffset,this.timestamp});
Map<String, dynamic> toJson() => {'lat':latitude, 'lng':longitude, 'alt':altitude, 'speed':speed, 'acu':accuracy, 'cc':countrycode, 'adr':address,'fadr':formattedaddress,'utcoff':utcoffset, 'ts':timestamp};
Map<String, dynamic> toJsonDevice() => {'lat':latitude.toStringAsFixed(6), 'lng':longitude.toStringAsFixed(6), 'loc':address!=''?address:formattedaddress};
Map<String, dynamic> toJsonSelected() => {'lat':latitude.toStringAsFixed(6), 'lng':longitude.toStringAsFixed(6), 'cc':countrycode, 'fadr':formattedaddress,'utcoff':utcoffset};
}

