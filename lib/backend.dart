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
      return _calculate();
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

  static String _calculate() {
    if (_numbers.isEmpty) return '0.0';
    double result = _numbers[0];

    for (int i = 0; i < _operators.length; i++) {
      if (i + 1 >= _numbers.length) break;

      switch (_operators[i]) {
        case '+':
          result += _numbers[i + 1];
          break;
        case '-':
          result -= _numbers[i + 1];
          break;
        case '×':
          result *= _numbers[i + 1];
          break;
        case '÷':
          if (_numbers[i + 1] == 0) return 'Cannot Divide by 0';
          result /= _numbers[i + 1];
          break;
        case '%':
          result = result % _numbers[i + 1];
          break;
      }
    }

    return result % 1 == 0 ? result.toInt().toString() : result.toString();
  }
}
