import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Location {
    
    final Locale locale;

    Location(this.locale) : _sentences = {};

    static Location? of(BuildContext context) {
        return Localizations.of<Location>(context, Location);
    }

    Map<String, String> _sentences;

    Future<bool> load() async {
        String data = await rootBundle.loadString('lib/lang/${locale.languageCode}.json');
        
        Map<String, dynamic> result = json.decode(data);

        _sentences = <String, String>{};

        result.forEach((String key, dynamic value) {
            _sentences[key] = value.toString();
        });

        return true;
    }

    String trans(String key) {
        return _sentences[key] ?? '** $key not found';
    }

}
