class ServiceProviderDashboard {
  List<GrapData>? grapData;
  int? serviceProviderServiceCount;
  int? serviceProviderBranchCount;
  List<RequestData>? requestData;

  ServiceProviderDashboard(
      {this.grapData,
      this.serviceProviderServiceCount,
      this.serviceProviderBranchCount,
      this.requestData});

  ServiceProviderDashboard.fromJson(Map<String, dynamic> json) {
    if (json['grapData'] != null) {
      grapData = <GrapData>[];
      json['grapData'].forEach((v) {
        grapData!.add(new GrapData.fromJson(v));
      });
    }
    serviceProviderServiceCount = json['serviceProviderServiceCount'];
    serviceProviderBranchCount = json['serviceProviderBranchCount'];
    if (json['requestData'] != null) {
      requestData = <RequestData>[];
      json['requestData'].forEach((v) {
        requestData!.add(new RequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.grapData != null) {
      data['grapData'] = this.grapData!.map((v) => v.toJson()).toList();
    }
    data['serviceProviderServiceCount'] = this.serviceProviderServiceCount;
    data['serviceProviderBranchCount'] = this.serviceProviderBranchCount;
    if (this.requestData != null) {
      data['requestData'] = this.requestData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GrapData {
  int? monthCount;
  int? completedRequestCount;
  String? serviceProviderStatus;
  int? count;

  GrapData(
      {this.monthCount,
      this.completedRequestCount,
      this.serviceProviderStatus,
      this.count});

  GrapData.fromJson(Map<String, dynamic> json) {
    monthCount = json['MonthCount'];
    completedRequestCount = json['completedRequestCount'];
    serviceProviderStatus = json['service_provider_status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MonthCount'] = this.monthCount;
    data['completedRequestCount'] = this.completedRequestCount;
    data['service_provider_status'] = this.serviceProviderStatus;
    data['count'] = this.count;
    return data;
  }
}

class RequestData {
  String? serviceProviderStatus;
  int? count;

  RequestData({this.serviceProviderStatus, this.count});

  RequestData.fromJson(Map<String, dynamic> json) {
    serviceProviderStatus = json['service_provider_status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_provider_status'] = this.serviceProviderStatus;
    data['count'] = this.count;
    return data;
  }
}
