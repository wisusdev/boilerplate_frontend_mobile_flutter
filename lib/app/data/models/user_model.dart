import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.data,
    required this.meta,
    required this.links,
  });

  List<UserData> data;
  UserMeta meta;
  UserLinks links;

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
        data: List<UserData>.from(json["data"].map((x) => UserData.fromJson(x))),
        meta: UserMeta.fromJson(json["meta"]),
        links: UserLinks.fromJson(json["links"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
        "links": links.toJson(),
      };
}

class UserData {
  UserData({
    required this.relationships,
    required this.attributes,
    required this.id,
    required this.type,
  });

  UserRelationships relationships;
  UserAttributes attributes;
  String id;
  Type type;

  factory UserData.fromJson(Map<dynamic, dynamic> json) => UserData(
        relationships: UserRelationships.fromJson(json["relationships"]),
        attributes: UserAttributes.fromJson(json["attributes"]),
        id: json["id"],
        type: typeValues.map[json["type"]]!,
      );

  Map<dynamic, dynamic> toJson() => {
        "relationships": relationships.toJson(),
        "attributes": attributes.toJson(),
        "id": id,
        "type": typeValues.reverse[type],
      };
}

class UserAttributes {
  UserAttributes({
    required this.updatedAt,
    required this.lastName,
    required this.createdAt,
    this.emailVerifiedAt,
    required this.firstName,
    required this.email,
    required this.username,
  });

  DateTime updatedAt;
  String lastName;
  DateTime createdAt;
  DateTime? emailVerifiedAt;
  String firstName;
  String email;
  String username;

  factory UserAttributes.fromJson(Map<dynamic, dynamic> json) => UserAttributes(
        updatedAt: DateTime.parse(json["updated_at"]),
        lastName: json["last_name"],
        createdAt: DateTime.parse(json["created_at"]),
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        firstName: json["first_name"],
        email: json["email"],
        username: json["username"],
      );

  Map<dynamic, dynamic> toJson() => {
        "updated_at": updatedAt.toIso8601String(),
        "last_name": lastName,
        "created_at": createdAt.toIso8601String(),
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "first_name": firstName,
        "email": email,
        "username": username,
      };
}

class UserRelationships {
  UserRelationships({
    required this.roles,
  });

  List<String> roles;

  factory UserRelationships.fromJson(Map<dynamic, dynamic> json) => UserRelationships(
        roles: List<String>.from(json["roles"].map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "roles": List<dynamic>.from(roles.map((x) => x)),
      };
}

enum Type { USERS }

final typeValues = EnumValues({"users": Type.USERS});

class UserLinks {
  UserLinks({
    required this.last,
    required this.first,
  });

  String last;
  String first;

  factory UserLinks.fromJson(Map<dynamic, dynamic> json) => UserLinks(
        last: json["last"],
        first: json["first"],
      );

  Map<dynamic, dynamic> toJson() => {
        "last": last,
        "first": first,
      };
}

class UserMeta {
  UserMeta({
    required this.path,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.from,
    required this.links,
    required this.to,
    required this.currentPage,
  });

  String path;
  int perPage;
  int total;
  int lastPage;
  int from;
  List<UserLink> links;
  int to;
  int currentPage;

  factory UserMeta.fromJson(Map<dynamic, dynamic> json) => UserMeta(
        path: json["path"],
        perPage: json["per_page"],
        total: json["total"],
        lastPage: json["last_page"],
        from: json["from"],
        links: List<UserLink>.from(json["links"].map((x) => UserLink.fromJson(x))),
        to: json["to"],
        currentPage: json["current_page"],
      );

  Map<dynamic, dynamic> toJson() => {
        "path": path,
        "per_page": perPage,
        "total": total,
        "last_page": lastPage,
        "from": from,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "to": to,
        "current_page": currentPage,
      };
}

class UserLink {
  UserLink({
    required this.active,
    required this.label,
    this.url,
  });

  bool active;
  String label;
  String? url;

  factory UserLink.fromJson(Map<dynamic, dynamic> json) => UserLink(
        active: json["active"],
        label: json["label"],
        url: json["url"],
      );

  Map<dynamic, dynamic> toJson() => {
        "active": active,
        "label": label,
        "url": url,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
