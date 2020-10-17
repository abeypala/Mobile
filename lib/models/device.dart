class Device{
  final String name;
  final String version;
  final String id;
  final String physical;
  final int ts;
  Device({this.name,this.version,this.id,this.physical,this.ts});

    factory Device.fromJson(Map<String, dynamic> json) => Device(  
      id: json["id"],
      name: json["name"], 
      version: json["version"],
      physical: json["physical"],
      ts: json["ts"]
    );
    
    Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'version' : version,
    'physical': physical,
    'ts': ts
  };
}