import 'package:last_efm/data/model/artist.dart';
import 'package:last_efm/data/model/search_results.dart';

abstract class SearchInterface {
  Future<List<Artist>> getArtistList();
  Future<SearchResults> getSearchResults(String query, int page);
  Future<Artist> getArtistDetails(String artistName);
}
