import 'package:flutter/material.dart';

class LanguajeMain extends StatefulWidget {
  	const LanguajeMain({super.key});

  	@override
  	State<LanguajeMain> createState() => _LanguajeMainState();
}

class _LanguajeMainState extends State<LanguajeMain> {
  	@override
  	Widget build(BuildContext context) {
		return Container(
            child: const Text('Languaje'),
        );
  	}
}