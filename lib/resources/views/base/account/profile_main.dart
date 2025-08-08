import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/auth_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/modal_confirm.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/account/profile_edit.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/interfaces/local/local_user_info.dart';

class ProfileMain extends StatefulWidget {
  static const String title = 'profile';
  const ProfileMain({Key? key}) : super(key: key);

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  final AuthService _authService = AuthService();
  late Future<LocalUserInfo> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = _loadUser();
  }

  Future<LocalUserInfo> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '{}';
    return LocalUserInfo.fromJson(jsonDecode(user));
  }

  void _refreshUser() {
    setState(() {
      _futureUser = _loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalUserInfo>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              toastDanger(context, 'Error al cargar el perfil');
            });
            return const SizedBox.shrink();
          } else {
            return _buildProfile(context, snapshot.data!);
          }
        },
      );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        capitalizeText(Location.of(context)!.trans('profile')),
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildProfile(BuildContext context, LocalUserInfo userInfo) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(context, userInfo),
          const SizedBox(height: 20),
          _buildProfileOptions(context, userInfo),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, LocalUserInfo userInfo) {
    return Container(
      color: Theme.of(context).colorScheme.onSecondary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(context, userInfo),
            const SizedBox(width: 20),
            _buildUserInfo(context, userInfo),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, LocalUserInfo userInfo) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: FadeInImage(
          height: 100,
          width: 100,
          image: userInfo.avatar != null && userInfo.avatar.isNotEmpty
              ? NetworkImage(userInfo.avatar) as ImageProvider<Object>
              : const AssetImage(profileImageDefault),
          placeholder: const AssetImage(profileImageDefault),
          imageErrorBuilder: (context, error, stackTrace) => const Image(
              image: AssetImage(profileImageDefault), fit: BoxFit.fitWidth),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, LocalUserInfo userInfo) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${userInfo.firstName} ${userInfo.lastName}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21.0),
          ),
          Text(
            userInfo.username,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context, LocalUserInfo userInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _buildOptionCard(context, userInfo),
    );
  }

  Widget _buildOptionCard(BuildContext context, LocalUserInfo userInfo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onSecondary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildListTile(
            context,
            icon: Icons.edit,
            color: Theme.of(context).colorScheme.primary,
            title: Location.of(context)!.trans('profile'),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileEdit()),
              );
              if (result == 'update' && mounted) {
                _refreshUser();
              }
            },
          ),
          _buildListTile(
            context,
            icon: Icons.key,
            color: Theme.of(context).colorScheme.primary,
            title: Location.of(context)!.trans('changePassword'),
            onTap: () => Navigator.pushNamed(context, 'change_password'),
          ),
          _buildListTile(
            context,
            icon: Icons.logout,
            color: Theme.of(context).colorScheme.error,
            title: Location.of(context)!.trans('logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ModalConfirm(
                    title: Location.of(context)!.trans('logout'),
                    content: Location.of(context)!.trans('logoutConfirm'),
                    onConfirm: () async {
                      if (await _authService.logout()) {
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              'login', (Route<dynamic> route) => false);
                        }
                      }
                    },
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required Color color,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right, color: color),
    );
  }
}
