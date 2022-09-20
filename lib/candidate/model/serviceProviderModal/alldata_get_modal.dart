class AllData {
  int? count;
  List<AllServiceFetch>? rows;

  AllData({this.count, this.rows});

  AllData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <AllServiceFetch>[];
      json['rows'].forEach((v) {
        rows!.add(AllServiceFetch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (rows != null) {
      data['rows'] = rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllServiceFetch {
  int? id;
  int? serviceProviderId;
  String? serviceName;
  int? serviceCharge;
  String? serviceStatus;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<ServiceDays>? serviceDays;
  List<ServiceCategories>? serviceCategories;
  List<ServiceImages>? serviceImages;

  AllServiceFetch(
      {this.id,
      this.serviceProviderId,
      this.serviceName,
      this.serviceCharge,
      this.serviceStatus,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.serviceDays,
      this.serviceCategories,
      this.serviceImages});

  AllServiceFetch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceProviderId = json['service_provider_id'];
    serviceName = json['service_name'];
    serviceCharge = json['service_charge'];
    serviceStatus = json['service_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    if (json['serviceDays'] != null) {
      serviceDays = <ServiceDays>[];
      json['serviceDays'].forEach((v) {
        serviceDays!.add(ServiceDays.fromJson(v));
      });
    }
    if (json['ServiceCategories'] != null) {
      serviceCategories = <ServiceCategories>[];
      json['ServiceCategories'].forEach((v) {
        serviceCategories!.add(ServiceCategories.fromJson(v));
      });
    }
    if (json['ServiceImages'] != null) {
      serviceImages = <ServiceImages>[];
      json['ServiceImages'].forEach((v) {
        serviceImages!.add(ServiceImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_provider_id'] = serviceProviderId;
    data['service_name'] = serviceName;
    data['service_charge'] = serviceCharge;
    data['service_status'] = serviceStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    if (serviceDays != null) {
      data['serviceDays'] = serviceDays!.map((v) => v.toJson()).toList();
    }
    if (serviceCategories != null) {
      data['ServiceCategories'] =
          serviceCategories!.map((v) => v.toJson()).toList();
    }
    if (serviceImages != null) {
      data['ServiceImages'] =
          serviceImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  int? cityId;
  int? stateId;
  City? city;
  City? state;

  User({this.id, this.name, this.cityId, this.stateId, this.city, this.state});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    state = json['state'] != null ? City.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['city_id'] = cityId;
    data['state_id'] = stateId;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    return data;
  }
}

class City {
  String? name;

  City({this.name});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class ServiceDays {
  int? id;
  String? dayName;
  bool toogle = false;

  ServiceDays({this.id, this.dayName});

  ServiceDays.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayName = json['day_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['day_name'] = dayName;
    return data;
  }
}

class ServiceCategories {
  int? id;
  String? name;
  bool isSelected = false;

  ServiceCategories({this.id, this.name});

  ServiceCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = name;
    return data;
  }
}

class ServiceImages {
  int? id;
  String? image;

  ServiceImages({this.id, this.image});

  ServiceImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}
