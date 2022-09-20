import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hindustan_job/candidate/model/language_model.dart';
import 'package:http/http.dart' as http;

import 'package:hindustan_job/candidate/model/certificate_experience_model.dart';
import 'package:hindustan_job/candidate/model/company_image_model.dart';
import 'package:hindustan_job/candidate/model/current_job_model.dart';
import 'package:hindustan_job/candidate/model/education_experience_model.dart';
import 'package:hindustan_job/candidate/model/user_language_model.dart';
import 'package:hindustan_job/candidate/model/work_experience_model.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'profile',
    'email',
  ],
);

// Create an instance of FacebookLogin
Future facebookSocialLogin() async {
  try {
    if (kIsWeb) {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        Map<String, dynamic> user = await FacebookAuth.instance.getUserData();
        final AccessToken accessToken = result.accessToken!;
        var facebookLoginData = {
          "name": user['name'],
          "social_login_type": "2",
          "social_login_id": accessToken.userId,
          "image": user['picture']['data']['url']
        };
        if (user['email'] != null) {
          facebookLoginData['email'] = user['email'];
        }
        ApiResponse response = await socialSignUp(facebookLoginData);
        return response;
      }
    } else {
      final fb = FacebookLogin();
      fb.logOut();
      var res = await fb.expressLogin();
      if (res.status == FacebookLoginStatus.success) {
        final profile = await fb.getUserProfile();
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        final email = await fb.getUserEmail();
        var facebookLoginData = {
          "name": profile!.name,
          "social_login_type": "2",
          "social_login_id": profile.userId,
          "image": imageUrl
        };
        if (email != null) {
          facebookLoginData['email'] = email;
        }
        ApiResponse response = await socialSignUp(facebookLoginData);
        return response;
      }
    }
  } catch (error) {
    return ApiResponse.fromJson({'status': 500, 'body': 'Facebook Auth Error'});
  }
}

Future googleSocialLogin() async {
  try {
    return await _googleSignIn.signIn().then((value) async {
      print(value);
      print("check chetan");
      var googleLoginData = {
        "name": value!.displayName,
        "email": value.email,
        "social_login_type": "1",
        "social_login_id": value.id,
        "image": value.photoUrl
      };
      print(googleLoginData);
      ApiResponse response = await socialSignUp(googleLoginData);
      return response;
    });
  } catch (error) {
    print("error google here");
    print(error);
    return ApiResponse.fromJson({'status': 500, 'body': 'Google Auth Error'});
  }
}

Future socialSignUp(
  socialSignUpData,
) async {
  return ApiProvider.post(url: ApiString.socialSignUp, body: socialSignUpData);
}

Future signUp(signUpData) async {
  return ApiProvider.post(url: ApiString.signUp, body: signUpData, media: true);
}

Future socialUpdateSignUp(signUpData, token) async {
  Map<String, String> headers = {"Authorization": "Bearer " + token.toString()};

  return ApiProvider.post(
      url: ApiString.updateSocialSignUp,
      body: signUpData,
      headers: headers,
      media: true);
}

Future register(registerData, {media}) async {
  EasyLoading.show(status: "Loading...");

  return await ApiProvider.post(
      url: ApiString.companyRegister, body: registerData, media: true);
}

Future socialUpdateRegister(registerData, token, {media}) async {
  Map<String, String> headers = {"Authorization": "Bearer " + token.toString()};

  return await ApiProvider.post(
      url: ApiString.updateSocialCompanyRegister,
      body: registerData,
      headers: headers,
      media: true);
}

Future login(authData) async {
  EasyLoading.show(status: "Loading...");
  return await ApiProvider.post(
    url: ApiString.login,
    body: authData,
  );
}

Future getProfile(token) async {
  Map<String, String> headers = {"Authorization": "Bearer " + token.toString()};
  return await ApiProvider.get(ApiString.userProfile, headers: headers);
}

Future forgetPassword(forgetData) async {
  return await ApiProvider.post(
      url: ApiString.forgetPassword, body: forgetData);
}

Future emailOTPVerification(otpData) async {
  return await ApiProvider.post(url: ApiString.otpVerification, body: otpData);
}

Future fcmTokenAdded(fcmToken) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  print("testing");
  print(fcmToken);
  return await ApiProvider.post(
      url: ApiString.fcmTokenAdd,
      body: fcmToken,
      headers: headers,
      isSendNullValue: true);
}

Future resendOTP(resendData) async {
  return await ApiProvider.post(url: ApiString.resendOTP, body: resendData);
}

Future resetPassword(resetPasswordData) async {
  return await ApiProvider.post(
    url: ApiString.resetPassword,
    body: resetPasswordData,
  );
}

Future changePassword(changePasswordData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
    url: ApiString.changePassword,
    headers: headers,
    body: changePasswordData,
  );
}

Future changeRoleType(roleType) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
    url: ApiString.changeRoleType,
    headers: headers,
    body: {"user_role_type": roleType},
  );
}

Future editUserProfile(editData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: ApiString.userEditProfile,
      body: editData,
      media: true,
      headers: headers);
}

