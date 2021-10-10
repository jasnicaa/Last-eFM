import 'package:equatable/equatable.dart';

class Pager extends Equatable {
  final String startIndex;
  final String itemsPerPage;

  const Pager({
    this.startIndex = "0",
    this.itemsPerPage = "30",
  });

  Map<String, dynamic> toJSON() {
    return {
      "opensearch:startIndex": startIndex,
      "opensearch:itemsPerPage": itemsPerPage
    };
  }

  factory Pager.fromJSON(dynamic parsedJSON) {
    return Pager(
      startIndex: parsedJSON['"opensearch:startIndex"'],
      itemsPerPage: parsedJSON["opensearch:itemsPerPage"],
    );
  }

  @override
  List<Object?> get props => [startIndex, itemsPerPage];
}
