class TvShowModel {
  String? posterPath;
  int? id;
  String? backdropPath;
  String? voteAverage;
  String? overview;
  String? firstAirDate;
  List<String>? originCountry;
  List<int>? genreIds;
  String? originalLanguage;
  String? voteCount;
  String? name;
  String? originalName;


  TvShowModel(
      {this.posterPath,
        this.id,
        this.backdropPath,
        this.voteAverage,
        this.overview,
        this.firstAirDate,
        this.originCountry,
        this.genreIds,
        this.originalLanguage,
        this.voteCount,
        this.name,
        this.originalName});

  TvShowModel.fromJson(Map<String, dynamic> json) {
    posterPath = json['poster_path'];
    id = json['id'];
    backdropPath = json['backdrop_path'];
    voteAverage = json['vote_average'].toString();
    overview = json['overview'];
    firstAirDate = json['first_air_date'];
    originCountry = json['origin_country'].cast<String>();
    genreIds = json['genre_ids'].cast<int>();
    originalLanguage = json['original_language'];
    voteCount = json['vote_count'].toString();
    name = json['name'];
    originalName = json['original_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poster_path'] = this.posterPath;
    data['id'] = this.id;
    data['backdrop_path'] = this.backdropPath;
    data['vote_average'] = this.voteAverage;
    data['overview'] = this.overview;
    data['first_air_date'] = this.firstAirDate;
    data['origin_country'] = this.originCountry;
    data['genre_ids'] = this.genreIds;
    data['original_language'] = this.originalLanguage;
    data['vote_count'] = this.voteCount;
    data['name'] = this.name;
    data['original_name'] = this.originalName;
    return data;
  }
}