enum SearchRequestError { artistNotFound }

class SearchException implements Exception {
  final SearchRequestError error;
  SearchException({
    required this.error,
  });
}
