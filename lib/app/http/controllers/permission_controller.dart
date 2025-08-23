import 'package:boilerplate_frontend_mobile_flutter/app/data/models/permissions_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/base_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/response_validator.dart';
import 'package:flutter/cupertino.dart';

class PermissionController {
  Future<PermissionsModel> permissionIndex(BuildContext context) async {
    final BaseService permissionService = BaseService();
    
    Map<String, dynamic> permissionIndexResponse = await permissionService.getPermissions();

    final result = ResponseValidator.validateResponse(permissionIndexResponse);

    if (result.isSuccess && context.mounted) {
      return PermissionsModel.fromJson(permissionIndexResponse['response']);
    } else {
      throw Exception('Failed to load permissions');
    }

  }
}