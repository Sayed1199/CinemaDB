class PersonIDsModel {
  String? imdbId;
  String? facebookId;
  String? freebaseMid;
  String? freebaseId;
  int? tvrageId;
  String? twitterId;
  int? id;

  PersonIDsModel(
      {this.imdbId,
        this.facebookId,
        this.freebaseMid,
        this.freebaseId,
        this.tvrageId,
        this.twitterId,
        this.id});

  PersonIDsModel.fromJson(Map<String, dynamic> json) {
    imdbId = json['imdb_id'];
    facebookId = json['facebook_id'];
    freebaseMid = json['freebase_mid'];
    freebaseId = json['freebase_id'];
    tvrageId = json['tvrage_id'];
    twitterId = json['twitter_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imdb_id'] = this.imdbId;
    data['facebook_id'] = this.facebookId;
    data['freebase_mid'] = this.freebaseMid;
    data['freebase_id'] = this.freebaseId;
    data['tvrage_id'] = this.tvrageId;
    data['twitter_id'] = this.twitterId;
    data['id'] = this.id;
    return data;
  }
}