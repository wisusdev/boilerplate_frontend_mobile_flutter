import 'package:flutter/material.dart';

InputDecoration inputDecoration({required String labelText}){
    return InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.transparent)
        ),
    );
}