import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';

class SettingIndex extends StatefulWidget {
  const SettingIndex({Key? key}) : super(key: key);

  @override
  State<SettingIndex> createState() => _SettingIndexState();
}

class _SettingIndexState extends State<SettingIndex> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.onSecondary,
                boxShadow: [
                  BoxShadow(color: Theme.of(context).colorScheme.shadow, offset: const Offset(0, 1), blurRadius: 3),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.translate, color: Theme.of(context).colorScheme.primary),
                    title: Text(capitalizeText(Location.of(context)!.trans('language')), style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.of(context).pushNamed('language');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.palette, color: Theme.of(context).colorScheme.primary),
                    title: Text(capitalizeText(Location.of(context)!.trans('theme')), style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.of(context).pushNamed('theme');
                    },
                  ),
                ],
              ),
            )
          ]),
        ),
      ]),
    );
  }
}
