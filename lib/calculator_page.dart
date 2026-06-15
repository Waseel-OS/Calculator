import 'package:calculator/backend.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';

  @override
  Widget build(BuildContext context) {
    final buttons = [
      'AC',
      '⌫',
      '%',
      '÷',
      '7',
      '8',
      '9',
      '×',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '0',
      '.',
      '=',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      display,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            Expanded(
              flex: 7,
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final buttonText = buttons[index];
                  final isOperator = [
                    '÷',
                    '×',
                    '-',
                    '+',
                    '=',
                  ].contains(buttonText);

                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        display = Backend.display(display, buttonText);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOperator
                          ? Colors.orange
                          : const Color(0xFF2A2A2A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontSize: 24),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
