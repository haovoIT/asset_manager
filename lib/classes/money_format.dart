import 'package:flutter/material.dart';

class MoneyMaskedTextControllers extends TextEditingController {
  MoneyMaskedTextControllers(
      {double initialValue = 0,
        this.thousandSeparator = '.',
      }) {
    this.addListener(() {
      this.updateValue(this.numberValue);
      //this.afterChange(this.text, this.numberValue);
    });

    //this.updateValue(initialValue);
  }

  final String thousandSeparator;

  //Function afterChange = (String maskedValue, double rawValue) {};

  double _lastValue = 0;

  void updateValue(double value) {
    double valueToUse = value;

    if (value.toStringAsFixed(0).length > 15) {
      valueToUse = _lastValue;
    }
    else {
      _lastValue = value;
    }

    String masked = this._applyMask(valueToUse);

    if (masked != this.text) {
      this.text = masked;

      var cursorPosition = super.text.length;
      this.selection = new TextSelection.fromPosition(
          new TextPosition(offset: cursorPosition));

    }
  }

  double get numberValue {
    List<String> parts = _getOnlyNumbers(this.text).split('').toList(growable: true);

    parts.insert(parts.length, '.');

    return double.parse(parts.join());
  }

  String _getOnlyNumbers(String text) {
    String cleanedText = text;

    var onlyNumbersRegex = new RegExp(r'[^\d]');

    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');

    return cleanedText;
  }

  String _applyMask(double value) {
    List<String> textRepresentation = value.toStringAsFixed(0)
        .replaceAll('.', '')
        .split('')
        .reversed
        .toList(growable: true);

    for (var i = 3; true; i = i + 4) {
      if (textRepresentation.length > i) {
        textRepresentation.insert(i, thousandSeparator);
      }
      else {
        break;
      }
    }

    return textRepresentation.reversed.join('');
  }
}
