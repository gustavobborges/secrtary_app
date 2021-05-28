import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:secretary/utils/appointment.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<AppointmentModel> _appointments = [];
  AppointmentUtils utils = AppointmentUtils();
  DateTime dateTime = null;

  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  @override
  void initState() {
    super.initState();
    setState(() {
      _getAllAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      firstDayOfWeek: 1,
      //initialDisplayDate: DateTime(2021, 03, 01, 08, 30),
      //initialSelectedDate: DateTime(2021, 03, 01, 08, 30),
      dataSource: _getCalendarDataSource(),
    );
  }

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];

    // utils.getAll().then((value) {
    //   _appointments = value;
    // });

    for (var app in _appointments) {
      dateTime = dateFormat.parse(app.dateTime);
      appointments.add(Appointment(
        startTime: dateTime,
        endTime: dateTime.add(Duration(minutes: 10)),
        subject: app.description,
        color: Colors.green,
        startTimeZone: '',
        endTimeZone: '',
      ));
    }
  }

  void _getAllAppointments() {
    utils.getAll().then((value) {
      setState(() {
        _appointments = value;
      });
    });
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
