import 'package:equatable/equatable.dart';
import 'package:last_efm/data/model/artist.dart';

class SearchResults extends Equatable {
  final List<Artist> artists;

  const SearchResults({required this.artists});

  Map<String, dynamic> toJSON() {
    return {"artist": artists};
  }

  factory SearchResults.fromJSON(dynamic parsedJSON) {
    // first we need to map through JSON file
    // in order to crete list of Artist objects

    final artistsList = parsedJSON['artist'] as List;
    final List<Artist> artists =
        artistsList.map((e) => Artist.fromJSON(e)).toList();

    return SearchResults(
      artists: artists,
    );
  }
  @override
  List<Object?> get props => [artists];
}
