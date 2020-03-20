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

    User({
        this.uid,
        this.email,
        this.name = "",
        this.lastName = "",
        this.photoUrl,
        this.timestamp
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        uid      : json["uid"],
        email    : json["email"],
        name     : json["name"],
        lastName : json["lastName"],
        photoUrl : json["photoUrl"],
        timestamp : json["timestamp"],

    );

    Map<String, dynamic> toJson(String timestamp) => {
        "uid"      : uid,
        "email"    : email,
        "name"     : name,
        "lastName" : lastName,
        "photoUrl" : photoUrl,
        "timestamp" : timestamp,
    };
}