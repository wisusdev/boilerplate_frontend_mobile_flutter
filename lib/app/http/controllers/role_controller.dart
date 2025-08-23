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
}