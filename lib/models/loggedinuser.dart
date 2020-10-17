class LoggedinUser {
  final String uid;
  final String email;
  final String displayname;
  final String photourl;
  final String provider;//1 EmailPassword 2 Google 3 Facebook
  LoggedinUser({ this.uid, this.email, this.displayname, this.photourl, this.provider});
  String get xuid {
    return this.uid;
  }
  factory LoggedinUser.fromJson(Map<String, dynamic> json) => LoggedinUser(  
      uid: json["uid"],
      email: json["email"], 
      displayname: json["displayname"],
      photourl: json["photourl"],
      provider:json["provider"]
    );
  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'email' : email,
    'displayname' : displayname,
    'photourl' : photourl,
    'provider': provider
  };
}
