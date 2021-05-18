import 'package:flutter/material.dart';
import 'package:secretary/utils/appointment.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppointmentPage extends StatefulWidget {
  final Appointment appointment;
  AppointmentPage({this.appointment});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  Appointment _editedAppointment;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  bool _edited = false;
  final _nameFocus = FocusNode();
  String date = "";
  String dateText = "";

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _editedAppointment = widget.appointment;
      _nameController.text = _editedAppointment.name;
      _descriptionController.text = _editedAppointment.description;
      _placeController.text = _editedAppointment.place;
      _dateController.text = _editedAppointment.date;
      _timeController.text = _editedAppointment.time;
    } else {
      _editedAppointment = Appointment();
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text(
            _editedAppointment.name != null &&
                    _editedAppointment.name.isNotEmpty
                ? _editedAppointment.name
                : "Novo Compromisso",
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          child: Icon(Icons.save),
          onPressed: () {
            if (_editedAppointment.name != null &&
                _editedAppointment.name.isNotEmpty) {
              Navigator.pop(context, _editedAppointment);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                focusNode: _nameFocus,
                keyboardType: TextInputType.name,
                controller: _nameController,
                decoration: InputDecoration(labelText: "Título"),
                onChanged: (text) {
                  _edited = true;
                  setState(() {
                    _editedAppointment.name = text;
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.name,
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Descrição"),
                onChanged: (text) {
                  _edited = true;
                  setState(() {
                    _editedAppointment.description = text;
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.name,
                controller: _placeController,
                decoration: InputDecoration(labelText: "Local"),
                onChanged: (text) {
                  _edited = true;
                  setState(() {
                    _editedAppointment.place = text;
                  });
                },
              ),
              Row(
                children: [
                  Text("Data:"),
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      final getDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2022),
                        locale: Localizations.localeOf(context),
                      );
                      // dateText = DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                      //     .format(getDate)
                      //     .toString();
                      date =
                          DateFormat('dd/MM/yyyy').format(getDate).toString();
                      print(date);
                      _editedAppointment.date = date;
                    },
                  ),
                  // Text(date != null ? date : "Selecione a data.."),
                  // Text(!_editedAppointment.date.isEmpty

                  //     ? DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                  //         .format(DateTime.parse(_editedAppointment.date))
                  //         .toString()
                  //     : dateText),
                  if (widget.appointment != null)
                    Text(_editedAppointment.date)
                  else if (_editedAppointment.date != null)
                    Text(date)
                  else
                    Text("Selecione uma data"),
                ],
              ),
              TextField(
                keyboardType: TextInputType.datetime,
                controller: _timeController,
                decoration: InputDecoration(labelText: "Hora"),
                onChanged: (text) {
                  _edited = true;
                  setState(() {
                    _editedAppointment.time = text;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_edited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.cyan,
              buttonPadding: EdgeInsets.all(10),
              title: Text(
                "Descartar Alterações",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Text(
                "Se sair, as alterações serão perdidas",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                FlatButton(
                  minWidth: 100,
                  child: Icon(
                    Icons.check_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  minWidth: 100,
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(true);
    }
    Navigator.pop(context);
    return Future.value(true);
  }
}
