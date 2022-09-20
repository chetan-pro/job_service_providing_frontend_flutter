import 'package:hindustan_job/candidate/model/serviceProviderModal/alldata_get_modal.dart';

class Days {
  int? count;
  List<ServiceDays>? rows;

  Days({this.count, this.rows});

  Days.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <ServiceDays>[];
      json['rows'].forEach((v) {
        rows!.add(new ServiceDays.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


