import 'package:flutter/material.dart';
import 'package:lottery_flutter/utils/theme.dart';

InputDecoration borderedInputDecoration(
        {String? label,
        String? hint,
        String? prefixText,
        Icon? icon,
        TextStyle? hintStyle,
        TextStyle? labelStyle,
        Widget? suffixIcon,
        EdgeInsetsGeometry? padding,
        bool border = true,
        bool underline = false,
        Color? fillColor}) =>
    InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefixText,
      fillColor: fillColor,
      labelStyle: labelStyle,
      hintStyle: hintStyle ?? TextStyle(color: Colors.grey.shade400),
      // contentPadding: padding ?? (!border ? const EdgeInsets.all(4) : null),
      // counter: Container(height: 0.1),
      suffixIcon: suffixIcon,
      focusColor: primaryColor,

      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder: border
          ? OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400))
          : InputBorder.none,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      border: border
          ? OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400))
          : !underline
              ? InputBorder.none
              : null,
      prefixIcon: icon,
    );
