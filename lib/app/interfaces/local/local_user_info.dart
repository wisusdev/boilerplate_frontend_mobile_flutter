import 'dart:convert';

LocalUserInfo localUserInfoFromJson(String str) => LocalUserInfo.fromJson(json.decode(str));

String localUserInfoToJson(LocalUserInfo data) => json.encode(data.toJson());

class LocalUserInfo {
    String firstName;
    String lastName;
    String username;
    String email;
    dynamic avatar;
    String language;

    LocalUserInfo({
        required this.firstName,
        required this.lastName,
        required this.username,
        required this.email,
        required this.avatar,
        required this.language,
    });

    factory LocalUserInfo.fromJson(Map<String, dynamic> json) => LocalUserInfo(
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        avatar: json["avatar"],
        language: json["language"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "avatar": avatar,
        "language": language,
    };
}
