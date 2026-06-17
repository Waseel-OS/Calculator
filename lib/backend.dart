class Backend {
  static final List<double> _numbers = [];
  static final List<String> _operators = [];

  static String display(String currentDisplay, String buttonText) {
    final trimmedDisplay = currentDisplay.trim();
    final lastNum = trimmedDisplay.isEmpty
        ? ''
        : trimmedDisplay.split(' ').last;

    if (['+', '-', '×', '÷', '%'].contains(buttonText)) {
      // Prevent adding consecutive operators
      if (currentDisplay.endsWith(' ')) {
        return currentDisplay;
      }
      return '$currentDisplay $buttonText ';
    }
    if (buttonText == 'AC') {
      _numbers.clear();
      _operators.clear();
      return '0';
    }

    if (buttonText == '⌫') {
      if (currentDisplay == '0' || currentDisplay.isEmpty) return '0';

      String shortened = currentDisplay.substring(
        0,
        currentDisplay.length - ((currentDisplay.endsWith(' ')) ? 3 : 1),
      );
      return shortened.isEmpty ? '0' : shortened;
    }

    if (buttonText == '=') {
      if (currentDisplay.endsWith(' ')) return currentDisplay;
      List<String> tokens = currentDisplay.trim().split(' ');

      _numbers.clear();
      _operators.clear();

      for (String token in tokens) {
        if (['+', '-', '×', '÷', '%'].contains(token)) {
          _operators.add(token);
        } else {
          _numbers.add(double.tryParse(token) ?? 0.0);
        }
      }

      if (_numbers.isEmpty) return '0';
      if (_operators.isEmpty) return currentDisplay;
      final output = _calculate();
      return output.isNaN
          ? 'Cannot be Divide by 0'
          : output % 1 == 0
          ? output.toInt().toString()
          : output.toString();
    }

    if ('00' == buttonText &&
        ['0', ''].contains(currentDisplay.split(' ').last)) {
      return currentDisplay;
    }

    if (currentDisplay == '0' && buttonText != '.') {
      return buttonText;
    }

    if ('.' == buttonText) {
      if (lastNum.contains('.')) return currentDisplay;
      if (lastNum.isEmpty) return '${currentDisplay}0.';
    }

    return '$currentDisplay$buttonText';
  }

  static double _calculate() {
    if (_numbers.isEmpty) return 0.0;
    int i = 0;
    while (i < _operators.length) {
      String op = _operators[i];

      if (['×', '÷', '%'].contains(op)) {
        if (op == '×') _numbers[i] *= _numbers[i + 1];
        if (op == '÷') {
          if (_numbers[i + 1] == 0) return double.nan;
          _numbers[i] /= _numbers[i + 1];
        }
        if (op == '%') _numbers[i] %= _numbers[i + 1];
        _numbers.removeAt(i + 1);
        _operators.removeAt(i);
      } else {
        i++;
      }
    }
    i = 0;
    while (i < _operators.length) {
      if (_operators[i] == '+') {
        _numbers[i] += _numbers[i + 1];
      } else {
        _numbers[i] -= _numbers[i + 1];
      }
      _numbers.removeAt(i + 1);
      _operators.removeAt(i);
    }

    return _numbers[0];
  }
}
