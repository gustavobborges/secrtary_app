import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String appointmentTable = "Appointment";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String descriptionColumn = "descriptionColumn";
final String placeColumn = "placeColumn";
final String dateColumn = "dateColumn";
final String timeColumn = "timeColumn";

class AppointmentUtils {
  static final AppointmentUtils _instance = AppointmentUtils.internal();
  factory AppointmentUtils() => _instance;
  AppointmentUtils.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "secretary.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute(
          "CREATE TABLE $appointmentTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $descriptionColumn TEXT, $placeColumn TEXT, $dateColumn TEXT, $timeColumn TEXT)");
    });
  }

  Future<Appointment> save(Appointment appointment) async {
    Database _dbSecretary = await db;
    appointment.id =
        await _dbSecretary.insert(appointmentTable, appointment.toMap());
    return appointment;
  }

  Future<Appointment> get(int id) async {
    Database _dbSecretary = await db;
    List<Map> maps = await _dbSecretary.query(
      appointmentTable,
      columns: [
        idColumn,
        nameColumn,
        descriptionColumn,
        placeColumn,
        dateColumn,
        timeColumn
      ],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Appointment.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    Database _dbSecretary = await db;
    return await _dbSecretary.delete(
      appointmentTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Appointment appointment) async {
    Database _dbSecretary = await db;
    return _dbSecretary.update(appointmentTable, appointment.toMap(),
        where: "$idColumn = ?", whereArgs: [appointment.id]);
  }

  Future<List<Appointment>> getAll() async {
    Database _dbSecretary = await db;
    List listMap =
        await _dbSecretary.rawQuery("SELECT * FROM $appointmentTable");
    List<Appointment> listAppointment = [];
    for (Map map in listMap) {
      listAppointment.add(Appointment.fromMap(map));
    }
    return listAppointment;
  }
}

class Appointment {
  int id;
  String name;
  String description;
  String place;
  String date;
  String time;

  Appointment();

  Appointment.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    description = map[descriptionColumn];
    place = map[placeColumn];
    date = map[dateColumn];
    time = map[timeColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      nameColumn: name,
      descriptionColumn: description,
      placeColumn: place,
      dateColumn: date,
      timeColumn: time
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
