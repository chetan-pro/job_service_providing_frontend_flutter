import 'package:hindustan_job/candidate/model/serviceProviderModal/alldata_get_modal.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/catogory_modal.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';

class ServicesModel {
  int? count;
  List<Services>? services;

  ServicesModel({this.count, this.services});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      services = <Services>[];
      json['rows'].forEach((v) {
        if (v['service'] != null) {
          v['service']['user_status'] = v['user_status'];
          v['service']['service_request_id'] = v['id'];
          v['service']['service_provider_status'] =
              v['service_provider_status'];
          v['service']['request_date'] = v['request_date'];
          v['service']['User'] = v['User'];
          v['service']['createdAt'] = v['createdAt'];
          services!.add(Services.fromJson(v['service']));
        } else if (v['serviceRequest'] != null) {
          v['user_status'] = v['serviceRequest']['user_status'];
          v['service_request_id'] = v['serviceRequest']['id'];
          v['service_provider_status'] =
              v['serviceRequest']['service_provider_status'];
          v['request_date'] = v['serviceRequest']['request_date'];
          services!.add(Services.fromJson(v['service']));
        } else {
          services!.add(Services.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (services != null) {
      data['rows'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? id;
  int? serviceProviderId;
  String? serviceName;
  String? userStatus;
  String? serviceProviderStatus;
  String? requestDate;
  int? serviceCharge;
  String? createdAt;
  String? updatedAt;
  UserData? user;
  int? serviceRequestId;
  List<ServiceDays>? serviceDays;
  List<CategoryModel>? serviceCategories;
  List<ServiceImages>? serviceImages;
  int? mean;

  Services(
      {this.id,
      this.serviceProviderId,
      this.serviceName,
      this.serviceRequestId,
      this.userStatus,
      this.requestDate,
      this.serviceProviderStatus,
      this.serviceCharge,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.serviceDays,
      this.serviceCategories,
      this.mean,
      this.serviceImages});

  Services.fromJson(Map<String, dynamic> json) {
    if (json['serviceRequestDataSeeker'] != null) {
      json['user_status'] = json['serviceRequestDataSeeker']['user_status'];
      json['service_request_id'] = json['serviceRequestDataSeeker']['id'];
      json['service_provider_status'] =
          json['serviceRequestDataSeeker']['service_provider_status'];
      json['request_date'] = json['serviceRequestDataSeeker']['request_date'];
    }

    id = json['id'];
    serviceProviderId = json['service_provider_id'];
    serviceName = json['service_name'];
    serviceRequestId = json['service_request_id'];
    userStatus = json['user_status'];
    requestDate = json['request_date'];
    serviceProviderStatus = json['service_provider_status'];
    serviceCharge = json['service_charge'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['User'] != null ? UserData.fromJson(json['User']) : null;
    if (json['serviceDays'] != null) {
      serviceDays = <ServiceDays>[];
      json['serviceDays'].forEach((v) {
        serviceDays!.add(ServiceDays.fromJson(v));
      });
    }
    if (json['ServiceCategories'] != null) {
      serviceCategories = <CategoryModel>[];
      json['ServiceCategories'].forEach((v) {
        serviceCategories!.add(CategoryModel.fromJson(v));
      });
    }
    if (json['ServiceImages'] != null) {
      serviceImages = <ServiceImages>[];
      json['ServiceImages'].forEach((v) {
        serviceImages!.add(ServiceImages.fromJson(v));
      });
    }
    mean = json['mean'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_provider_id'] = serviceProviderId;
    data['service_name'] = serviceName;
    data['service_request_id'] = serviceRequestId;
    data['user_status'] = userStatus;
    data['request_date'] = requestDate;
    data['service_provider_status'] = serviceProviderStatus;
    data['service_charge'] = serviceCharge;
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
      data['ServiceImages'] = serviceImages!.map((v) => v.toJson()).toList();
    }
    data['mean'] = int.parse(mean.toString());
    return data;
  }
}
