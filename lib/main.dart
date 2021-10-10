import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:last_efm/bloc/artist_details/cubit/artist_details_cubit.dart';
import 'package:last_efm/bloc/search/cubit/search_artists_cubit.dart';
import 'package:last_efm/data/repositories/search_repository.dart';
import 'package:last_efm/presentation/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchArtistsCubit>(
          create: (context) => SearchArtistsCubit(
            repository: SearchRepository(),
          ),
        ),
        BlocProvider<ArtistDetailsCubit>(
            create: (context) => ArtistDetailsCubit(
                repository: SearchRepository(),
                searchArtistsCubit:
                    BlocProvider.of<SearchArtistsCubit>(context))),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.jetBrainsMonoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
