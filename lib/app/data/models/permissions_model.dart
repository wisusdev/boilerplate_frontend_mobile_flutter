import 'dart:convert';

PermissionsModel permissionsModelFromJson(String str) => PermissionsModel.fromJson(json.decode(str));

String permissionsModelToJson(PermissionsModel data) => json.encode(data.toJson());

class PermissionsModel {
  PermissionData data;

  PermissionsModel({
    required this.data,
  });

  factory PermissionsModel.fromJson(Map<dynamic, dynamic> json) => PermissionsModel(data: PermissionData.fromJson(json["data"]));

  Map<dynamic, dynamic> toJson() => {"data": data.toJson()};
}

class PermissionData {
  PermissionData({
    required this.attributes,
    required this.type,
  });

  List<PermissionAttribute> attributes;
  String type;

  factory PermissionData.fromJson(Map<dynamic, dynamic> json) => PermissionData(
    attributes: List<PermissionAttribute>.from(json["attributes"].map((x) => PermissionAttribute.fromJson(x))),
    type: json["type"],
  );

  Map<dynamic, dynamic> toJson() => {
    "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
    "type": type,
  };
}

class PermissionAttribute {
  PermissionAttribute({
    required this.name,
  });

  String name;

  factory PermissionAttribute.fromJson(Map<dynamic, dynamic> json) => PermissionAttribute(
    name: json["name"],
  );

  Map<dynamic, dynamic> toJson() => {
    "name": name,
  };
}
