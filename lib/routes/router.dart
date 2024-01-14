import 'package:flutter/material.dart';
import 'package:todolist_flutter/resources/views/auth/forgot_password.dart';
import 'package:todolist_flutter/resources/views/auth/login.dart';
import 'package:todolist_flutter/resources/views/auth/register.dart';
import 'package:todolist_flutter/resources/views/home.dart';
import 'package:todolist_flutter/resources/views/profile/profile_main.dart';
import 'package:todolist_flutter/resources/views/settings/language_main.dart';
import 'package:todolist_flutter/resources/views/settings/setting_main.dart';
import 'package:todolist_flutter/resources/views/settings/theme_main.dart';

Map<String, StatefulWidget Function(dynamic context)> routes = {
    'home': (context) => const HomeView(),
    'profile': (context) => const ProfileMain(),
    'setting': (context) => const SettingMain(),
    
    // Auth
    'login': (context) => const AuthLogin(),
    'register': (context) => const AuthRegister(),
    'forgot_password': (context) => const AuthForgotPassword(),
    
    // settings
    'language': (context) => const LanguajeMain(),
    'theme': (context) => const ThemeMain(),
};