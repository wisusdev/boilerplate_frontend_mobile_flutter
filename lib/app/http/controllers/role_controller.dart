import 'package:boilerplate_frontend_mobile_flutter/app/data/models/role_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/base_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/response_validator.dart';
import 'package:flutter/cupertino.dart';

class RoleController {
  Future<RoleModel> roleIndex(BuildContext context) async {
    final BaseService roleService = BaseService();

    Map<String, dynamic> roleIndexResponse = await roleService.getRoleIndex();

    final result = ResponseValidator.validateResponse(roleIndexResponse);

    if (result.isSuccess && context.mounted) {
      return RoleModel.fromJson(roleIndexResponse['response']);
    } else {
      throw Exception('Failed to load roles');
    }
  }

  Future<Map<String, dynamic>> createRole(BuildContext context, {required String name, required List<String> permissions}) async {
    final BaseService roleService = BaseService();

    Map<String, dynamic> data = {
      'type': 'roles',
      'name': name,
      'permissions': permissions,
    };

    Map<String, dynamic> roleCreateResponse = await roleService.createRole(data: data);

    final result = ResponseValidator.validateResponse(roleCreateResponse);

    if (result.isSuccess && context.mounted) {
      return roleCreateResponse['response'];
    } else {
      throw Exception('Failed to create role');
    }
  }

  Future<Map<String, dynamic>> updateRole(BuildContext context, {required String roleId, required String name, required List<String> permissions}) async {
    final BaseService roleService = BaseService();

    Map<String, dynamic> data = {
      'type': 'roles',
      'id': roleId,
      'name': name,
      'permissions': permissions,
    };

    Map<String, dynamic> roleUpdateResponse = await roleService.updateRole(roleId: roleId, data: data);

    final result = ResponseValidator.validateResponse(roleUpdateResponse);

    if (result.isSuccess && context.mounted) {
      return roleUpdateResponse['response'];
    } else {
      throw Exception('Failed to update role');
    }
  }

  Future<bool> deleteRole(BuildContext context, {required String roleId}) async {
    final BaseService roleService = BaseService();

    int roleDeleteResponse = await roleService.deleteRole(roleId: roleId);

    if (roleDeleteResponse == 204) {
      return true;
    } else {
      throw Exception('Failed to delete role');
    }
  }
}