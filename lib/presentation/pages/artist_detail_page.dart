import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:last_efm/bloc/artist_details/cubit/artist_details_cubit.dart';

class ArtistDetailPage extends StatefulWidget {
  const ArtistDetailPage({Key? key}) : super(key: key);

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  @override
  void didChangeDependencies() {
    context.read<ArtistDetailsCubit>().getArtistDetails();
    super.didChangeDependencies();
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😢', style: TextStyle(fontSize: 30)),
            const Text('Your artist is not found',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, color: Colors.red)),
            const SizedBox(height: 20),
            SizedBox(
                height: 200,
                width: 200,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset('assets/music.jpg')))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<ArtistDetailsCubit, ArtistDetailsState>(
        builder: (context, state) {
          if (state.status == ArtistDetailsStatus.loading) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.teal));
          }

          if (state.status == ArtistDetailsStatus.loaded) {
            final int intListeners = int.parse(state.artist!.stats!.listeners!);
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset('assets/concert.jpg')),
                    Text(
                      state.artist!.name!.toUpperCase(),
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 50.0, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NumberFormat.decimalPattern().format(intListeners) +
                            " listeners",
                        style:
                            const TextStyle(fontSize: 20.0, color: Colors.teal),
                      ),
                      const SizedBox(height: 18),
                      GestureDetector(
                        child: const Text("More info",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)),
                        onTap: () async {
                          if (await canLaunch(state.artist!.url!)) {
                            await launch(state.artist!.url!);
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      Text(
                        state.artist!.bio!.summary!,
                        overflow: TextOverflow.clip,
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.teal),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return _buildErrorView();
          }
        },
      ),
    );
  }
}
