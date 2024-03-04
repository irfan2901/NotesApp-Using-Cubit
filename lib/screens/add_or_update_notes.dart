import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_cubit/cubit/notes_cubit.dart';
import 'package:notes_cubit/models/notes_model.dart';
import 'package:notes_cubit/utils/custom_widgets.dart';

class AddOrUpdateNotes extends StatefulWidget {
  final NotesModel? notesModel;
  const AddOrUpdateNotes({super.key, this.notesModel});

  @override
  State<AddOrUpdateNotes> createState() => _AddOrUpdateNotesState();
}

class _AddOrUpdateNotesState extends State<AddOrUpdateNotes> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController =
        TextEditingController(text: widget.notesModel?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.notesModel?.descrpition ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await _saveNote();
            },
            icon: const Icon(Icons.save),
          ),
          if (widget.notesModel != null)
            IconButton(
              onPressed: () async {
                await _deleteNote();
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomWidgets.customTextField(titleController, 'Title'),
            CustomWidgets.customTextField(descriptionController, 'Description'),
          ],
        ),
      ),
    );
  }

  _saveNote() async {
    if (widget.notesModel != null) {
      await context.read<NotesCubit>().updateNotes(
            NotesModel(
              id: widget.notesModel!.id,
              title: titleController.text,
              descrpition: descriptionController.text,
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note Updated successfully!'),
        ),
      );
    } else {
      await context.read<NotesCubit>().addNotes(
            NotesModel(
              title: titleController.text,
              descrpition: descriptionController.text,
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note added successfully!'),
        ),
      );
    }
    Navigator.pop(context);
  }

  _deleteNote() async {
    await context.read<NotesCubit>().deleteNotes(widget.notesModel!.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted successfully!'),
      ),
    );
    Navigator.pop(context);
  }
}
