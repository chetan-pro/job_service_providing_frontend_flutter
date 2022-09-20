import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';

Future getResume(context) async {
  String url = ResumseString.getResume ;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(url, headers: headers);
}

Future resumeCreate(context, body) async {
  String url = ResumseString.resumeCreate;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: url, body: body, media: true, headers: headers);
}

Future resumeUpdate(context, body, {id}) async {
  String url = ResumseString.resumeUpdate + '/$id';
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: url, body: body, media: true, headers: headers);
}

Future resumeEducationCreate(context, body) async {
  String url = ResumseString.resumeEducationCreate;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeEducationUpdate(context, {body, id}) async {
  String url = ResumseString.resumeEducationUpdate + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeEducationDelete(context, {id}) async {
  String url = ResumseString.resumeEducationDelete + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.delete(url, headers: headers);
}

Future resumeExperienceCreate(context, body) async {
  String url = ResumseString.resumeExperienceCreate;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeExperienceUpdate(context, {body, id}) async {
  String url = ResumseString.resumeExperienceUpdate + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeExperienceDelete(context, {id}) async {
  String url = ResumseString.resumeExperienceDelete + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.delete(url, headers: headers);
}

Future resumeHobbiesCreate(context, body) async {
  String url = ResumseString.resumeHobbiesCreate;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeHobbiesUpdate(context, {body, id}) async {
  String url = ResumseString.resumeHobbiesUpdate + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeHobbiesDelete(context, {id}) async {
  String url = ResumseString.resumeHobbiesDelete + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.delete(url, headers: headers);
}

Future resumeReferenceCreate(context, body) async {
  String url = ResumseString.resumeReferenceCreate;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeReferenceUpdate(context, {body, id}) async {
  String url = ResumseString.resumeReferenceUpdate + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeReferenceDelete(context, {id}) async {
  String url = ResumseString.resumeReferenceDelete + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.delete(url, headers: headers);
}

Future resumeSkillsCreate(context, body) async {
  String url = ResumseString.resumeSkillsCreate;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeSkillsUpdate(context, {body, id}) async {
  String url = ResumseString.resumeSkillsUpdate + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: body, headers: headers);
}

Future resumeSkillsDelete(context, {id}) async {
  String url = ResumseString.resumeSkillsDelete + "/$id";
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.delete(url, headers: headers);
}
