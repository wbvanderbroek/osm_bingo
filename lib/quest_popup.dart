import 'package:flutter/material.dart';

class QuestPopup extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const QuestPopup({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Je bent in de buurt van een bingo locatie!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(text, style: TextStyle(fontSize: 18)),
        ],
      ),
      actions: [
        TextButton(onPressed: onButtonPressed, child: Text(buttonText)),
      ],
    );
  }
}
