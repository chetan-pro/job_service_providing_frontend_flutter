class ExperienceFilterModel {
  List<ExperienceFilter>? experienceFilter;

  ExperienceFilterModel({this.experienceFilter});

  ExperienceFilterModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      experienceFilter = <ExperienceFilter>[];
      json['rows'].forEach((v) {
        experienceFilter!.add(ExperienceFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (experienceFilter != null) {
      data['rows'] = experienceFilter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExperienceFilter {
  int? from;
  int? to;
  String? name;

  ExperienceFilter({this.to, this.from, this.name});

  ExperienceFilter.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    name = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    data['value'] = name;
    return data;
  }
}
