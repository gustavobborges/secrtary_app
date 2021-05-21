import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:secretary/utils/appointment.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppointmentPage extends StatefulWidget {
  final AppointmentModel appointment;
  AppointmentPage({this.appointment});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  AppointmentModel _editedAppointment;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  bool _edited = false;
  final _nameFocus = FocusNode();
  final maskTime =
      MaskTextInputFormatter(mask: "##:##", filter: {"#": RegExp(r'[0-9]')});

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
      _dateTimeController.text = _editedAppointment.time;
    } else {
      _editedAppointment = AppointmentModel();
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
                _editedAppointment.date != null &&
                _editedAppointment.time != null &&
                _editedAppointment.name.isNotEmpty &&
                _editedAppointment.date.isNotEmpty &&
                _editedAppointment.time.isNotEmpty) {
              _editedAppointment.dateTime =
                  _editedAppointment.date + ' ' + _editedAppointment.time;
              print(_editedAppointment.dateTime);
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
                    // if (_editedAppointment.description != null) {}
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
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            "Data:",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: Colors.black87),
                          ),
                          Row(
                            children: [
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
                                  date = DateFormat('dd/MM/yyyy')
                                      .format(getDate)
                                      .toString();
                                  print(date);
                                  _editedAppointment.date = date;
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (widget.appointment != null)
                                Text(
                                  _editedAppointment.date,
                                )
                              else if (_editedAppointment.date != null)
                                Text(date)
                              else
                                Text("Selecione uma data"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 50),
                  // ),
                ],
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [maskTime],
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