Future addMiscellaneousUserPersonalDetails(personalData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: ApiString.addMiscellaneousUserPersonalDetails,
      body: personalData,
      media: true,
      headers: headers);
}

Future editMiscellaneousUserPersonalDetails(personalData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: ApiString.editMiscellaneousUserPersonalDetails,
      body: personalData,
      media: true,
      headers: headers);
}

Future addMiscellaneousUserCurrentBussinessDetails(businessData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: ApiString.addMiscellaneousUserCurrentBussinessDetails,
      body: businessData,
      media: true,
      headers: headers);
}

Future addMiscellaneousUserCustomerDetails(customerData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: ApiString.addMiscellaneousUserCustomerDetails,
      body: customerData,
      headers: headers);
}

Future getMiscellaneousUserPersonalDetails() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.get(ApiString.getMiscellaneousUserPersonalDetails,
      headers: headers);
}

Future getMiscellaneousUserBussinessDetails() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.get(ApiString.getMiscellaneousUserBussinessDetails,
      headers: headers);
}

Future editCompanyProfile(editData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: ApiString.companyEditProfile,
      body: editData,
      media: true,
      headers: headers);
}

Future addUserLanguage(languageData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: ApiString.addLanguage, body: languageData, headers: headers);
}

Future deleteUserLanguage(languageId) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.deleteLanguage + "/$languageId";
  return await ApiProvider.delete(url, headers: headers);
}

Future fetchUserLanguage(context) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.getLanguage;
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return UserLanguageModel.fromJson(response.body!.data).userLanguage;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Language>[];
  }
}

Future addWorkExperience(workExpData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: ApiString.addWorkExp, body: workExpData, headers: headers);
}

Future editWorkExperience(workExpData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
      url: ApiString.editWorkExp, body: workExpData, headers: headers);
}

Future deleteWorkExperience(workExpId) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.deleteWorkExp + "/$workExpId";
  return await ApiProvider.delete(url, headers: headers);
}

Future fetchWorkExp(context) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.getWorkExp;
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return WorkExperienceModel.fromJson(response.body!.data).workExperience;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <WorkExperience>[];
  }
}

Future addEducationExperience(educationExpData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: ApiString.addEducationExp, body: educationExpData, headers: headers);
}

Future editEducationExperience(educationExpData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: ApiString.editEducationExp,
      body: educationExpData,
      headers: headers);
}

Future deleteEducationExperience(educationExpId) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.deleteEducationExp + "/$educationExpId";
  return await ApiProvider.delete(url, headers: headers);
}

Future fetchEducationExp(context) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.getEducationExp;
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return EducationExperienceModel.fromJson(response.body!.data)
        .educationExperience;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <EducationExperience>[];
  }
}

Future addCompanyImages(companyImageData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: ApiString.addCompanyImage,
      body: companyImageData,
      headers: headers,
      media: true);
}

Future deleteCompanyImages(companyImageId) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.deleteCompanyImage + "/$companyImageId";
  return await ApiProvider.delete(url, headers: headers);
}

Future fetchCompanyImage(context) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.getCompanyImage;
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return CompanyImageModel.fromJson(response.body!.data).companyImage;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <CompanyImage>[];
  }
}

Future availableForJob(flag) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  return await ApiProvider.post(
    url: ApiString.updateAvailableForJob,
    body: {"is_user_available": "$flag"},
    headers: headers,
  );
}

Future getStatusAvailableForJob() async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.get(
    ApiString.getStatusAvailableForJob,
    headers: headers,
  );
}

Future addCertificates(certificateData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: ApiString.addCertificate,
      body: certificateData,
      headers: headers,
      media: true);
}

Future editCertificates(certificateData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: ApiString.editCertificate,
      body: certificateData,
      headers: headers,
      media: true);
}

Future deleteCertificate(certificateId) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.deleteCertificate + "/$certificateId";
  return await ApiProvider.delete(url, headers: headers);
}

Future fetchCertificateExp(context) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.getCertificateExp;
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return CertificateExperienceModel.fromJson(response.body!.data)
        .certificateExperience;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <CertificateExperience>[];
  }
}

Future addCurrentJobDetails(currentJobData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
    url: ApiString.addCurrentJobDetails,
    body: currentJobData,
    headers: headers,
  );
}

Future editCurrentJobDetails(currentJobData) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
    url: ApiString.editCurrentJobDetails,
    body: currentJobData,
    headers: headers,
  );
}

Future fetchCurrentJobDetails(context) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.getCurrentJobDetails;
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return CurrentJobModel.fromJson(response.body!.data);
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return null;
  }
}

Future deleteCurrentJobDetails(context, id) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  String url = ApiString.deleteCurrentJobDetails + "/$id";
  ApiResponse response = await ApiProvider.delete(url, headers: headers);
  if (response.status == 200) {
    showSnack(context: context, msg: "Your work experience added successfully");
    return CurrentJobModel();
  } else {
    showSnack(context: context, msg: response.body!.message, type: 'error');
    return CurrentJobModel();
  }
}
