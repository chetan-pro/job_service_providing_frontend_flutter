import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/company_list_model.dart';
import 'package:hindustan_job/candidate/model/course_model.dart';
import 'package:hindustan_job/candidate/model/education_model.dart';
import 'package:hindustan_job/candidate/model/ifsc_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
import 'package:hindustan_job/candidate/model/job_type_model.dart';
import 'package:hindustan_job/candidate/model/language_model.dart';
import 'package:hindustan_job/candidate/model/location_pincode_model.dart';
import 'package:hindustan_job/candidate/model/notification_model.dart';
import 'package:hindustan_job/candidate/model/role_model.dart';
import 'package:hindustan_job/candidate/model/sector_model.dart';
import 'package:hindustan_job/services/services_constant/constant.dart'
    as constant;
import 'package:hindustan_job/candidate/model/skill_category.dart';
import 'package:hindustan_job/candidate/model/skill_sub_category_model.dart';
import 'package:hindustan_job/candidate/model/specialization_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/subscription_list.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:http/http.dart' as http;

Future fetchRoles(context) async {
  ApiResponse response = await ApiProvider.get(DataApiString.roleList);
  if (response.status == 200) {
    return RoleModel.fromJson(response.body!.data).roles;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Roles>[];
  }
}

Future fetchLocationOnBasisOfPinCode(context, pincode) async {
  ApiResponse response =
      await ApiProvider.get("pin-code-details?pin_code=$pincode");
  if (response.status == 200) {
    return PincodeLocationModel.fromJson(response.body!.data).postOffice;
  } else {
    // showSnack(context: context, msg: "response.body!.message", type: 'error');
    return <PostOffice>[];
  }
}

Future fetchIFSCDetail(context, ifsc) async {
  return await Dio().get(ApiString.getIFSC + '$ifsc');
}

Future fetchStates(context, {filterByName}) async {
  ApiResponse response = await ApiProvider.get(
      DataApiString.stateList + "?filter_by_name=${filterByName ?? ''}");
  if (response.status == 200) {
    return StateModel.fromJson(response.body!.data).states;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <States>[];
  }
}

Future fetchCities(context, {stateId, filterByName, page}) async {
  String url = '';
  if (stateId != null && stateId != 'null') {
    url = DataApiString.cityList +
        "?state_id=$stateId" +
        "&search=${filterByName ?? ''}";
  } else {
    url = DataApiString.cityList + "?page=1" + "&search=${filterByName ?? ''}";
  }

  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return CityModel.fromJson(response.body!.data).cities;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <City>[];
  }
}

Future fetchJobRoleType(
  context,
) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = DataApiString.jobRoleType;
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return IndustryModel.fromJson(response.body!.data).industry;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Industry>[];
  }
}

Future fetchIndustry(
  context,
) async {
  String url = DataApiString.industry;
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return IndustryModel.fromJson(response.body!.data).industry;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Industry>[];
  }
}

Future fetchCompany(
  context,
) async {
  String url = DataApiString.companyList;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return CompanyListModel.fromJson(response.body!.data).companyList;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <UserData>[];
  }
}

Future fetchSector(context, {industryId}) async {
  String url = DataApiString.sector + "?industry_id=${industryId.toString()}";
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return SectorModel.fromJson(response.body!.data).sector;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Sector>[];
  }
}

Future fetchSkillCategory(
  context,
) async {
  String url = DataApiString.skillCategoryList;
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return SkillCategory.fromJson(response.body!.data).skill;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Skill>[];
  }
}

Future fetchSubSkillsCategory(context, {categoryId}) async {
  String url = DataApiString.subSkillList + "/${categoryId.toString()}";
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return SkillSubCategory.fromJson(response.body!.data).subSkill;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <SubSkill>[];
  }
}

Future fetchLanguages(context) async {
  String url = DataApiString.language;
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return LanguageModel.fromJson(response.body!.data).language;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Language>[];
  }
}

Future fetchCourse(context, {educationId}) async {
  String url = DataApiString.course;
  if (educationId != null) {
    url = url + '?education_id=$educationId';
  }
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return CourseModel.fromJson(response.body!.data).course;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Course>[];
  }
}

Future fetchCourseSpecialization(context, {courseId}) async {
  String url = DataApiString.specialization + "/$courseId";
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return SpecializationModel.fromJson(response.body!.data).specialization;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Specialization>[];
  }
}

Future fetchEducations(context) async {
  String url = DataApiString.education;
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return EducationModel.fromJson(response.body!.data).education;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Education>[];
  }
}

Future fetchJobTypes(context) async {
  String url = DataApiString.jobType;
  ApiResponse response = await ApiProvider.get(url);
  if (response.status == 200) {
    return JobTypeModel.fromJson(response.body!.data).jobType;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <JobType>[];
  }
}

Future getNotificationUnreadCount() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.getUnreadNotificationCount;
  return await ApiProvider.get(url, headers: headers);
}

Future getNotification({page}) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.getNotification + "?page=$page";
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return NotificationModel.fromJson(response.body!.data).notification;
  } else {
    return <Notifications>[];
  }
}

Future deleteNotificaton({id}) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.deleteNotification;
  if (id != null) {
    url = url + "?id=$id";
  }
  return await ApiProvider.delete(url, headers: headers);
}
