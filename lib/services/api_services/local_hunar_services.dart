import '../api_provider/api_provider.dart';
import '../auth/auth.dart';
import '../services_constant/api_string_constant.dart';

Future getLocalHunarVideo({id}) async {
  String url = LocalHunar.getLocalHunarVideo;
  if (id != null) {
    url = url + "?video_id=$id";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(url, headers: headers);
}

Future getAllLocalHunarVideo({page, sortBy, view}) async {
  String url = LocalHunar.getLocalHunarVideo + '?';
  if (sortBy != null) {
    url = url + "sortBy=$sortBy&";
  }
  if (page != null) {
    url = url + "page=$page&";
  }
  if (view != null) {
    url = url + "view=$view&";
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(url, headers: headers);
}

Future getDashboardLocalHunar() async {
  String url = LocalHunar.getDashboardDetailsLocalHunar;

  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(url, headers: headers);
}

Future addLocalHunarvideo(body) async {
  String url = LocalHunar.addLocalHunarvideo;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: url, body: body, media: true, headers: headers);
}

Future editLocalHunarVideo({id, body}) async {
  String url = LocalHunar.editLocalHunarVideo;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: url, body: body, media: true, headers: headers);
}

Future deleteLocalHunarVideo(id) async {
  String url = LocalHunar.deleteLocalHunarVideo + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.delete(url, headers: headers);
}

Future addViewsLocalHunarVideo(id) async {
  String url = LocalHunar.addViewsLocalHunarVideo + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(url, headers: headers);
}
