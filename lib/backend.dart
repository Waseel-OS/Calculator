class Backend {
  static final List<double> _numbers = [];
  static final List<String> _operators = [];
  static bool showMiniDisplay = false;

  static String display(String currentDisplay, String buttonText) {
    final trimmedDisplay = currentDisplay.trim();
    final lastNum = trimmedDisplay.isEmpty
        ? ''
        : trimmedDisplay.split(' ').last;

    if (['+', '-', '×', '÷', '%'].contains(buttonText)) {
      if (currentDisplay.endsWith(' ')) {
        return currentDisplay;
      }
      _numbers.add(double.tryParse(currentDisplay.split(' ').last) ?? 0.0);
      _operators.add(buttonText);
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
      showMiniDisplay = false;
      if (currentDisplay.endsWith(' ')) return currentDisplay;

      _numbers.clear();
      _operators.clear();
      final data = evaluateNumbers(currentDisplay);

      _numbers.addAll(data.$1);
      _operators.addAll(data.$2);

      if (_numbers.isEmpty) return '0';
      if (_operators.isEmpty) return currentDisplay;
      final output = _calculate(_numbers, _operators);
      _numbers.clear();
      _operators.clear();
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

  static String miniDisplay(String currentDisplay) {
    showMiniDisplay = true;
    if (currentDisplay == '0' || currentDisplay.isEmpty) {
      showMiniDisplay = false;
      return '';
    }
    final data = evaluateNumbers(currentDisplay);
    List<double> localNumbers = data.$1;
    List<String> localOperators = data.$2;
    if (localOperators.length == localNumbers.length) {
      localOperators.removeLast();
    }

    final output = _calculate(localNumbers, localOperators);

    if (output.isNaN) return '';
    return output % 1 == 0 ? output.toInt().toString() : output.toString();
  }

  static (List<double>, List<String>) evaluateNumbers(String display) {
    List<double> localNumbers = [];
    List<String> localOperators = [];

    List<String> tokens = display.trim().split(' ');

    for (String token in tokens) {
      if (['+', '-', '×', '÷', '%'].contains(token)) {
        localOperators.add(token);
      } else {
        localNumbers.add(double.tryParse(token) ?? 0.0);
      }
    }

    // Return them as a tuple/record
    return (localNumbers, localOperators);
  }

  static double _calculate(List<double> numbers, List<String> operators) {
    if (numbers.isEmpty) return 0.0;
    int i = 0;
    while (i < operators.length) {
      String op = operators[i];

      if (['×', '÷', '%'].contains(op)) {
        if (op == '×') numbers[i] *= numbers[i + 1];
        if (op == '÷') {
          if (numbers[i + 1] == 0) return double.nan;
          numbers[i] /= numbers[i + 1];
        }
        if (op == '%') numbers[i] %= numbers[i + 1];
        numbers.removeAt(i + 1);
        operators.removeAt(i);
      } else {
        i++;
      }
    }
    i = 0;
    while (i < operators.length) {
      if (operators[i] == '+') {
        numbers[i] += numbers[i + 1];
      } else {
        numbers[i] -= numbers[i + 1];
      }
      numbers.removeAt(i + 1);
      operators.removeAt(i);
    }

    return numbers[0];
  }
}
