import 'package:boilerplate_frontend_mobile_flutter/app/data/models/user_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/base_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/response_validator.dart';
import 'package:flutter/cupertino.dart';

class UserController {
  Future<UserModel> userIndex(BuildContext context) async {
    final BaseService userService = BaseService();

    Map<String, dynamic> userIndexResponse = await userService.getUserIndex();

    final result = ResponseValidator.validateResponse(userIndexResponse);

    if (result.isSuccess && context.mounted) {
      return UserModel.fromJson(userIndexResponse['response']);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<UserData> userShow(BuildContext context, {required String userId}) async {
    final BaseService userService = BaseService();

    Map<String, dynamic> userShowResponse = await userService.getUserShow(userId: userId);

    final result = ResponseValidator.validateResponse(userShowResponse);

    if (result.isSuccess && context.mounted) {
      return UserData.fromJson(userShowResponse['response']['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> createUser(BuildContext context, {
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required List<String> roles,
  }) async {
    final BaseService userService = BaseService();

    Map<String, dynamic> data = {
      'type': 'users',
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'roles': roles,
    };

    Map<String, dynamic> userCreateResponse = await userService.createUser(data: data);

    final result = ResponseValidator.validateResponse(userCreateResponse);

    if (result.isSuccess && context.mounted) {
      return userCreateResponse['response'];
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<Map<String, dynamic>> updateUser(BuildContext context, {
    required String userId,
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    String? password,
    String? passwordConfirmation,
    required List<String> roles,
  }) async {
    final BaseService userService = BaseService();

    Map<String, dynamic> data = {
      'type': 'users',
      'id': userId,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password ?? '',
      'password_confirmation': passwordConfirmation ?? '',
      'roles': roles,
    };

    Map<String, dynamic> userUpdateResponse = await userService.updateUser(userId: userId, data: data);

    final result = ResponseValidator.validateResponse(userUpdateResponse);

    if (result.isSuccess && context.mounted) {
      return userUpdateResponse['response'];
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<bool> deleteUser(BuildContext context, {required String userId}) async {
    final BaseService userService = BaseService();

    int userDeleteResponse = await userService.deleteUser(userId: userId);

    if (userDeleteResponse == 204) {
      return true;
    } else {
      throw Exception('Failed to delete user');
    }
  }
}