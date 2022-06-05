class CompanyModel {
  String? description;
  String? headquarters;
  String? homepage;
  int? id;
  String? logoPath;
  String? name;
  String? originCountry;
  Object? parentCompany;

  CompanyModel(
      {this.description,
        this.headquarters,
        this.homepage,
        this.id,
        this.logoPath,
        this.name,
        this.originCountry,
        this.parentCompany});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    headquarters = json['headquarters'];
    homepage = json['homepage'];
    id = json['id'];
    logoPath = json['logo_path'];
    name = json['name'];
    originCountry = json['origin_country'];
    parentCompany = json['parent_company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['headquarters'] = this.headquarters;
    data['homepage'] = this.homepage;
    data['id'] = this.id;
    data['logo_path'] = this.logoPath;
    data['name'] = this.name;
    data['origin_country'] = this.originCountry;
    data['parent_company'] = this.parentCompany;
    return data;
  }
}