import 'package:flutter/material.dart';

class DropdownMenuItemUtil {
  static DropdownMenuItem<String> buildDropdownMenuItem<T>(
    T item,
    String value,
    String description,
  ) {
    return DropdownMenuItem<String>(
      value: value,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
