import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Location {
    
    final Locale locale;
    Map<String, dynamic> _sentences;

    Location(this.locale) : _sentences = {};

    static Location? of(BuildContext context) {
        return Localizations.of<Location>(context, Location);
    }

    Future<bool> load() async {
        String data = await rootBundle.loadString('lib/lang/${locale.languageCode}.json');
        Map<String, dynamic> result = json.decode(data);

        _sentences = _flattenMap(result);

        return true;
    }

    String trans(String key) {
        return _sentences[key] ?? '** $key not found';
    }

    Map<String, dynamic> _flattenMap(Map<String, dynamic> data, [String prefix = '']) {
        var result = <String, dynamic>{};
        data.forEach((key, value) {
            if (value is Map<String, dynamic>) {
                result.addAll(_flattenMap(value, '$prefix$key.'));
            } else {
                result['$prefix$key'] = value;
            }
        });
        return result;
    }
}