import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_cubit/cubit/notes_cubit.dart';
import 'package:notes_cubit/cubit/theme_cubit.dart';
import 'package:notes_cubit/models/notes_model.dart';
import 'package:notes_cubit/screens/add_or_update_notes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().showAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          Switch(
            value: context.watch<ThemeCubit>().state.isDark,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          final notesCubit = BlocProvider.of<NotesCubit>(context);
          if (state is NotesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NotesLoaded) {
            return AlignedGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: state.notesModel!.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.amberAccent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        state.notesModel![index].title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        state.notesModel![index].descrpition,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () async {
                        NotesModel? updatedNote = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddOrUpdateNotes(
                              notesModel: state.notesModel![index],
                            ),
                          ),
                        );

                        if (updatedNote != null) {
                          // context.read<NotesCubit>().updateNotes(updatedNote);
                          notesCubit.updateNotes(updatedNote);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is NotesError) {
            return const Center(
              child: Text('Error'),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddOrUpdateNotes(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
