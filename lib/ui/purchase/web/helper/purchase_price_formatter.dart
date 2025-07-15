import 'package:flutter/services.dart';

class PurchasePriceInputFormatter extends TextInputFormatter {
  final int maxValue;

  PurchasePriceInputFormatter({required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final int? value = int.tryParse(newValue.text);
    if (value == null || value < 0 || value > maxValue) {
      return oldValue; // Reject invalid or out-of-range input
    }

    return newValue; // Accept valid input
  }
}
