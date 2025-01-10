import 'package:boilerplate_frontend_mobile_flutter/resources/views/account/change_password.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/account/connected_devices.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/account/delete_account.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/guards/auth_guard.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/account/profile_edit.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/forgot_password.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/login.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/register.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/home.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/account/profile_main.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/language_main.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/setting_main.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/theme_main.dart';

Map<String, Widget Function(dynamic context)> routes = {
    'home': (context) => const AuthGuard(child: HomeView()),
    // Account
    'profile': (context) => const AuthGuard(child: ProfileMain()),
    'profile_edit': (context) => const AuthGuard(child: ProfileEdit()),
    'change_password': (context) => const AuthGuard(child: ChangePassword()),
    'delete_account': (context) => const AuthGuard(child: DeleteAccount()),
    'connected_devices': (context) => const AuthGuard(child: ConnectedDevices()),
    'setting': (context) => const AuthGuard(child: SettingMain()),
    
    // Auth
    'login': (context) => const AuthLogin(),
    'register': (context) => const AuthRegister(),
    'forgot_password': (context) => const AuthForgotPassword(),
    
    // settings
    'language': (context) => const AuthGuard(child: LanguajeMain()),
    'theme': (context) => const AuthGuard(child: ThemeMain()),
};