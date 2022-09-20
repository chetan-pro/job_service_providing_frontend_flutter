import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/chat_contact_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/chatscreen.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/circle_image_widget.dart';

chatContactBox(context, chatingMessage) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      color: MyAppColor.white,
      width: double.infinity,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            color: MyAppColor.floatButtonColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("MY MESSAGES", style: whiteRegular14),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.cancel,
                    size: 18,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Consumer(builder: (context, ref, child) {
            List<ChatContact> chatContact = ref.watch(chatingMessage).contacts;
            return Column(
              children: List.generate(chatContact.length, (index) {
                UserData? oppositeUser = findOppositeUser(chatContact[index]);
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                  oppositeUser: oppositeUser,
                                  chatChannelId:
                                      chatContact[index].id.toString(),
                                )));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 6, bottom: 12, left: 12, right: 12),
                    margin: const EdgeInsets.only(bottom: 6),
                    width: double.infinity,
                    color: MyAppColor.greynormal,
                    child: Row(
                      children: [
                        CircleImage(image: oppositeUser.image.toString()),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${oppositeUser.name}",
                              style: blackDark13,
                            ),
                            if (chatContact[index].chats!.isNotEmpty)
                              Text(
                                "${formatDate(chatContact[index].chats![0].updatedAt)} | ${formatTime(chatContact[index].chats![0].updatedAt)}",
                                style: textDimLightGrey10,
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (chatContact[index].chats!.isNotEmpty)
                              Text(
                                "${chatContact[index].chats![0].message}",
                                style: greenMedium14,
                              )
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: MyAppColor.blackdark,
                        )
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    ),
  );
}

webChatContactBox(
  context,
  chatingMessage, {
  bool isSingle = false,
  oppositeUserData,
}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (oppositeUserData != null)
                  Row(
                      children: List.generate(
                          1,
                          (index) => Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: ChatScreen(
                                  isFromCandidateProfile: isSingle,
                                  oppositeUser: oppositeUserData,
                                ),
                              ))),
                Consumer(builder: (context, ref, child) {
                  List<ChatContact> openChatContact =
                      ref.watch(chatingMessage).openContacts;
                  return Row(
                      children: List.generate(
                          openChatContact.length,
                          (index) => Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: ChatScreen(
                                  isFromCandidateProfile: isSingle,
                                  oppositeUser:
                                      findOppositeUser(openChatContact[index]),
                                  index: index,
                                  chatChannelId:
                                      openChatContact[index].id.toString(),
                                ),
                              )));
                }),
                if (!isSingle)
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: MyAppColor.greynormal, width: 2),
                      color: MyAppColor.whiteNormal,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.2,
                    ),
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          color: MyAppColor.floatButtonColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("MY MESSAGES", style: whiteRegular14),
                              InkWell(
                                onTap: () {
                                  
                                  ('cancel');
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Consumer(builder: (context, ref, child) {
                          List<ChatContact> chatContact =
                              ref.watch(chatingMessage).contacts;
                          return Column(
                            children:
                                List.generate(chatContact.length, (index) {
                              UserData? oppositeUser =
                                  findOppositeUser(chatContact[index]);
                              return InkWell(
                                onTap: () {
                                  if (Responsive.isDesktop(context)) {
                                    ref
                                        .read(chatingMessage)
                                        .addOpenChatContact(chatContact[index]);
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                  oppositeUser: oppositeUser,
                                                  chatChannelId:
                                                      chatContact[index]
                                                          .id
                                                          .toString(),
                                                )));
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 6, bottom: 12, left: 12, right: 12),
                                  margin: const EdgeInsets.only(bottom: 6),
                                  width: double.infinity,
                                  color: MyAppColor.greynormal,
                                  child: Row(
                                    children: [
                                      CircleImage(
                                          image: oppositeUser.image.toString()),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${oppositeUser.name}",
                                            style: blackDark13,
                                          ),
                                          if (chatContact[index]
                                              .chats!
                                              .isNotEmpty)
                                            Text(
                                              "${formatDate(chatContact[index].chats![0].updatedAt)} | ${formatTime(chatContact[index].chats![0].updatedAt)}",
                                              style: textDimLightGrey10,
                                            ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (chatContact[index]
                                              .chats!
                                              .isNotEmpty)
                                            Text(
                                              "${chatContact[index].chats![0].message}",
                                              style: greenMedium14,
                                            )
                                        ],
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 15,
                                        color: MyAppColor.blackdark,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      ],
                    ),
                  )
              ])));
}
