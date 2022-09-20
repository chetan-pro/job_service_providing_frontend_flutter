import 'package:hindustan_job/candidate/model/commision_model.dart';
import 'package:hindustan_job/candidate/model/registree_details_model.dart';
import 'package:hindustan_job/candidate/model/registree_model.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';

import '../../candidate/model/business_correspondance_count_model.dart';
import '../auth/auth.dart';

Future getBusinessCorrespondanceDashboardData() async {
  String url =
      BusinessCorrespondanceString.getMiscellaneousUserDashboardDetails;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.post(url: url, headers: headers);

  if (response.status == 200) {
    return BusinessCorrespondanceCountModel.fromJson(response.body!.data);
  } else {
    return BusinessCorrespondanceCountModel();
  }
}

Future getBusinessCorrespondanceCommisionData() async {
  String url =
      BusinessCorrespondanceString.getMiscellaneousUserCommissionDetails;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return CommisionModel.fromJson(response.body!.data);
  } else {
    return CommisionModel();
  }
}

Future getMiscellaneousUserRegistreeDetails(
    {userRoleType, userId, sortBy, status}) async {
  String url =
      BusinessCorrespondanceString.getMiscellaneousUserRegistreeDetails;
  if (userRoleType != null) {
    url = url + "?user_role_type=$userRoleType";
  }

  if (userId != null) {
    url = url + "?user_id=$userId";
  }
  if (sortBy != null) {
    url = url + "&sortBy=$sortBy";
  }
  if (status != null) {
    url = url + "&status=$status";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);

  if (response.status == 200) {
    if (userId != null) {
      return RegistreeDetailsModel.fromJson(response.body!.data);
    }
    return RegistreeModel.fromJson(response.body!.data);
  } else {
    if (userId != null) {
      return RegistreeDetailsModel();
    }
    return RegistreeModel();
  }
}
