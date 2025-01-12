import 'package:flutter/material.dart';

InputDecoration inputDecorationStyle({required String labelText}){
    return InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.transparent)
        ),
    );
}