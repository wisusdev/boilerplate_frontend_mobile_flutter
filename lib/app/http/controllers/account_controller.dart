import 'dart:convert';
import 'dart:io';

import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/account_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

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

        if (profileEditResponse.containsKey('data')) {
            toastSuccess(context, Location.of(context)!.trans('recordUpdated'));
        }

        if (profileEditResponse.containsKey('errors')) {
            var errors = profileEditResponse['errors'];
            Map<String, dynamic> errorMessages = {
                'first_name': null,
                'last_name': null,
                'email': null,
                'avatar': null,
                'language': null,
            };

            if (errors is List) {
                for (var error in errors) {
                    String title = error['title'];
                    List<String> titleList = title.split('.');
                    errorMessages[titleList.last] = Location.of(context)!.trans(error['detail']);
                }
            }

            setErrorMessages(errorMessages);
            toastDanger(context, Location.of(context)!.trans('errorAsOccurred'));
        }
    }

    Future<void> changePassword(BuildContext context, passwordData, Function setErrorMessages) async {
        final AccountService accountService = AccountService();

        Map<String, dynamic> passwordChangeResponse = await accountService.changePassword(data: passwordData);

        if (passwordChangeResponse.containsKey('data')) {
            toastSuccess(context, Location.of(context)!.trans('recordUpdated'));
        }

        if (passwordChangeResponse.containsKey('errors')) {
            var errors = passwordChangeResponse['errors'];
            Map<String, dynamic> errorMessages = {
                'current_password': null,
                'password': null,
                'password_confirmation': null,
            };

            if (errors is List) {
                for (var error in errors) {
                    String title = error['title'];
                    List<String> titleList = title.split('.');
                    errorMessages[titleList.last] = Location.of(context)!.trans(error['detail']);
                }
            }

            setErrorMessages(errorMessages);
            toastDanger(context, Location.of(context)!.trans('errorAsOccurred'));
        }

    } 

    Future<void> getDeviceAuthList(BuildContext context, Function setDeviceAuthList) async {
        final AccountService accountService = AccountService();

        Map<String, dynamic> deviceAuthListResponse = await accountService.getDeviceAuthList();

        if (deviceAuthListResponse.containsKey('response') && deviceAuthListResponse['response'].containsKey('data')) {
            setDeviceAuthList(deviceAuthListResponse);
        }
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