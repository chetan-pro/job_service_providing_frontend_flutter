import 'package:flutter/cupertino.dart';
import 'package:hindustan_job/services/api_services/local_hunar_services.dart';

import '../localHunarAccount/model/local_hunar_video_model.dart';
import '../services/services_constant/response_model.dart';

class LocalHunarChangeNotifier extends ChangeNotifier {
  LocalHunarChangeNotifier();

  List<LocalHunarVideo> localHunarVideos = [];
  List<LocalHunarVideo> filterLocalHunarVideos = [];
  int videoUploadedThisMonthCount = 0;
  int totalViewsThisMonth = 0;
  int totalVideosUploaded = 0;
  int totalViewsOfAllTime = 0;

  getAllCountData() async {
    ApiResponse response = await getDashboardLocalHunar();
    if (response.status == 200) {
      videoUploadedThisMonthCount =
          response.body!.data['videoUploadedThisMonthCount'];
      totalViewsThisMonth = response.body!.data['totalViewsThisMonth'];
      totalVideosUploaded = response.body!.data['totalVideosUploaded'];
      totalViewsOfAllTime = response.body!.data['totalViewsOfAllTime'];
      notifyListeners();
    }
  }

  getFilterLocalHunarVideos({sortBy}) async {
    ApiResponse response = await getAllLocalHunarVideo(sortBy:sortBy);
    if (response.status == 200) {
      filterLocalHunarVideos =
          LocalHunarVideoModel.fromJson(response.body!.data).localHunarVideo!;
      notifyListeners();
    }
  }

  getMyLocalHunarVideo() async {
    ApiResponse response = await getLocalHunarVideo();
    if (response.status == 200) {
      localHunarVideos =
          LocalHunarVideoModel.fromJson(response.body!.data).localHunarVideo!;
      notifyListeners();
    }
  }

  deleteHunarVideo(id) async {
    ApiResponse response = await deleteLocalHunarVideo(id);
    if (response.status == 200) {
      localHunarVideos.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }
}
