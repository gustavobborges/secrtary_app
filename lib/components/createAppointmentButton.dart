import 'package:flutter/material.dart';
import 'package:secretary/utils/appointment.dart';
import '../appointment_page.dart';

class AppointmentButton extends StatefulWidget {
  @override
  _AppointmentButtonState createState() => _AppointmentButtonState();
}

class _AppointmentButtonState extends State<AppointmentButton> {
  List<Appointment> _appointments = [];
  AppointmentUtils utils = AppointmentUtils();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          _showAppointment();
        });
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
