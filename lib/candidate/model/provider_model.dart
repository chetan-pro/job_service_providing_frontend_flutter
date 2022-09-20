import 'package:hindustan_job/candidate/model/branch_model.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/mybranch.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';

class ServiceProviderModel {
  int? count;
  List<ServiceProvider>? serviceProvider;

  ServiceProviderModel({this.count, this.serviceProvider});

  ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      serviceProvider = <ServiceProvider>[];
      json['rows'].forEach((v) {
        serviceProvider!.add(ServiceProvider.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (serviceProvider != null) {
      data['rows'] = serviceProvider!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceProvider {
  int? id;
  String? name;
  String? email;
  String? image;
  String? mobile;
  int? stateId;
  int? cityId;
  City? city;
  City? state;
  List<Services>? services;
  List<Branch>? serviceProviderBranches;

  ServiceProvider(
      {this.id,
      this.name,
      this.email,
      this.image,
      this.mobile,
      this.stateId,
      this.cityId,
      this.city,
      this.state,
      this.services,
      this.serviceProviderBranches});

  ServiceProvider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    mobile = json['mobile'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    state = json['state'] != null ? City.fromJson(json['state']) : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    // if (json['serviceProviderBranches'] != null) {
    //   serviceProviderBranches = <Branch>[];
    //   json['serviceProviderBranches'].forEach((v) {
    //     serviceProviderBranches!.add(Branch.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['mobile'] = mobile;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (serviceProviderBranches != null) {
      data['serviceProviderBranches'] =
          serviceProviderBranches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  int? id;
  String? name;

  City({this.id, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
