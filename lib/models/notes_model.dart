import 'package:notes_cubit/database/database_helper.dart';

class NotesModel {
  final int? id;
  final String title;
  final String descrpition;

  NotesModel({this.id, required this.title, required this.descrpition});

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map[DbHelper.columnId],
      title: map[DbHelper.columnTitle],
      descrpition: map[DbHelper.columnDescription],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DbHelper.columnId: id,
      DbHelper.columnTitle: title,
      DbHelper.columnDescription: descrpition
    };
  }
}
