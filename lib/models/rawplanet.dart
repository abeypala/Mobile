
class RawPlanet {
	final double longitude;//seconds to next rise
	final double speed;
	final double magnitude;

	RawPlanet({this.longitude, this.speed, this.magnitude});

	factory RawPlanet.fromJsonArray(List o) => RawPlanet(
		longitude : o[0] * 1.0,
		speed :  o[1] * 1.0,
		magnitude :  o[2] * 1.0);

   Map<String, dynamic> toLiteMap(i,v) {
		final Map<String, dynamic> data = Map<String, dynamic>();
    data['planet'] = i;
    data['longitude'] = this.longitude;
    data['speed'] = this.speed;
    data['magnitude'] = this.magnitude;
    return data;
  } /**/
}