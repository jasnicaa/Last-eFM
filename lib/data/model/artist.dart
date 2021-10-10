import 'package:equatable/equatable.dart';

class Artist extends Equatable {
  final String? name;
  final String? listeners;
  final String? url;
  final ArtistStatistics? stats;
  final ArtistBio? bio;

  const Artist(
      {required this.name,
      required this.listeners,
      required this.url,
      this.stats,
      this.bio});

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "listeners": listeners,
      "url": url,
      "stats": stats,
      "bio": bio
    };
  }

  factory Artist.fromJSON(dynamic parsedJSON) {
    return Artist(
        name: parsedJSON['name'],
        listeners: parsedJSON['listeners'],
        url: parsedJSON['url'],
        stats: parsedJSON['stats'] == null
            ? null
            : ArtistStatistics.fromJSON(parsedJSON['stats']),
        bio: parsedJSON['bio'] == null
            ? null
            : ArtistBio.fromJSON(parsedJSON['bio']));
  }

  @override
  List<Object?> get props => [name, listeners, url, stats, bio];
}

class ArtistStatistics extends Equatable {
  final String? listeners;
  final String? playCount;
  const ArtistStatistics({
    this.listeners,
    this.playCount,
  });

  Map<String, dynamic> toJSON() {
    return {"listeners": listeners, "playcount": playCount};
  }

  factory ArtistStatistics.fromJSON(dynamic parsedJSON) {
    return ArtistStatistics(
      listeners: parsedJSON['listeners'] as String?,
      playCount: parsedJSON['playcount'] as String?,
    );
  }

  @override
  List<Object?> get props => [listeners, playCount];
}

class ArtistBio extends Equatable {
  final String? summary;
  final String? url;

  const ArtistBio({this.summary, this.url});

  factory ArtistBio.fromJSON(dynamic parsedJSON) {
    return ArtistBio(
      summary: parsedJSON['summary'] as String?,
      url: parsedJSON['links']["link"]["href"] as String?,
    );
  }

  @override
  List<Object?> get props => [summary, url];
}
