part of 'notes_cubit.dart';

@immutable
sealed class NotesState {}

final class NotesInitial extends NotesState {}

final class NotesLoading extends NotesState {}

final class NotesLoaded extends NotesState {
  final List<NotesModel>? notesModel;
  final int? id;
  NotesLoaded({this.notesModel, this.id});
}

final class NotesError extends NotesState {
  final String error;
  NotesError({required this.error});
}
