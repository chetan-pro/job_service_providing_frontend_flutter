import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';

class ManagerBusinessDetailsModel {
  int? id;
  int? userId;
  String? currentBussiness;
  String? bussinessType;
  String? bussinessName;
  String? houseName;
  String? streetNoName;
  String? ward;
  String? municipality;
  int? cityId;
  int? stateId;
  int? pincode;
  int? bussinessYears;
  String? dimensions;
  dynamic bussinessImg;
  String? infrastructureAvailable;
  int? currentIncomePa;
  int? noCustomers;
  String? popular;
  int? customersServed;
  String? ref1Name;
  String? ref1Occupation;
  String? ref1Address;
  String? ref1Mobile;
  String? ref2Name;
  String? ref2Occupation;
  String? ref2Address;
  String? ref2Mobile;
  String? nameTowns;
  int? noTowns;
  String? achievement1;
  String? achievement2;
  String? achievement3;
  String? createdAt;
  String? updatedAt;
  States? state;
  City? city;

  ManagerBusinessDetailsModel(
      {this.id,
      this.userId,
      this.currentBussiness,
      this.bussinessType,
      this.bussinessName,
      this.houseName,
      this.streetNoName,
      this.ward,
      this.municipality,
      this.cityId,
      this.stateId,
      this.pincode,
      this.bussinessYears,
      this.dimensions,
      this.bussinessImg,
      this.infrastructureAvailable,
      this.currentIncomePa,
      this.noCustomers,
      this.popular,
      this.customersServed,
      this.ref1Name,
      this.ref1Occupation,
      this.ref1Address,
      this.ref1Mobile,
      this.ref2Name,
      this.ref2Occupation,
      this.ref2Address,
      this.ref2Mobile,
      this.nameTowns,
      this.noTowns,
      this.achievement1,
      this.achievement2,
      this.achievement3,
      this.createdAt,
      this.state,
      this.city,
      this.updatedAt});

  ManagerBusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    currentBussiness = json['current_bussiness'];
    bussinessType = json['bussiness_type'];
    bussinessName = json['bussiness_name'];
    houseName = json['house_name'];
    streetNoName = json['street_no_name'];
    ward = json['ward'];
    municipality = json['municipality'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    pincode = json['pincode'];
    bussinessYears = json['bussiness_years'];
    dimensions = json['dimensions'];
    bussinessImg = json['bussiness_img'];
    infrastructureAvailable = json['infrastructure_available'];
    currentIncomePa = int.parse((json['current_income_pa'] ?? 0).toString());
    noCustomers = json['no_customers'];
    popular = json['popular'];
    customersServed = json['customers_served'];
    ref1Name = json['ref1_name'];
    ref1Occupation = json['ref1_occupation'];
    ref1Address = json['ref1_address'];
    ref1Mobile = json['ref1_mobile'];
    ref2Name = json['ref2_name'];
    ref2Occupation = json['ref2_occupation'];
    ref2Address = json['ref2_address'];
    ref2Mobile = json['ref2_mobile'];
    nameTowns = json['name_towns'];
    noTowns = json['no_towns'];
    achievement1 = json['achievement1'];
    achievement2 = json['achievement2'];
    achievement3 = json['achievement3'];
    state = json['state'] != null ? States.fromJson(json['state']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['current_bussiness'] = currentBussiness;
    data['bussiness_type'] = bussinessType;
    data['bussiness_name'] = bussinessName;
    data['house_name'] = houseName;
    data['street_no_name'] = streetNoName;
    data['ward'] = ward;
    data['municipality'] = municipality;
    data['city_id'] = cityId;
    data['state_id'] = stateId;
    data['pincode'] = pincode;
    data['bussiness_years'] = bussinessYears;
    data['dimensions'] = dimensions;
    data['bussiness_img'] = bussinessImg;
    data['infrastructure_available'] = infrastructureAvailable;
    data['current_income_pa'] = currentIncomePa;
    data['no_customers'] = noCustomers;
    data['popular'] = popular;
    data['customers_served'] = customersServed;
    data['ref1_name'] = ref1Name;
    data['ref1_occupation'] = ref1Occupation;
    data['ref1_address'] = ref1Address;
    data['ref1_mobile'] = ref1Mobile;
    data['ref2_name'] = ref2Name;
    data['ref2_occupation'] = ref2Occupation;
    data['ref2_address'] = ref2Address;
    data['ref2_mobile'] = ref2Mobile;
    data['name_towns'] = nameTowns;
    data['no_towns'] = noTowns;
    data['achievement1'] = achievement1;
    data['achievement2'] = achievement2;
    data['achievement3'] = achievement3;
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
