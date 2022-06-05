class ReleaseDatesModel {
  String? iso31661;
  List<ReleaseDates>? releaseDates;

  ReleaseDatesModel({this.iso31661, this.releaseDates});

  ReleaseDatesModel.fromJson(Map<String, dynamic> json) {
    iso31661 = json['iso_3166_1'];
    if (json['release_dates'] != null) {
      releaseDates = <ReleaseDates>[];
      json['release_dates'].forEach((v) {
        releaseDates!.add(new ReleaseDates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso_3166_1'] = this.iso31661;
    if (this.releaseDates != null) {
      data['release_dates'] =
          this.releaseDates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReleaseDates {
  String? certification;
  String? iso6391;
  String? releaseDate;
  int? type;
  String? note;

  ReleaseDates(
      {this.certification,
        this.iso6391,
        this.releaseDate,
        this.type,
        this.note});

  ReleaseDates.fromJson(Map<String, dynamic> json) {
    certification = json['certification'];
    iso6391 = json['iso_639_1'];
    releaseDate = json['release_date'];
    type = json['type'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['certification'] = this.certification;
    data['iso_639_1'] = this.iso6391;
    data['release_date'] = this.releaseDate;
    data['type'] = this.type;
    data['note'] = this.note;
    return data;
  }
}