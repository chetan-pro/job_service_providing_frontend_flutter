import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/subscription_list.dart';
import 'package:hindustan_job/candidate/model/subscription_order.dart';
import 'package:hindustan_job/candidate/pages/dialog/subscribedialog.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';

Future fetchSubscriptionList(context, {planType}) async {
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  String url = SubscriptionApiString.subscriptionList;
  if (planType != null) {
    url = url + "?plan_type=$planType";
  }
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return SubscriptionList.fromJson(response.body!.data).subscription;
  } else {
    return <Subscription>[];
  }
}

Future createSubscriptionOrder(context, planData) async {
  String url = SubscriptionApiString.createSubscriptionorder;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  ApiResponse response =
      await ApiProvider.post(url: url, body: planData, headers: headers);

  if (response.status == 200) {
    return SubscriptionOrder.fromJson(response.body!.data);
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return SubscriptionOrder();
  }
}

Future verifySubscription(context, verificationData, {planDescription}) async {
  print("Verify Subscription");
  String url = SubscriptionApiString.paymentVerificationV2;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  ApiResponse response = await ApiProvider.post(
      url: url, body: verificationData, headers: headers);
  print("chetan ye bhi chl gya tha");
  print(response.status);
  print(response.body?.data);
  print(response.body?.message);
  print(response.status == 200);

  if (response.status == 200) {
    await showDialog(
        context: context,
        builder: (context) => SubsCribe(
              data: verificationData,
              description: planDescription,
            ));
    return showSnack(context: context, msg: SuccessAlertString.paymentSuccess);
  } else {
    // return showSnack(
    //     context: context, msg: response.body!.message, type: 'error');
  }
}

Future addResumeAccessData(context, addData) async {
  String url = SubscriptionApiString.addResumeAccessData;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, body: addData, headers: headers);
}

Future activateSubscribedPlans(subscriptionIdData) async {
  String url = SubscriptionApiString.activateSubscribedPlans;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(
      url: url, body: subscriptionIdData, headers: headers);
}
