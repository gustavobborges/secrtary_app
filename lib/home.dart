import 'package:flutter/material.dart';
import 'package:secretary/components/createAppointmentButton.dart';
import 'calendar_page.dart';
import 'components/createFinanceButton.dart';
import 'finance_page.dart';
import 'list_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 1;

  List<Widget> pages = [
    Calendar(),
    ListAppointment(),
    Finance(),
  ];

  List<Widget> buttons = [
    AppointmentButton(),
    AppointmentButton(),
    FinanceButton(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Secretária"),
        centerTitle: true,
      ),
      floatingActionButton: buttons[currentIndex],
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.cyan,
        selectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Calendário"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_sharp), label: "Lista de Tarefas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money_outlined), label: "Financeiro"),
        ],
      ),
    );
  }
}
