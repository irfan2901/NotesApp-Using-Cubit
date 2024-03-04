import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_cubit/cubit/notes_cubit.dart';
import 'package:notes_cubit/cubit/theme_cubit.dart';
import 'package:notes_cubit/database/database_helper.dart';
import 'package:notes_cubit/screens/home_page.dart';
import 'package:notes_cubit/theme/theme.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotesCubit(dbHelper: DbHelper.dbHelper),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeLoadedState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: state.isDark ? darkTheme : lightTheme,
          home: const HomePage(),
        );
      },
    );
  }
}
