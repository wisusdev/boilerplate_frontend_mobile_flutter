import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/response_validator.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/account_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';

class AccountController {
    
    Future<void> updateProfile(BuildContext context, profileData, imageFile, Function setErrorMessages) async {

        if (imageFile != null) {
            final File file = File(imageFile.path);
            final List<int> imageBytes = await file.readAsBytes();
            final String base64Image = base64Encode(imageBytes);
            profileData['avatar'] = base64Image;
        }

        final AccountService accountService = AccountService();

        Map<String, dynamic> profileEditResponse = await accountService.updateProfile(data: profileData);

        final result = ResponseValidator.validateResponse(profileEditResponse);
        
        if (result.isSuccess && context.mounted) {
            toastSuccess(context, Location.of(context)!.trans('recordUpdated'));
        } else if (!result.isSuccess) {
            
            Map<String, String?> errorMessages = {
                'first_name': null,
                'last_name': null,
                'email': null,
                'avatar': null,
                'language': null,
            };

            if (result.errors != null && context.mounted) {
                errorMessages = ResponseValidator.processFieldErrors(result.errors, errorMessages, context);
            }

            setErrorMessages(errorMessages);
            if (context.mounted) {
                toastDanger(context, Location.of(context)!.trans('errorAsOccurred'));
            }
        }
    }

    Future<void> changePassword(BuildContext context, passwordData, Function setErrorMessages) async {
        final AccountService accountService = AccountService();

        Map<String, dynamic> passwordChangeResponse = await accountService.changePassword(data: passwordData);

        final result = ResponseValidator.validateResponse(passwordChangeResponse);
        
        if (result.isSuccess && context.mounted) {
            toastSuccess(context, Location.of(context)!.trans('recordUpdated'));
        } else if (!result.isSuccess) {
            Map<String, String?> errorMessages = {
                'current_password': null,
                'password': null,
                'password_confirmation': null,
            };

            if (result.errors != null && context.mounted) {
                errorMessages = ResponseValidator.processFieldErrors(result.errors, errorMessages, context);
            }

            setErrorMessages(errorMessages);
            if (context.mounted) {
                toastDanger(context, Location.of(context)!.trans('errorAsOccurred'));
            }
        }
    } 

    Future<void> getDeviceAuthList(BuildContext context, Function setDeviceAuthList) async {
        final AccountService accountService = AccountService();

        Map<String, dynamic> deviceAuthListResponse = await accountService.getDeviceAuthList();

        setDeviceAuthList(deviceAuthListResponse);
    }

    Future<void> disconnectDevice(BuildContext context, String deviceId, Function setDeviceAuthList) async {
        final AccountService accountService = AccountService();

        Map<String, String> data = {
            "type": "logout-device",
            "id": deviceId,
            "device_id": deviceId,
        };

        Map<String, dynamic> disconnectDeviceResponse = await accountService.disconnectDevice(data: data);

        if (disconnectDeviceResponse.containsKey('response') && disconnectDeviceResponse['response'].containsKey('data')) {
            disconnectDeviceResponse['id'] = deviceId;
            setDeviceAuthList(disconnectDeviceResponse);
        }
    }
}