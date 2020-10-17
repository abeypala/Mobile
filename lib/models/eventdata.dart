import 'package:kaladasava/models/biodata.dart';
import 'package:kaladasava/models/rawplanet.dart';
import 'package:kaladasava/models/riseset.dart';

class EventData {
	BioData event;
	List<Riseset> riseset;
	List<RawPlanet> planets;

	EventData({this.event, this.riseset, this.planets});

	EventData.fromJson(Map<String, dynamic> json) {
		event = json['event'] != null ? BioData.fromJson(json['event']) : null;
		if (json['riseset'] != null) {
			riseset = List<Riseset>();
			json['riseset'].forEach((v) { riseset.add(Riseset.fromJson(v)); });
		}
		if (json['planets'] != null) {
			planets = List<RawPlanet>();
			json['planets'].forEach((v) { planets.add(RawPlanet.fromJsonArray(v)); });
		}
	}

}