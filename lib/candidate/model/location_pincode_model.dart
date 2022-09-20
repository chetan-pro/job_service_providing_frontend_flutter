class PincodeLocationModel {
  String? message;
  String? status;
  List<PostOffice>? postOffice;

  PincodeLocationModel({this.message, this.status, this.postOffice});

  PincodeLocationModel.fromJson(Map<String, dynamic> json) {
    // message = json['Message'];
    // status = json['Status'];
    if (json['PostOffice'] != null) {
      postOffice = <PostOffice>[];
      json['PostOffice'].forEach((v) {
        postOffice!.add( PostOffice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Message'] = message;
    data['Status'] = status;
    if (postOffice != null) {
      data['PostOffice'] = postOffice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostOffice {
  String? name;
  String? description;
  String? branchType;
  String? deliveryStatus;
  String? taluk;
  String? circle;
  String? district;
  String? division;
  String? region;
  String? state;
  String? country;

  PostOffice(
      {this.name,
      this.description,
      this.branchType,
      this.deliveryStatus,
      this.taluk,
      this.circle,
      this.district,
      this.division,
      this.region,
      this.state,
      this.country});

  PostOffice.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    description = json['Description'];
    branchType = json['BranchType'];
    deliveryStatus = json['DeliveryStatus'];
    taluk = json['Taluk'];
    circle = json['Circle'];
    district = json['District'];
    division = json['Division'];
    region = json['Region'];
    state = json['State'];
    country = json['Country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Description'] = description;
    data['BranchType'] = branchType;
    data['DeliveryStatus'] = deliveryStatus;
    data['Taluk'] = taluk;
    data['Circle'] = circle;
    data['District'] = district;
    data['Division'] = division;
    data['Region'] = region;
    data['State'] = state;
    data['Country'] = country;
    return data;
  }
}
