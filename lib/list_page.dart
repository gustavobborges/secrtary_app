import 'package:flutter/material.dart';
import 'package:secretary/utils/appointment.dart';
import 'appointment_page.dart';

class ListAppointment extends StatefulWidget {
  @override
  _ListAppointmentState createState() => _ListAppointmentState();
}

class _ListAppointmentState extends State<ListAppointment> {
  List<Appointment> _appointments = [];
  AppointmentUtils utils = AppointmentUtils();

  @override
  void initState() {
    super.initState();
    _getAllAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          return _appointmentCard(context, index);
        });
  }

  Widget _appointmentCard(BuildContext contex, int index) {
    return GestureDetector(
      onTap: () {
        _showAppointment(appointment: _appointments[index]);
      },
      onDoubleTap: () {
        _deleteAppointment(appointment: _appointments[index]);
      },
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _appointments[index].name,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  _appointments[index].description != null
                      ? Row(
                          children: [
                            Text(
                              " ... ",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Text(
                              _appointments[index].description,
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        )
                      : Row(),
                  _appointments[index].place != null
                      ? Row(
                          children: [
                            Icon(
                              Icons.pin_drop_outlined,
                              size: 28,
                            ),
                            Text(
                              _appointments[index].place,
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        )
                      : Row(),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 28,
                      ),
                      Text(
                        _appointments[index].date,
                        style: TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 28,
                      ),
                      Text(
                        _appointments[index].time,
                        style: TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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

  void _deleteAppointment({Appointment appointment}) {
    utils.delete(appointment.id);
    _getAllAppointments();
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
