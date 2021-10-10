import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:last_efm/data/model/artist.dart';
import 'package:last_efm/data/repositories/search_repository.dart';

part 'search_artists_state.dart';

class SearchArtistsCubit extends Cubit<SearchArtistsState> {
  final SearchRepository repository;

  SearchArtistsCubit({required this.repository}) : super(SearchArtistsState());

  Future<void> fetchResultsFromSearch(
      {required String query, int? page}) async {
    getSearchedArtistsName(query);
    try {
      final result =
          await repository.getSearchResults(query, state.currentPage);
      emit(state.copyWith(
          status: SearchArtistsStatus.loaded,
          listOfArtists: state.listOfArtists + result.artists,
          currentPage: state.currentPage + 1));
    } catch (e) {
      emit(ErrorState(e));
    }
  }

  void onPopResetStateToLoaded() {
    emit(state.copyWith(status: SearchArtistsStatus.loaded));
  }

  void searchFieldCleared() {
    emit(state.copyWith(listOfArtists: []));
  }

  void artistSelected(String artistName) {
    final artist = artistName;
    emit(state.copyWith(
        artistName: artist, status: SearchArtistsStatus.artistSelected));
  }

  void getSearchedArtistsName(String query) {
    final artistName = query;
    emit(state.copyWith(searchedItem: artistName));
  }
}
