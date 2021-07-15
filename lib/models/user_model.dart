import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        this.id,
        this.name,
        this.email,
        this.password,
        this.role,
        this.userClass,
        this.section,
    });

    String? id;
    String? name;
    String? email;
    String? password;
    String? role;
    String? userClass;
    String? section;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        password: json["password"] == null ? null : json["password"],
        role: json["role"] == null ? null : json["role"],
        userClass: json["class"] == null ? null : json["class"],
        section: json["section"] == null ? null : json["section"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "password": password == null ? null : password,
        "role": role == null ? null : role,
        "class": userClass == null ? null : userClass,
        "section": section == null ? null : section,
    };
}
