import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/interfaces/local/menu_model.dart';

const appMenuItems = <MenuItem>[
    MenuItem(
        title: 'permissions', 
        subTitle: 'Permissions view', 
        link: 'permissions_index', 
        icon: Icons.lock
    ),

    MenuItem(
        title: 'roles', 
        subTitle: 'Roles view', 
        link: 'roles_index', 
        icon: Icons.assignment_ind
    ),

    MenuItem(
        title: 'users', 
        subTitle: 'Users view', 
        link: 'users_index', 
        icon: Icons.supervised_user_circle
    )
];