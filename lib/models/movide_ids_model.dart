class MovieIDSModel {
  String? imdbId;
  String? facebookId;
  String? instagramId;
  String? twitterId;
  int? id;

  MovieIDSModel(
      {this.imdbId,
        this.facebookId,
        this.instagramId,
        this.twitterId,
        this.id});

  MovieIDSModel.fromJson(Map<String, dynamic> json) {
    imdbId = json['imdb_id'];
    facebookId = json['facebook_id'];
    instagramId = json['instagram_id'];
    twitterId = json['twitter_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imdb_id'] = this.imdbId;
    data['facebook_id'] = this.facebookId;
    data['instagram_id'] = this.instagramId;
    data['twitter_id'] = this.twitterId;
    data['id'] = this.id;
    return data;
  }
}