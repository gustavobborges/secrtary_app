import 'package:flutter/material.dart';
import 'package:secretary/utils/appointment.dart';

import 'appointment_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Appointment> _appointments = [];
  AppointmentUtils utils = AppointmentUtils();

  @override
  void initState() {
    super.initState();
    _getAllAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Secretária"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          _showAppointment();
        },
      ),
    );
  }

  void _getAllAppointments() {
    utils.getAll().then((value) {
      setState(() {
        _appointments = value;
      });
    });
  }

  void _showAppointment({Appointment appointment}) async {
    final recAppointment = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentPage(appointment: appointment),
      ),
    );

    if (recAppointment != null) {
      if (appointment != null) {
        await utils.update(recAppointment);
      } else {
        await utils.save(recAppointment);
      }
    }

    _getAllAppointments();
  }
}
