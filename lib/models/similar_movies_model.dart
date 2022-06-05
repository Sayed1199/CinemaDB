import 'package:cinema_db/models/movie_model.dart';

class SimilarMoviesModel {
  int? page;
  List<MovieModel>? results;
  int? totalPages;
  int? totalResults;

  SimilarMoviesModel(
      {this.page, this.results, this.totalPages, this.totalResults});

  SimilarMoviesModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      results = <MovieModel>[];
      json['results'].forEach((v) {
        results!.add(new MovieModel.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = this.totalPages;
    data['total_results'] = this.totalResults;
    return data;
  }
}
