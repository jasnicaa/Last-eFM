import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:last_efm/bloc/search/cubit/search_artists_cubit.dart';
import 'package:last_efm/data/model/artist.dart';
import 'package:last_efm/data/repositories/search_repository.dart';

part 'artist_details_state.dart';

class ArtistDetailsCubit extends Cubit<ArtistDetailsState> {
  final SearchRepository repository;
  final SearchArtistsCubit searchArtistsCubit;

  ArtistDetailsCubit(
      {required this.repository, required this.searchArtistsCubit})
      : super(const ArtistDetailsState());

  Future<void> getArtistDetails() async {
    final artistName = searchArtistsCubit.state.artistName;
    if (artistName != null) {
      emit(state.copyWith(status: ArtistDetailsStatus.loading));
      try {
        final selectedArtist = await repository.getArtistDetails(artistName);
        emit(state.copyWith(
            status: ArtistDetailsStatus.loaded, artist: selectedArtist));
      } catch (e) {
        emit(state.copyWith(status: ArtistDetailsStatus.failed));
      }
    } else {
      emit(state.copyWith(status: ArtistDetailsStatus.artistNotFound));
    }
  }
}
