import 'dart:convert';

RoleModel roleModelFromJson(String str) => RoleModel.fromJson(json.decode(str));

String roleModelToJson(RoleModel data) => json.encode(data.toJson());

class RoleModel {
    RoleModel({
        required this.data,
        required this.meta,
        required this.links,
    });

    List<RoleData> data;
    Meta meta;
    Links links;

    factory RoleModel.fromJson(Map<dynamic, dynamic> json) => RoleModel(
        data: List<RoleData>.from(json["data"].map((x) => RoleData.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
        links: Links.fromJson(json["links"]),
    );

    Map<dynamic, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
        "links": links.toJson(),
    };
}

class RoleData {
    RoleData({
        required this.permissions,
        required this.name,
        required this.id,
        required this.type,
    });

    List<Permission> permissions;
    String name;
    String id;
    String type;

    factory RoleData.fromJson(Map<dynamic, dynamic> json) => RoleData(
        permissions: List<Permission>.from(json["permissions"].map((x) => Permission.fromJson(x))),
        name: json["name"],
        id: json["id"],
        type: json["type"],
    );

    Map<dynamic, dynamic> toJson() => {
        "permissions": List<dynamic>.from(permissions.map((x) => x.toJson())),
        "name": name,
        "id": id,
        "type": type,
    };
}

class Permission {
    Permission({
        required this.name,
    });

    String name;

    factory Permission.fromJson(Map<dynamic, dynamic> json) => Permission(
        name: json["name"],
    );

    Map<dynamic, dynamic> toJson() => {
        "name": name,
    };
}

class Links {
    Links({
        required this.last,
        required this.first,
    });

    String last;
    String first;

    factory Links.fromJson(Map<dynamic, dynamic> json) => Links(
        last: json["last"],
        first: json["first"],
    );

    Map<dynamic, dynamic> toJson() => {
        "last": last,
        "first": first,
    };
}

class Meta {
    Meta({
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
    List<Link> links;
    int to;
    int currentPage;

    factory Meta.fromJson(Map<dynamic, dynamic> json) => Meta(
        path: json["path"],
        perPage: json["per_page"],
        total: json["total"],
        lastPage: json["last_page"],
        from: json["from"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
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

class Link {
    Link({
        required this.active,
        required this.label,
        this.url,
    });

    bool active;
    String label;
    String? url;

    factory Link.fromJson(Map<dynamic, dynamic> json) => Link(
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
