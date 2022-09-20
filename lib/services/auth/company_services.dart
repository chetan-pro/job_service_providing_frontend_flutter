import 'package:hindustan_job/candidate/model/company_dashboard_model.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';

Future getCompanyDashBoardData() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.getCompanyDashboard + '?year=2022';
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return CompanyDashboardModel.fromJson(response.body!.data);
  } else {
    return CompanyDashboardModel();
  }
}

Future getCompanyPage(id) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.companyPage + '/$id';
  return await ApiProvider.get(url, headers: headers);
}

Future updateCompanyOverview(data) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: ApiString.updateCompanyOverView, body: data, headers: headers);
}
