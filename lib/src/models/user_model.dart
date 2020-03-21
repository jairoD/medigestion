import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

Map<String, dynamic> userToJson(User data, String timestamp) => data.toJson(timestamp);

class User {
    String uid;
    String email;
    String name;
    String lastName;
    String photoUrl;
    String timestamp;
    String available;

    User({
        this.uid,
        this.email,
        this.name     = "",
        this.lastName = "",
        this.photoUrl,
        this.timestamp,
        this.available
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        uid       : json["uid"],
        email     : json["email"],
        name      : json["name"],
        lastName  : json["lastName"],
        photoUrl  : json["photoUrl"],
        timestamp : json["timestamp"],
        available  : json["available"],
    );

    Map<String, dynamic> toJson(String timestamp) => {
        "uid"       : uid,
        "email"     : email,
        "name"      : name,
        "lastName"  : lastName,
        "photoUrl"  : photoUrl,
        "timestamp" : timestamp,
    };
}