import 'dart:convert';
import 'dart:io';

import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/account_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';

class AccountController {
    
    Future<void> updateProfile(context, profileData, imageFile, Function setErrorMessages) async {

        if (imageFile != null) {
            final File file = File(imageFile.path);
            final List<int> imageBytes = await file.readAsBytes();
            final String base64Image = base64Encode(imageBytes);
            profileData['avatar'] = base64Image;
        }

        Map<String, dynamic> profileEditResponse = await AccountService().updateProfile(data: profileData);

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
}