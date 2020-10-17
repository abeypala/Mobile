import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:kaladasava/models/locality.dart';
import 'package:google_maps_webservice/places.dart' as gmw;
import 'package:kaladasava/static/staticadd.dart';
  
gmw.GoogleMapsPlaces _places = gmw.GoogleMapsPlaces(apiKey: constMapKey.substring(32,71));

class LocationService{
  
 static Future<Locality> getDeviceLocation() async {
   Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    Coordinates coordinates = Coordinates(position.latitude,position.longitude);
    List<Address> listaddress = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address address = listaddress.length>0? listaddress[0]:Address();
    
    List strfull = [address.locality,address.adminArea,address.countryName];
    strfull.removeWhere((value) => value == null);

  return Locality(latitude:position.latitude,longitude:position.longitude,altitude:position.altitude,accuracy:position.accuracy,timestamp:position.timestamp.microsecondsSinceEpoch,address: address.addressLine,formattedaddress: strfull.toSet().toList().join(', '),countrycode: address.countryCode);
 }

 static Future<Locality> getSelectedLocation(gmw.Prediction p) async {
    if (p != null) {
      gmw.PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      List<Address> address = await Geocoder.local.findAddressesFromQuery(p.description);
      List strfull = [address[0].locality,address[0].adminArea,address[0].countryName];
      strfull.removeWhere((value) => value == null);    
      return Locality(latitude:detail.result.geometry.location.lat,
      longitude:detail.result.geometry.location.lng,
      address: address[0].addressLine.toString(),
      countrycode: address[0].countryCode,
      formattedaddress: strfull.toSet().toList().join(', '),
      utcoffset: detail.result.utcOffset.toInt()
      );
    }
    return Locality();
 }


}


