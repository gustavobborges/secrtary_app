import 'package:flutter/material.dart';
import 'package:secretary/utils/appointment.dart';
import 'package:secretary/utils/utils.dart';
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
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: _appointments.length,
          itemBuilder: (context, index) {
            return _appointmentCard(context, index);
          }),
    );
  }

  Widget _appointmentCard(BuildContext contex, int index) {
    return GestureDetector(
      onTap: () {
        _showAppointment(appointment: _appointments[index]);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textDefault(_appointments[index].name, true),
                    textDefault(_appointments[index].description, false),
                    textDefault(_appointments[index].place, false),
                    textDefault(_appointments[index].date, false),
                    textDefault(_appointments[index].time, false),
                  ],
                ),
              ),
            ],
          ),
        ),
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
