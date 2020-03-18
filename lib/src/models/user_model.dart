import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    int uid;
    String email;
    String name;
    String lastName;
    String photoUrl;

    User({
        this.uid,
        this.email,
        this.name = "",
        this.lastName = "",
        this.photoUrl,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        email: json["email"],
        name: json["name"],
        lastName: json["lastName"],
        photoUrl: json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "lastName": lastName,
        "photoUrl": photoUrl,
    };
}