import 'dart:convert';

ConnectedDevices connectedDevicesFromJson(String str) => ConnectedDevices.fromJson(json.decode(str));

String connectedDevicesToJson(ConnectedDevices data) => json.encode(data.toJson());

class ConnectedDevices {
    List<Datum> data;
    Links links;
    Meta meta;

    ConnectedDevices({
        required this.data,
        required this.links,
        required this.meta,
    });

    factory ConnectedDevices.fromJson(Map<String, dynamic> json) => ConnectedDevices(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
    };
}

class Datum {
    String type;
    String id;
    Attributes attributes;

    Datum({
        required this.type,
        required this.id,
        required this.attributes,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: json["type"],
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "attributes": attributes.toJson(),
    };
}

class Attributes {
    DateTime loginAt;
    String browser;
    String os;
    String ip;
    String country;

    Attributes({
        required this.loginAt,
        required this.browser,
        required this.os,
        required this.ip,
        required this.country,
    });

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        loginAt: DateTime.parse(json["login_at"]),
        browser: json["browser"],
        os: json["os"],
        ip: json["ip"],
        country: json["country"],
    );

    Map<String, dynamic> toJson() => {
        "login_at": loginAt.toIso8601String(),
        "browser": browser,
        "os": os,
        "ip": ip,
        "country": country,
    };
}

class Links {
    String first;
    String last;
    dynamic prev;
    dynamic next;

    Links({
        required this.first,
        required this.last,
        required this.prev,
        required this.next,
    });

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
    };
}

class Meta {
    int currentPage;
    int from;
    int lastPage;
    List<Link> links;
    String path;
    int perPage;
    int to;
    int total;

    Meta({
        required this.currentPage,
        required this.from,
        required this.lastPage,
        required this.links,
        required this.path,
        required this.perPage,
        required this.to,
        required this.total,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
    };
}

class Link {
    String? url;
    String label;
    bool active;

    Link({
        required this.url,
        required this.label,
        required this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}
