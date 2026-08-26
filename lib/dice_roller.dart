import 'dart:math';
import 'package:flutter/material.dart';

final randomizer = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> {
  var currentDiceNumber = 1;

  void rollDice() {
    setState(() {
      currentDiceNumber = randomizer.nextInt(6) + 1; 
    });
  }

  @override
  Widget build(BuildContext context) { 
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/dice-images/dice-$currentDiceNumber.png',
          width: 200,
        ),
        const SizedBox(height: 30),
        TextButton(
          onPressed: rollDice,
          style: TextButton.styleFrom(
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            'Roll Dice',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
} // Fixed: Restored missing closing class bracket
