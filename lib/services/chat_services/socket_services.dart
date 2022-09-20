import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/chat_contact_model.dart';
import 'package:hindustan_job/candidate/model/message_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/chatscreen.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'chat_services.dart';

class ChatingMessageChangeNotifier extends ChangeNotifier {
  ChatingMessageChangeNotifier();
  io.Socket? socket;
  int unseenMessagesCount = 0;
  List<Message> messages = [];
  List<ChatContact> contacts = [];
  List<ChatContact> openContacts = [];

  connectSocket() {
    socket = io.io('https://admin.hindustaanjobs.com/', <String, dynamic>{
      "path": "/hindustan-jobs",
      "transports": ["websocket"],
      "reconnect": true,
      "autoConnect": true,
    });
    socket!.onConnect((data) => print("connected" + data.toString()));
  }

  joinChannel(id) {
    socket!.emit('join', id);
  }

  getAllContacts(context) async {
    contacts = await fetchAllContacts(context);
    notifyListeners();
  }

  addOpenChatContact(ChatContact chatContact) {
    var obj = openContacts.where((element) => element.id == chatContact.id);
    if (openContacts.length > 2) {
      openContacts.removeLast();
      if (!openContacts.contains(chatContact)) {
        openContacts.add(chatContact);
      }
    } else {
      if (obj.isEmpty) {
        openContacts.add(chatContact);
      }
    }
    notifyListeners();
  }

  removeOpenChatContact(index) {
    openContacts.removeWhere((element) => element.id == openContacts[index].id);
    notifyListeners();
  }

  removeAllMessage() {
    messages = [];
    notifyListeners();
  }

  getMesssageCount(context) async {
    unseenMessagesCount = await getUnseenMessagesCount(context);
    notifyListeners();
  }

  getAllMessage(context, id, {page}) async {
    if (page != null && page > 1) {
      messages = [
        ...messages,
        ...await fetchAllMessages(context, channelId: id, page: page)
      ];
    } else {
      messages = await fetchAllMessages(context, channelId: id, page: 1);
    }
    notifyListeners();
  }

  createMessage(context, {message, receiverId, id}) async {
    var obj = {
      "sender_id": authUserId(),
      "receiver_id": receiverId,
      "user_role_type": userData!.userRoleType,
      "message": message
    };
    ApiResponse response = await sendMessages(context, msgObj: obj);
    var messageId = response.body!.data['id'];
    socket!.emit(
        'createMessage', {message, messageId, id, authUserId(), receiverId});
    if (response.status == 200) {
      messages.insert(0, Message(message: message, userId: authUserId()));
    }
    notifyListeners();
  }

  newMessageListner(context) {
    socket!.on('user_${authUserId()}', (data) {
      getMesssageCount(context);
      List<ChatContact> chatContact = contacts
          .where((element) =>
              element.senderId == data['senderId'] ||
              element.receiverId == data['senderId'])
          .toList();
      if (chatContact.isNotEmpty) {
        contacts.remove(chatContact.first);
        chatContact.first.chats!.first.message = data['message'];
        contacts.insert(0, chatContact.first);
      } else {
        getAllContacts(context);
      }
      notifyListeners();
    });
  }

  listenMessageNew(context, channelId) {
    offMessageListner(channelId);
    socket!.on('chat_channel_$channelId', (data) {
      if (channelId == int.parse(data['channelId'].toString())) {
        seenMessages(context,
            messageId: data['messageId'], channelId: channelId);
        getMesssageCount(context);
        messages.insert(
            0, Message(message: data['message'], userId: data['senderId']));

        notifyListeners();
      }
    });
  }

  offMessageListner(channelId) {
    socket!.off('chat_channel_$channelId');
    notifyListeners();
  }
}
