import 'package:hindustan_job/candidate/model/chat_contact_model.dart';
import 'package:hindustan_job/candidate/model/message_model.dart';
import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';

Future fetchAllContacts(context) async {
  String url = Chating.getAllContacts;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return ChatContactModel.fromJson(response.body!.data).chatContact;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <ChatContact>[];
  }
}

Future fetchAllMessages(context, {channelId, page}) async {
  String url = Chating.getMessages + "?chat_channel_id=$channelId&";
  if (page != null) {
    url = url + 'page=$page&sortBy=DESC';
  }
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  ApiResponse response = await ApiProvider.get(url, headers: headers);

  if (response.status == 200) {
    return MessageModel.fromJson(response.body!.data).message;
  } else {
    // showSnack(context: context, msg: response.body!.message, type: 'error');
    return <Message>[];
  }
}

Future getUnseenMessagesCount(context) async {
  String url = Chating.getUnseenMessagesCount;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  ApiResponse response = await ApiProvider.get(url, headers: headers);
  if (response.status == 200) {
    return response.body!.data;
  } else {
    return 0;
  }
}

Future seenMessages(context, {messageId, channelId}) async {
  var body = {"message_id": messageId, "channel_id": channelId};
  String url = Chating.seenMessage;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };

  await ApiProvider.post(url: url, body: body, headers: headers);
}

Future sendMessages(context, {msgObj}) async {
  String url = Chating.sendMessage;
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, headers: headers, body: msgObj,loaderShow: false);
}

Future createChatChannel(context, {senderId, receiverId}) async {
  String url = Chating.createChannel;
  var chatData = {
    "sender_id": senderId,
    "receiver_id": receiverId,
  };
  Map<String, String> headers = {
    "Authorization": "Bearer " + userData!.resetToken.toString()
  };
  return await ApiProvider.post(url: url, headers: headers, body: chatData);
}
