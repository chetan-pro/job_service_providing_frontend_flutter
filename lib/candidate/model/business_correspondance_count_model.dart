class BusinessCorrespondanceCountModel {
  List<BusinessCorrespondanceCount>? businessCorrespondanceCount;
  dynamic totalCommission;
  dynamic totalNumberRegistrees;
  dynamic totalBussinessCorrespondence;
  dynamic newCommission;

  BusinessCorrespondanceCountModel(
      {this.businessCorrespondanceCount,
      this.totalCommission,
      this.totalNumberRegistrees,
      this.totalBussinessCorrespondence,
      this.newCommission});

  BusinessCorrespondanceCountModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      businessCorrespondanceCount = <BusinessCorrespondanceCount>[];
      json['data'].forEach((v) {
        businessCorrespondanceCount!
            .add(BusinessCorrespondanceCount.fromJson(v));
      });
    }
    totalCommission = json['total_commission'];
    totalNumberRegistrees = json['total_number_registrees'];
    totalBussinessCorrespondence = json['total_bussiness_correspondence'];
    newCommission = json['newCommission'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (businessCorrespondanceCount != null) {
      data['data'] =
          businessCorrespondanceCount!.map((v) => v.toJson()).toList();
    }
    data['total_commission'] = totalCommission;
    data['total_number_registrees'] = totalNumberRegistrees;
    data['total_bussiness_correspondence'] = totalBussinessCorrespondence;
    data['newCommission'] = newCommission;
    return data;
  }
}

class BusinessCorrespondanceCount {
  int? registreesCurrentlyOnSubscription;
  int? registreesCurrentlyNotOnSubscription;
  int? newRegistreesAddedLastMonth;
  String? userRoleType;
  int? count;

  BusinessCorrespondanceCount(
      {this.registreesCurrentlyOnSubscription,
      this.registreesCurrentlyNotOnSubscription,
      this.newRegistreesAddedLastMonth,
      this.userRoleType,
      this.count});

  BusinessCorrespondanceCount.fromJson(Map<String, dynamic> json) {
    registreesCurrentlyOnSubscription =
        json['registrees_currently_on_subscription'];
    registreesCurrentlyNotOnSubscription =
        json['registrees_currently_not_on_subscription'];

    newRegistreesAddedLastMonth = json['new_registrees_added_last_month'];
    userRoleType = json['userRoleTableRole'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['registrees_currently_on_subscription'] =
        registreesCurrentlyOnSubscription;

    data['registrees_currently_not_on_subscription'] =
        registreesCurrentlyNotOnSubscription;

    data['new_registrees_added_last_month'] = newRegistreesAddedLastMonth;
    data['userRoleTableRole'] = userRoleType;
    data['count'] = count;
    return data;
  }
}
