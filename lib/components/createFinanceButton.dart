import 'package:flutter/material.dart';

class FinanceButton extends StatefulWidget {
  @override
  _FinanceButtonState createState() => _FinanceButtonState();
}

class _FinanceButtonState extends State<FinanceButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: Icon(Icons.attach_money_outlined),
      onPressed: () {},
    );
  }
}
