import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_cubit/database/database_helper.dart';
import 'package:notes_cubit/models/notes_model.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  DbHelper dbHelper;
  NotesCubit({required this.dbHelper}) : super(NotesInitial());

  addNotes(NotesModel notesModel) async {
    emit(NotesLoading());
    await dbHelper.addNotes(notesModel);
    var notes = await dbHelper.showAllNotes();
    emit(NotesLoaded(notesModel: notes));
  }

  showAllNotes() async {
    emit(NotesLoading());
    var notes = await dbHelper.showAllNotes();
    emit(NotesLoaded(notesModel: notes));
  }

  updateNotes(NotesModel notesModel) async {
    emit(NotesLoading());
    await dbHelper.updateNotes(notesModel);
    var notes = await dbHelper.showAllNotes();
    emit(NotesLoaded(notesModel: notes));
  }

  deleteNotes(int id) async {
    emit(NotesLoading());
    await dbHelper.deleteNotes(id);
    var notes = await dbHelper.showAllNotes();
    emit(NotesLoaded(notesModel: notes));
  }
}
