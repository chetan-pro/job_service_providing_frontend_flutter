// ignore_for_file: override_on_non_overriding_member, annotate_overrides, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/chat_channel_model_object.dart';
import 'package:hindustan_job/candidate/model/message_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:hindustan_job/company/home/homepage.dart' as company;
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart'
    as candidate;

import 'package:hindustan_job/config/responsive.dart';

import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/types_constant.dart';
import 'package:hindustan_job/services/auth/auth.dart';

import 'package:hindustan_job/services/chat_services/chat_services.dart';
import 'package:hindustan_job/services/chat_services/socket_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/circle_image_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatScreen extends ConsumerStatefulWidget {
  UserData oppositeUser;
  bool isFromCandidateProfile;
  String? chatChannelId;
  int? index;
  ChatScreen({
    Key? key,
    required this.oppositeUser,
    this.chatChannelId,
    this.isFromCandidateProfile = false,
    this.index,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  TextEditingController typedmessage = TextEditingController();
  int page = 1;
  final chatingMessage =
      riverpod.ChangeNotifierProvider<ChatingMessageChangeNotifier>((ref) {
    return ChatingMessageChangeNotifier();
  });
  ChatChannelObjectModel? chatChannelObject;
  @override
  void initState() {
    ref.read(chatingMessage).connectSocket();
    createChannel(widget.oppositeUser);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    ref.read(chatingMessage).offMessageListner(chatChannelObject!.id);
  }

  createChannel(oppositeUser) async {
    ApiResponse response = await createChatChannel(context,
        senderId: authUserId(), receiverId: oppositeUser.id);
    if (response.status == 200) {
      chatChannelObject = ChatChannelObjectModel.fromJson(response.body!.data);
      fetchDataOfChat(chatChannelObject!.id);
    }
  }

  fetchDataOfChat(chatChannelId) {
    ref.read(chatingMessage).listenMessageNew(context, chatChannelId);
    ref.read(chatingMessage).joinChannel(chatChannelId);
    if (userData!.userRoleType != RoleTypeConstant.jobSeeker) {
      ref.read(company.chatingMessage).getAllContacts(context);
    }
    ref.read(chatingMessage).getAllMessage(context, chatChannelId, page: page);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _onLoading();
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    page += 1;
    ref
        .read(chatingMessage)
        .getAllMessage(context, widget.chatChannelId, page: page);
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    UserData oppositeUser = widget.oppositeUser;
    return Responsive.isDesktop(context)
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: MyAppColor.greynormal, width: 2),
              color: MyAppColor.whiteNormal,
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.2,
            ),
            margin: EdgeInsets.only(bottom: 20),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    color: MyAppColor.floatButtonColor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleImage(
                              image: oppositeUser.image.toString(),
                              width: 35,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${oppositeUser.name}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  oppositeUser.yourFullName ?? '',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11),
                                )
                              ],
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            print(widget.isFromCandidateProfile);
                            if (widget.isFromCandidateProfile) {
                              Navigator.pop(context);
                              return;
                            }
                            if (checkRoleType(userData!.userRoleType)) {
                              ref
                                  .read(company.chatingMessage)
                                  .removeOpenChatContact(widget.index);
                            } else {
                              ref
                                  .read(candidate.chatingMessage)
                                  .removeOpenChatContact(widget.index);
                            }
                          },
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    )),
                messageContainer(),
                chatButton(oppositeUser),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: MyAppColor.greynormal,
            appBar: appBar(oppositeUser),
            body: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                messageContainer(),
                chatButton(oppositeUser),
              ],
            )),
          );
  }

  chatButton(oppositeUser) {
    return Container(
      padding: Responsive.isDesktop(context)
          ? const EdgeInsets.all(0)
          : const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      width: double.infinity,
      color: Responsive.isDesktop(context)
          ? MyAppColor.whiteGrey
          : MyAppColor.white,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              controller: typedmessage,
              decoration: const InputDecoration(
                  hintText: "Write message...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              // if (checkRoleType(userData!.userRoleType)) {
              //   ref.read(company.chatingMessage).createMessage(context,
              //       message: typedmessage.text,
              //       id: widget.chatChannelId,
              //       receiverId: oppositeUser.id);
              // } else {
              ref.read(chatingMessage).createMessage(context,
                  message: typedmessage.text,
                  id: chatChannelObject!.id,
                  receiverId: oppositeUser.id);
              // }
              typedmessage.clear();
              FocusScope.of(context).unfocus();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyAppColor.floatButtonColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: MyAppColor.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  appBar(UserData oppositeUser) {
    return AppBar(
      toolbarHeight: 70,
      elevation: 0,
      backgroundColor: MyAppColor.lightBlue,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CircleImage(image: oppositeUser.image.toString()),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${oppositeUser.name}",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                oppositeUser.yourFullName ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              )
            ],
          )
        ],
      ),
    );
  }

  messageContainer() {
    return Consumer(builder: (context, ref, child) {
      List<Message> messages = ref.watch(chatingMessage).messages;
      return SizedBox(
          height: Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.height * 0.35
              : MediaQuery.of(context).size.height - 200,
          child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: false,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: () => _onLoading(),
              child: ListView(
                reverse: true,
                children: List.generate(
                  messages.length,
                  (index) {
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (messages[index].userId != authUserId()
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].userId == authUserId()
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            messages[index].message!,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )));
    });
  }
}
