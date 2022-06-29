class GetCountry {
  Data? data;

  GetCountry({this.data});

  GetCountry.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Countryx? country;

  Data({this.country});

  Data.fromJson(Map<String, dynamic> json) {
    country =
    json['country'] != null ? Countryx.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (country != null) {
      data['country'] = country!.toJson();
    }
    return data;
  }
}

class Countryx {
  String? name;
  String? capital;
  String? code;
  String? native;
  String? currency;
  String? phone;
  String? emoji;
  List<Languages>? languages;

  Countryx(
      {this.name,
        this.capital,
        this.code,
        this.native,
        this.currency,
        this.phone,
        this.emoji,
        this.languages});

  Countryx.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    capital = json['capital'];
    code = json['code'];
    native = json['native'];
    currency = json['currency'];
    phone = json['phone'];
    emoji = json['emoji'];
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['capital'] = capital;
    data['code'] = code;
    data['native'] = native;
    data['currency'] = currency;
    data['phone'] = phone;
    data['emoji'] = emoji;
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Languages {
  String? code;
  String? name;

  Languages({this.code, this.name});

  Languages.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}