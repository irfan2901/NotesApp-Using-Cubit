import 'dart:io';
import 'package:notes_cubit/models/notes_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper dbHelper = DbHelper._();
  Database? _database;

  static const notesTable = 'notes_table';
  static const columnId = 'notes_id';
  static const columnTitle = 'notes_title';
  static const columnDescription = 'notes_description';

  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDatabase();
    }
  }

  static Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, 'notesDb.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE $notesTable ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT, $columnDescription TEXT)");
      },
    );
  }

  Future<void> addNotes(NotesModel notesModel) async {
    var db = await getDatabase();
    await db.insert(notesTable, notesModel.toMap());
  }

  Future<List<NotesModel>> showAllNotes() async {
    var db = await getDatabase();
    List<NotesModel> notesList = [];
    List<Map<String, dynamic>> notes = await db.query(notesTable);

    for (Map<String, dynamic> note in notes) {
      NotesModel notesModel = NotesModel.fromMap(note);
      notesList.add(notesModel);
    }
    return notesList;
  }

  Future<void> updateNotes(NotesModel notesModel) async {
    var db = await getDatabase();
    await db.update(notesTable, notesModel.toMap(),
        where: "$columnId = ${notesModel.id}");
  }

  Future<void> deleteNotes(int id) async {
    var db = await getDatabase();
    await db.delete(notesTable, where: "$columnId = $id");
  }
}
