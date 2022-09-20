import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';

Future getHomepageVisibleCompany({flag}) async {
  String url = HomePageString.getHomepageVisibleCompany;
  if (flag) {
    url = url + "?visibility=Y";
  }
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return UserDataModel.fromJson(response.body!.data).userData;
  } else {
    return <UserData>[];
  }
}
