class CompanyDashboardModel {
  List<GraphData>? graphData;
  int? unreadMessageCount;
  int? receivedPendingRequest;
  int? totalActiveJob;
  int? newAcceptedOffer;

  CompanyDashboardModel(
      {this.graphData,
      this.unreadMessageCount,
      this.receivedPendingRequest,
      this.totalActiveJob,
      this.newAcceptedOffer});

  CompanyDashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['graphData'] != null) {
      graphData = <GraphData>[];
      json['graphData'].forEach((v) {
        graphData!.add(GraphData.fromJson(v));
      });
    }
    unreadMessageCount = json['unreadMessageCount'];
    receivedPendingRequest = json['receivedPendingRequest'];
    totalActiveJob = json['totalActiveJob'];
    newAcceptedOffer = json['newAcceptedOffer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (graphData != null) {
      data['graphData'] = graphData!.map((v) => v.toJson()).toList();
    }
    data['unreadMessageCount'] = unreadMessageCount;
    data['receivedPendingRequest'] = receivedPendingRequest;
    data['totalActiveJob'] = totalActiveJob;
    data['newAcceptedOffer'] = newAcceptedOffer;
    return data;
  }
}

class GraphData {
  int? monthCount;
  int? mONTHUserAppliedJobsCreatedAt;
  int? count;

  GraphData({this.monthCount, this.mONTHUserAppliedJobsCreatedAt, this.count});

  GraphData.fromJson(Map<String, dynamic> json) {
    monthCount = json['MonthCount'];
    mONTHUserAppliedJobsCreatedAt =
        json['MONTH(`UserAppliedJobs`.`createdAt`)'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MonthCount'] = monthCount;
    data['MONTH(`UserAppliedJobs`.`createdAt`)'] =
        mONTHUserAppliedJobsCreatedAt;
    data['count'] = count;
    return data;
  }
}
