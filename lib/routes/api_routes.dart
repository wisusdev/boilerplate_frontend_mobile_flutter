import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/account/profile_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/home_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/setting_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/users/user_create.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/users/user_edit.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/users/user_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/users/user_show.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/roles/role_create.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/roles/role_edit.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/roles/role_show.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/roles/role_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/account/change_password.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/account/delete_account.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/permissions/permission_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/guards/auth_guard.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/account/profile_edit.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/forgot_password.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/login.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/register.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/language_main.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/theme_main.dart';


Map<String, Widget Function(dynamic context)> api = {
    'home': (context) => const AuthGuard(child: HomeIndex()),

    // Auth
    'login': (context) => const AuthLogin(),
    'register': (context) => const AuthRegister(),
    'forgot_password': (context) => const AuthForgotPassword(),
    
    // settings
    'setting': (context) => const SettingIndex(),
    'language': (context) => const LanguageMain(),
    'theme': (context) => const ThemeMain(),

    // Account
    'profile': (context) => const AuthGuard(child: ProfileIndex()),
    'profile_edit': (context) => const AuthGuard(child: ProfileEdit()),
    'change_password': (context) => const AuthGuard(child: ChangePassword()),
    'delete_account': (context) => const AuthGuard(child: DeleteAccount()),

    // Permissions
    'permissions_index': (context) => const AuthGuard(child: PermissionIndex()),

    // Roles
    'roles_index': (context) => const AuthGuard(child: RoleIndex()),
    'roles_show': (context) => const AuthGuard(child: RoleShow()),
    'roles_create': (context) => const AuthGuard(child: RoleCreate()),
    'roles_edit': (context) => const AuthGuard(child: RoleEdit()),

    // Users
    'users_index': (context) => const AuthGuard(child: UserIndex()),
    'users_show': (context) => const AuthGuard(child: UserShow()),
    'users_create': (context) => const AuthGuard(child: UserCreate()),
    'users_edit': (context) => const AuthGuard(child: UserEdit()),
};