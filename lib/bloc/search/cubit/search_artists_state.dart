part of 'search_artists_cubit.dart';

enum SearchArtistsStatus { loading, loaded, failure, artistSelected }

class SearchArtistsState extends Equatable {
  SearchArtistsState(
      {this.status,
      this.listOfArtists = const [],
      this.searchedItem,
      this.artistName,
      this.currentPage = 1,
      this.fetchingFeed = false});

  List<Artist> listOfArtists = [];
  final SearchArtistsStatus? status;
  final String? artistName;

  int currentPage;
  bool fetchingFeed;
  int? get nextPage => listOfArtists.isEmpty ? null : currentPage + 1;
  final String? searchedItem;

  SearchArtistsState copyWith(
      {List<Artist>? listOfArtists,
      SearchArtistsStatus? status,
      String? artistName,
      int? currentPage,
      String? searchedItem}) {
    return SearchArtistsState(
      listOfArtists: listOfArtists ?? this.listOfArtists,
      currentPage: currentPage ?? this.currentPage,
      artistName: artistName ?? this.artistName,
      status: status ?? this.status,
      searchedItem: searchedItem ?? this.searchedItem,
    );
  }

  @override
  List<Object?> get props =>
      [listOfArtists, status, searchedItem, currentPage, artistName];
}

class ErrorState extends SearchArtistsState {
  final dynamic message;

  ErrorState(this.message);
  @override
  List<Object> get props => [message];
}
