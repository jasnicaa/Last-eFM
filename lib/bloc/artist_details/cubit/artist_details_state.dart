part of 'artist_details_cubit.dart';

enum ArtistDetailsStatus {
  loading,
  loaded,
  artistSelected,
  failed,
  artistNotFound
}

class ArtistDetailsState extends Equatable {
  const ArtistDetailsState({this.artist, this.status});

  final Artist? artist;
  final ArtistDetailsStatus? status;

  ArtistDetailsState copyWith({Artist? artist, ArtistDetailsStatus? status}) {
    return ArtistDetailsState(
      artist: artist ?? this.artist,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [artist, status];
}
