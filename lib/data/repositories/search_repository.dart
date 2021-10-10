import 'package:last_efm/data/exceptions/search_exception.dart';
import 'package:last_efm/data/interface/search_interface.dart';
import 'package:last_efm/data/model/artist.dart';
import 'package:http/http.dart' as http;
import 'package:last_efm/data/model/search_results.dart';
import 'dart:async';
import 'dart:convert';

class SearchRepository extends SearchInterface {
  // in live project all url's are held in separate class
  // also query is encoded

  String getBaseUrl(String queryType) =>
      'https://ws.audioscrobbler.com/2.0/?method=artist.$queryType&artist=';

  final String apiKeyAndJsonFormat =
      "c632e39652eaa0b6abbd284e6ba3fcb3&format=json";

  @override
  Future<List<Artist>> getArtistList() {
    throw UnimplementedError();
  }

  @override
  Future<SearchResults> getSearchResults(String query, int page) async {
    final url = getBaseUrl('search');
    try {
      final response = await http
          .get(Uri.parse("$url$query&api_key=$apiKeyAndJsonFormat&page=$page"));
      final results = json.decode(response.body);

      final result =
          SearchResults.fromJSON(results['results']['artistmatches']);

      return result;
    } on SearchException catch (_) {
      throw SearchException(error: SearchRequestError.artistNotFound);
    }
  }

  @override
  Future<Artist> getArtistDetails(String artistName) async {
    final url = getBaseUrl('getinfo');

    try {
      final response = await http
          .get(Uri.parse("$url$artistName&api_key=$apiKeyAndJsonFormat"));
      final results = json.decode(response.body);

      final result = Artist.fromJSON(results['artist']);

      if (results['error'] != null) {
        throw SearchException(error: SearchRequestError.artistNotFound);
      }

      return result;
    } on SearchException catch (_) {
      throw SearchException(error: SearchRequestError.artistNotFound);
    }
  }
}
