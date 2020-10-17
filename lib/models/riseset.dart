import 'package:intl/intl.dart';
class Riseset {
	final int fromlastset;//seconds from last set
	final int risetoset;//seconds from rise to set
	final int nextrise;//seconds to next rise
	final DateTime planetrise;
	final DateTime planetset;

	Riseset({this.fromlastset, this.risetoset, this.nextrise, this.planetrise, this.planetset});

	factory Riseset.fromJson(Map<String, dynamic> json) => Riseset(
		fromlastset : json['fs'],
		risetoset : json['rs'],
		nextrise : json['nr'],
		planetrise : DateTime.parse(json['r']),
		planetset : DateTime.parse(json['s']));
	
   Map<String, dynamic> todbMap(i,v,pid) {
		final Map<String, dynamic> data = Map<String, dynamic>();
    data['pid'] = pid;
    data['planet'] = i;
    data['fs'] = v.fromlastset;
    data['rs'] = v.risetoset;
    data['nr'] = v.nextrise;
    data['rise'] =  DateFormat("yyyy-MM-dd HH:mm:ss").format(v.planetrise);
    data['set'] =  DateFormat("yyyy-MM-dd HH:mm:ss").format(v.planetset);
    return data;
  } 
}